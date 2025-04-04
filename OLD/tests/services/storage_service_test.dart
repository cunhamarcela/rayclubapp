import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ray_club_app/services/storage_service.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/core/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;

// Classe simulada para SupabaseClient
class MockSupabaseClient extends Mock implements SupabaseClient {
  final MockStorageClient storageMock = MockStorageClient();
  
  @override
  SupabaseStorageClient get storage => storageMock;
}

// Classe simulada para SupabaseStorageClient
class MockStorageClient extends Mock implements SupabaseStorageClient {
  final Map<String, MockBucket> buckets = {};

  @override
  Future<List<Bucket>> listBuckets() async {
    return buckets.entries.map((entry) => 
      Bucket(id: entry.key, name: entry.key, public: true, createdAt: '2023-01-01')
    ).toList();
  }
  
  @override
  Future<void> createBucket(String name, BucketOptions options) async {
    buckets[name] = MockBucket();
  }
  
  @override
  StorageClientBucket from(String bucket) {
    return buckets[bucket] ?? MockBucket();
  }
}

// Classe simulada para StorageClientBucket
class MockBucket extends Mock implements StorageClientBucket {
  final Map<String, Uint8List> storedFiles = {};
  final List<FileObject> fileObjects = [];

  @override
  Future<void> upload(String path, File file, {FileOptions? fileOptions}) async {
    // Simular leitura do arquivo
    storedFiles[path] = await file.readAsBytes();
    fileObjects.add(FileObject(
      name: path.split('/').last,
      id: path,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      bucketId: 'test-bucket',
      owner: '',
      size: storedFiles[path]!.length,
      metadata: {}
    ));
  }

  @override
  Future<void> uploadBinary(String path, Uint8List data, {FileOptions? fileOptions}) async {
    storedFiles[path] = data;
    fileObjects.add(FileObject(
      name: path.split('/').last,
      id: path,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      bucketId: 'test-bucket',
      owner: '',
      size: data.length,
      metadata: {}
    ));
  }

  @override
  String getPublicUrl(String path, {Map<String, dynamic>? options}) {
    return 'https://example.com/public/$path';
  }

  @override
  Future<Uint8List> download(String path) async {
    final data = storedFiles[path];
    if (data == null) {
      throw AppException(message: 'Arquivo não encontrado');
    }
    return data;
  }

  @override
  Future<List<FileObject>> list({String? path, FileSearchOptions? searchOptions}) async {
    if (path == null) {
      return fileObjects;
    }
    return fileObjects.where((file) => file.id.startsWith(path)).toList();
  }

  @override
  Future<void> remove(List<String> paths) async {
    for (final path in paths) {
      storedFiles.remove(path);
      fileObjects.removeWhere((file) => file.id == path);
    }
  }
}

// Classe simulada para File
class MockFile extends Mock implements File {
  final String filePath;
  final Uint8List fileContent;
  
  MockFile(this.filePath, this.fileContent);
  
  @override
  String get path => filePath;
  
  @override
  Future<Uint8List> readAsBytes() async => fileContent;
  
  @override
  Future<int> length() async => fileContent.length;
}

void main() {
  late StorageService storageService;
  late MockSupabaseClient mockSupabaseClient;
  late MockStorageClient mockStorageClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockStorageClient = mockSupabaseClient.storageMock;
    
    // Inicializar o serviço com o mock
    storageService = StorageService(supabase: mockSupabaseClient);

    // Configurar AppConfig com valores de teste
    AppConfig.workoutBucket = 'workout-images';
    AppConfig.profileBucket = 'profile-images';
    AppConfig.nutritionBucket = 'nutrition-images';
    AppConfig.featuredBucket = 'featured-images';
    AppConfig.challengeBucket = 'challenge-media';
    AppConfig.storageBucket = 'default-bucket';
  });

  group('Inicialização do StorageService', () {
    test('deve verificar e criar buckets na inicialização', () async {
      // Arrange - Configurar os buckets existentes
      when(() => mockStorageClient.listBuckets()).thenAnswer((_) async => [
        Bucket(id: '1', name: 'workout-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '2', name: 'profile-images', public: true, createdAt: '2023-01-01'),
      ]);
      
      when(() => mockStorageClient.createBucket(any(), any())).thenAnswer((_) async {});
      
      // Act
      await storageService.initialize();
      
      // Assert - Verificar que os buckets que não existem foram criados
      verify(() => mockStorageClient.createBucket('nutrition-images', any())).called(1);
      verify(() => mockStorageClient.createBucket('featured-images', any())).called(1);
      verify(() => mockStorageClient.createBucket('challenge-media', any())).called(1);
      
      // E verificar que os buckets que já existem não foram recriados
      verifyNever(() => mockStorageClient.createBucket('workout-images', any()));
      verifyNever(() => mockStorageClient.createBucket('profile-images', any()));
      
      expect(storageService.isInitialized, isTrue);
    });
    
    test('deve lançar exceção quando falha ao verificar buckets', () async {
      // Arrange
      when(() => mockStorageClient.listBuckets()).thenThrow(Exception('Erro simulado ao listar buckets'));
      
      // Act & Assert
      expect(() async => await storageService.initialize(), throwsA(isA<AppException>()));
    });
  });

  group('Upload de Arquivos', () {
    setUp(() async {
      // Configurar inicialização bem-sucedida
      when(() => mockStorageClient.listBuckets()).thenAnswer((_) async => [
        Bucket(id: '1', name: 'workout-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '2', name: 'profile-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '3', name: 'nutrition-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '4', name: 'featured-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '5', name: 'challenge-media', public: true, createdAt: '2023-01-01'),
        Bucket(id: '6', name: 'default-bucket', public: true, createdAt: '2023-01-01'),
      ]);
      
      // Configurar buckets no mock
      mockStorageClient.buckets['workout-images'] = MockBucket();
      mockStorageClient.buckets['profile-images'] = MockBucket();
      mockStorageClient.buckets['nutrition-images'] = MockBucket();
      mockStorageClient.buckets['featured-images'] = MockBucket();
      mockStorageClient.buckets['challenge-media'] = MockBucket();
      mockStorageClient.buckets['default-bucket'] = MockBucket();
      
      await storageService.initialize();
    });

    test('deve fazer upload de arquivo com sucesso', () async {
      // Arrange
      final mockFile = MockFile(
        'test_image.jpg', 
        Uint8List.fromList(List.generate(1024, (index) => index % 256))
      );
      
      // Act
      final result = await storageService.uploadFile(
        path: 'test',
        file: mockFile,
        bucket: 'workout-images',
        compress: false,
      );
      
      // Assert
      expect(result, startsWith('https://example.com/public/'));
    });

    test('deve fazer upload de arquivo de treino com sucesso', () async {
      // Arrange
      final mockFile = MockFile(
        'workout_image.jpg', 
        Uint8List.fromList(List.generate(1024, (index) => index % 256))
      );
      
      // Act
      final result = await storageService.uploadWorkoutImage(
        imageFile: mockFile,
        compress: false,
      );
      
      // Assert
      expect(result, startsWith('https://example.com/public/'));
    });

    test('deve rejeitar arquivos muito grandes', () async {
      // Arrange - Criar um arquivo que excede o limite
      final mockFile = MockFile(
        'large_file.jpg', 
        Uint8List.fromList(List.generate(11 * 1024 * 1024, (index) => index % 256))
      );
      
      // Act & Assert
      expect(
        () => storageService.uploadFile(
          path: 'test',
          file: mockFile,
          bucket: 'workout-images',
          maxSizeInMB: 10,
        ),
        throwsA(isA<AppException>())
      );
    });
  });

  group('Download e Manipulação de Arquivos', () {
    late MockFile testFile;
    
    setUp(() async {
      // Configurar inicialização bem-sucedida
      when(() => mockStorageClient.listBuckets()).thenAnswer((_) async => [
        Bucket(id: '1', name: 'workout-images', public: true, createdAt: '2023-01-01'),
        Bucket(id: '2', name: 'default-bucket', public: true, createdAt: '2023-01-01'),
      ]);
      
      // Configurar buckets no mock
      mockStorageClient.buckets['workout-images'] = MockBucket();
      mockStorageClient.buckets['default-bucket'] = MockBucket();
      
      await storageService.initialize();
      
      // Criar e fazer upload de um arquivo de teste
      testFile = MockFile(
        'test_image.jpg', 
        Uint8List.fromList(List.generate(1024, (index) => index % 256))
      );
      
      await storageService.uploadFile(
        path: 'test',
        file: testFile,
        bucket: 'default-bucket',
        compress: false,
      );
    });

    test('deve baixar arquivo com sucesso', () async {
      // Act
      final result = await storageService.downloadFile(
        path: 'test/test_image.jpg',
        bucket: 'default-bucket',
      );
      
      // Assert
      expect(result, isA<Uint8List>());
      expect(result.length, equals(1024));
    });

    test('deve excluir arquivo com sucesso', () async {
      // Act
      await storageService.deleteFile(
        path: 'test/test_image.jpg',
        bucket: 'default-bucket',
      );
      
      // Assert - Tentar baixar deve falhar
      expect(
        () => storageService.downloadFile(
          path: 'test/test_image.jpg',
          bucket: 'default-bucket',
        ),
        throwsA(isA<AppException>())
      );
    });

    test('deve listar arquivos em um diretório', () async {
      // Arrange - Fazer upload de mais arquivos
      await storageService.uploadFile(
        path: 'test',
        file: MockFile('test_image2.jpg', Uint8List(100)),
        bucket: 'default-bucket',
        compress: false,
      );
      
      // Act
      final result = await storageService.listFiles(
        path: 'test',
        bucket: 'default-bucket',
      );
      
      // Assert
      expect(result, isA<List<FileObject>>());
      expect(result.length, equals(2));
    });
  });

  group('Validação de Imagens', () {
    setUp(() async {
      // Configurar inicialização bem-sucedida
      when(() => mockStorageClient.listBuckets()).thenAnswer((_) async => [
        Bucket(id: '1', name: 'default-bucket', public: true, createdAt: '2023-01-01'),
      ]);
      
      mockStorageClient.buckets['default-bucket'] = MockBucket();
      
      await storageService.initialize();
    });

    test('deve detectar se o arquivo é uma imagem', () {
      // Arrange & Act
      final isJpg = storageService._isImage('test.jpg');
      final isPng = storageService._isImage('test.png');
      final isPdf = storageService._isImage('document.pdf');
      
      // Assert
      expect(isJpg, isTrue);
      expect(isPng, isTrue);
      expect(isPdf, isFalse);
    });
  });
} 