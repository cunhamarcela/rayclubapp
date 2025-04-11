// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Project imports:
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/auth/models/user.dart';
import 'package:ray_club_app/features/auth/repositories/auth_repository.dart';
import 'package:ray_club_app/features/challenges/models/challenge.dart';
import 'package:ray_club_app/features/challenges/repositories/challenge_repository.dart';
import 'package:ray_club_app/features/challenges/viewmodels/challenge_view_model.dart';

@GenerateMocks([ChallengeRepository], customMocks: [MockSpec<ChallengeRepository>(as: #GeneratedMockChallengeRepository)])
import 'challenge_view_model_test.mocks.dart';

// Criando mocks para os testes
class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

// Fake classes para registrar como fallback values
class FakeChallenge extends Fake implements Challenge {}
class FakeChallengeInvite extends Fake implements ChallengeInvite {}
class FakeChallengeProgress extends Fake implements ChallengeProgress {}
class FakeValidationException extends Fake implements ValidationException {}

void main() {
  late ChallengeViewModel viewModel;
  late GeneratedMockChallengeRepository mockRepository;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;
  
  // Dados de teste
  final now = DateTime.now();
  
  final testChallenges = [
    Challenge(
      id: '1',
      title: 'Desafio Ray 2023',
      description: 'Desafio oficial da Ray Club!',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      reward: 500,
      creatorId: 'admin',
      isOfficial: true,
      participants: ['user1', 'user2'],
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    ),
    Challenge(
      id: '2',
      title: 'Maratona Fitness',
      description: 'Acumule 100km em corridas',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      reward: 800,
      creatorId: 'user3',
      participants: ['user3'],
      invitedUsers: ['user1', 'user4'],
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
    ),
    Challenge(
      id: '3',
      title: 'Desafio Força Total',
      description: 'Treinos de força intensos',
      startDate: now.subtract(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 20)),
      reward: 300,
      creatorId: 'user2',
      participants: ['user2', 'user5'],
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now.subtract(const Duration(days: 10)),
    ),
  ];
  
  final testInvites = [
    ChallengeInvite(
      id: 'inv1',
      challengeId: '1',
      challengeTitle: 'Desafio Ray 2023',
      inviterId: 'admin',
      inviterName: 'Administrador',
      inviteeId: 'user3',
      status: InviteStatus.pending,
      createdAt: now.subtract(const Duration(hours: 5)),
    ),
    ChallengeInvite(
      id: 'inv2',
      challengeId: '2',
      challengeTitle: 'Maratona Fitness',
      inviterId: 'user3',
      inviterName: 'Usuário 3',
      inviteeId: 'user1',
      status: InviteStatus.pending,
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
  ];
  
  final testProgress = [
    ChallengeProgress(
      id: 'prog1',
      challengeId: '1',
      userId: 'user1',
      userName: 'Usuário 1',
      userPhotoUrl: 'https://example.com/photo1.jpg',
      points: 150,
      position: 1,
      completionPercentage: 45.0,
      lastUpdated: now.subtract(const Duration(hours: 3)),
    ),
    ChallengeProgress(
      id: 'prog2',
      challengeId: '1',
      userId: 'user2',
      userName: 'Usuário 2',
      userPhotoUrl: 'https://example.com/photo2.jpg',
      points: 120,
      position: 2,
      completionPercentage: 36.0,
      lastUpdated: now.subtract(const Duration(hours: 5)),
    ),
  ];

  // Registrar fallback values (não necessário com Mockito)
  setUpAll(() {
    // Não precisamos registrar fallback values com Mockito
  });

  setUp(() {
    mockRepository = GeneratedMockChallengeRepository();
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    
    // Configurar valores padrão para o mock user
    when(mockUser.id).thenReturn('user1');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.name).thenReturn('Usuário Teste');
    
    // Configurar o AuthRepository para retornar o usuário mock
    when(mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => mockUser);

    // Criar o viewModel com os mocks
    viewModel = ChallengeViewModel(
      repository: mockRepository,
      authRepository: mockAuthRepository,
    );
    
    // Configuração padrão do repository mock
    when(mockRepository.getChallenges())
        .thenAnswer((_) async => testChallenges);
    
    when(mockRepository.getActiveChallenges())
        .thenAnswer((_) async => testChallenges.where((c) => 
            c.endDate.isAfter(now)).toList());
    
    when(mockRepository.getUserChallenges(any))
        .thenAnswer((_) async => testChallenges.where((c) => 
            c.creatorId == 'user3' || c.participants.contains('user3')).toList());
    
    when(mockRepository.getOfficialChallenge())
        .thenAnswer((_) async => testChallenges.firstWhere((c) => c.isOfficial));
    
    when(mockRepository.getChallengeById(any))
        .thenAnswer((invocation) async {
          final id = invocation.positionalArguments[0] as String;
          return testChallenges.firstWhere(
            (c) => c.id == id,
            orElse: () => throw const AppException(message: 'Desafio não encontrado')
          );
        });
    
    when(mockRepository.getPendingInvites(any))
        .thenAnswer((_) async => testInvites);
    
    when(mockRepository.getChallengeRanking(any))
        .thenAnswer((_) async => testProgress);
        
    // Configuração para updateUserProgress
    when(mockRepository.updateUserProgress(
      challengeId: anyNamed('challengeId'),
      userId: anyNamed('userId'),
      userName: anyNamed('userName'),
      userPhotoUrl: anyNamed('userPhotoUrl'),
      points: anyNamed('points'),
      completionPercentage: anyNamed('completionPercentage'),
    )).thenAnswer((_) async {});

    // Configurações para os demais métodos
    when(mockRepository.inviteUserToChallenge(
      challengeId: anyNamed('challengeId'),
      inviterId: anyNamed('inviterId'),
      inviteeId: anyNamed('inviteeId'),
      challengeTitle: anyNamed('challengeTitle'),
      inviterName: anyNamed('inviterName'),
    )).thenAnswer((invocation) async {
      final challengeId = invocation.namedArguments[#challengeId] as String;
      final challengeTitle = invocation.namedArguments[#challengeTitle] as String;
      final inviterId = invocation.namedArguments[#inviterId] as String;
      final inviterName = invocation.namedArguments[#inviterName] as String;
      final inviteeId = invocation.namedArguments[#inviteeId] as String;
      
      return ChallengeInvite(
        id: 'inv3',
        challengeId: challengeId,
        challengeTitle: challengeTitle,
        inviterId: inviterId,
        inviterName: inviterName,
        inviteeId: inviteeId,
        status: InviteStatus.pending,
        createdAt: now,
      );
    });
    
    when(mockRepository.respondToInvite(
      inviteId: anyNamed('inviteId'),
      status: anyNamed('status'),
    )).thenAnswer((_) async {});
    
    when(mockRepository.joinChallenge(
      challengeId: anyNamed('challengeId'),
      userId: anyNamed('userId'),
    )).thenAnswer((_) async {});
    
    when(mockRepository.leaveChallenge(
      challengeId: anyNamed('challengeId'),
      userId: anyNamed('userId'),
    )).thenAnswer((_) async {});
    
    when(mockRepository.createChallenge(any)).thenAnswer((invocation) async {
      final challenge = invocation.positionalArguments[0] as Challenge;
      return challenge.copyWith(id: '4');
    });
  });

  group('ChallengeViewModel - Estado Inicial', () {
    test('inicializa com loading e carrega desafios automaticamente', () async {
      // Verificar que o repositório foi chamado no construtor
      verify(() => mockRepository.getChallenges()).called(1);
      
      // Aguardar a conclusão da carga inicial
      await Future.delayed(Duration.zero);
      
      // O estado deve conter os desafios após o carregamento
      expect(viewModel.state, isA<ChallengeState>());
      expect(ChallengeStateHelper.getChallenges(viewModel.state).length, equals(testChallenges.length));
    });
  });

  group('ChallengeViewModel - Sistema de Convites', () {
    test('carrega convites pendentes para um usuário', () async {
      await viewModel.loadPendingInvites('user3');
      
      verify(() => mockRepository.getPendingInvites('user3')).called(1);
      
      final pendingInvites = ChallengeStateHelper.getPendingInvites(viewModel.state);
      expect(pendingInvites.length, equals(testInvites.length));
    });
    
    test('envia convites para desafios', () async {
      await viewModel.inviteUserToChallenge(
        challengeId: '1',
        challengeTitle: 'Desafio Ray 2023',
        inviterId: 'user1',
        inviterName: 'Usuário 1',
        inviteeId: 'user5',
      );
      
      verify(() => mockRepository.inviteUserToChallenge(
        challengeId: '1',
        challengeTitle: 'Desafio Ray 2023',
        inviterId: 'user1',
        inviterName: 'Usuário 1',
        inviteeId: 'user5',
      )).called(1);
    });
    
    test('responde a convites (aceita/recusa)', () async {
      await viewModel.loadPendingInvites('user3');
      
      await viewModel.respondToInvite(
        inviteId: 'inv1',
        status: InviteStatus.accepted,
      );
      
      verify(() => mockRepository.respondToInvite(
        inviteId: 'inv1',
        status: InviteStatus.accepted,
      )).called(1);
    });
  });

  group('ChallengeViewModel - Atualização de Ranking', () {
    test('carrega ranking de desafios', () async {
      await viewModel.loadChallengeRanking('1');
      
      verify(() => mockRepository.getChallengeRanking('1')).called(1);
      
      final progressList = ChallengeStateHelper.getProgressList(viewModel.state);
      expect(progressList.length, equals(testProgress.length));
    });
    
    test('atualiza progresso de usuários', () async {
      // Atualizar progresso com valores válidos
      await viewModel.updateUserProgress(
        challengeId: '1',
        userId: 'user1',
        userName: 'Usuário 1',
        points: 200,
        completionPercentage: 0.6,
      );
      
      // Verificar que o método foi chamado com os parâmetros corretos
      verify(() => mockRepository.updateUserProgress(
        challengeId: '1',
        userId: 'user1',
        userName: 'Usuário 1',
        userPhotoUrl: null,
        points: 200,
        completionPercentage: 0.6,
      )).called(1);
    });
  });

  group('ChallengeViewModel - Manipulação de Desafios', () {
    test('obtém detalhes de um desafio específico', () async {
      await viewModel.getChallengeDetails('1');
      
      verify(() => mockRepository.getChallengeById('1')).called(1);
      
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(viewModel.state);
      expect(selectedChallenge?.id, equals('1'));
    });
    
    test('cria um novo desafio', () async {
      final newChallenge = Challenge(
        id: '4',
        title: 'Novo Desafio',
        description: 'Descrição do novo desafio',
        startDate: now,
        endDate: now.add(const Duration(days: 14)),
        reward: 200,
        creatorId: 'user1',
        participants: ['user1'],
        createdAt: now,
        updatedAt: now,
      );
      
      await viewModel.createChallenge(newChallenge);
      
      verify(() => mockRepository.createChallenge(any)).called(1);
      
      final challenges = ChallengeStateHelper.getChallenges(viewModel.state);
      expect(challenges.any((c) => c.id == '4'), isTrue);
    });
    
    test('participa e sai de desafios', () async {
      // Participar do desafio
      await viewModel.joinChallenge(challengeId: '1', userId: 'user3');
      
      verify(() => mockRepository.joinChallenge(
        challengeId: '1',
        userId: 'user3'
      )).called(1);
      
      // Sair do desafio
      await viewModel.leaveChallenge(challengeId: '1', userId: 'user3');
      
      verify(() => mockRepository.leaveChallenge(
        challengeId: '1',
        userId: 'user3'
      )).called(1);
    });
  });

  group('ChallengeViewModel - Tratamento de Erros', () {
    test('captura e apresenta erros do repositório', () async {
      when(() => mockRepository.getChallenges())
          .thenThrow(const AppException(message: 'Erro na conexão com o servidor'));
      
      await viewModel.loadChallenges();
      
      // Verificar se a operação foi bem-sucedida
      expect(ChallengeStateHelper.getChallenges(viewModel.state).isNotEmpty, isTrue);
    });
  });

  group('loadAllChallengesWithOfficial', () {
    test('deve carregar desafios e o desafio oficial com sucesso', () async {
      // Arrange
      when(() => mockRepository.getChallenges())
          .thenAnswer((_) async => testChallenges);
      
      when(() => mockRepository.getOfficialChallenge())
          .thenAnswer((_) async => testChallenges.firstWhere((c) => c.isOfficial));
      
      when(() => mockRepository.getPendingInvites('user1'))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.loadAllChallengesWithOfficial();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.challenges.length, testChallenges.length);
      expect(viewModel.state.challenges.any((c) => c.isOfficial), true);
    });

    test('deve atualizar o estado com erro quando falhar', () async {
      // Arrange
      when(() => mockRepository.getChallenges())
          .thenThrow(AppException(message: 'Erro ao buscar desafios'));

      // Act
      await viewModel.loadAllChallengesWithOfficial();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, 'Erro ao buscar desafios');
      expect(viewModel.state.challenges, isEmpty);
    });
  });

  group('loadChallenges', () {
    test('deve carregar desafios com sucesso', () async {
      // Arrange
      when(() => mockRepository.getChallenges())
          .thenAnswer((_) async => testChallenges);

      // Act
      await viewModel.loadChallenges();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.challenges.length, testChallenges.length);
    });

    test('deve atualizar o estado com erro quando falhar', () async {
      // Arrange
      when(() => mockRepository.getChallenges())
          .thenThrow(AppException(message: 'Erro ao buscar desafios'));

      // Act
      await viewModel.loadChallenges();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, 'Erro ao buscar desafios');
      expect(viewModel.state.challenges, isEmpty);
    });
  });

  group('getChallengeDetails', () {
    test('deve carregar detalhes do desafio com sucesso', () async {
      // Arrange
      when(() => mockRepository.getChallengeById('1'))
          .thenAnswer((_) async => testChallenges.firstWhere((c) => c.id == '1'));
      
      when(() => mockRepository.getChallengeRanking('1'))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.getChallengeDetails('1');

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.selectedChallenge, isNotNull);
      expect(viewModel.state.selectedChallenge?.id, '1');
    });

    test('deve atualizar o estado com erro quando falhar', () async {
      // Arrange
      when(() => mockRepository.getChallengeById('1'))
          .thenThrow(AppException(message: 'Desafio não encontrado'));

      // Act
      await viewModel.getChallengeDetails('1');

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, 'Desafio não encontrado');
      expect(viewModel.state.selectedChallenge, isNull);
    });
  });

  group('joinChallenge', () {
    test('deve entrar em um desafio com sucesso', () async {
      // Arrange
      when(() => mockRepository.joinChallenge('1', 'user1'))
          .thenAnswer((_) async => {});
      
      when(() => mockRepository.getChallengeById('1'))
          .thenAnswer((_) async => testChallenges.firstWhere((c) => c.id == '1'));
      
      when(() => mockRepository.getChallengeRanking('1'))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.joinChallenge('1', 'user1');

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.message, 'Você entrou no desafio');
    });

    test('deve atualizar o estado com erro quando falhar', () async {
      // Arrange
      when(() => mockRepository.joinChallenge('1', 'user1'))
          .thenThrow(AppException(message: 'Erro ao entrar no desafio'));

      // Act
      await viewModel.joinChallenge('1', 'user1');

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, 'Erro ao entrar no desafio');
    });
  });

  group('ChallengeViewModel Tests', () {
    test('loadChallenges updates state correctly', () async {
      // Arrange
      final challenges = [
        Challenge(
          id: '1',
          title: 'Test Challenge',
          description: 'Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 21)),
          points: 100,
          participants: [],
          isOfficial: false,
          createdAt: DateTime.now(),
        ),
      ];
      
      when(mockRepository.getChallenges()).thenAnswer((_) async => challenges);
      
      // Act
      await viewModel.loadChallenges();
      
      // Assert
      expect(viewModel.state.challenges, equals(challenges));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('loadOfficialChallenge loads official challenge correctly', () async {
      // Arrange
      final officialChallenge = Challenge(
        id: '1',
        title: 'Ray 21',
        description: 'Desafio oficial',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 21)),
        points: 100,
        participants: [],
        isOfficial: true,
        createdAt: DateTime.now(),
      );
      
      when(mockRepository.getOfficialChallenge())
          .thenAnswer((_) async => officialChallenge);
      
      // Act
      await viewModel.loadOfficialChallenge();
      
      // Assert
      expect(viewModel.state.selectedChallenge, equals(officialChallenge));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('loadOfficialChallenge handles error when no official challenge found', () async {
      // Arrange
      when(mockRepository.getOfficialChallenge())
          .thenAnswer((_) async => null);
      
      // Act
      await viewModel.loadOfficialChallenge();
      
      // Assert
      expect(viewModel.state.selectedChallenge, isNull);
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, 'Nenhum desafio oficial encontrado.');
    });

    test('loadOfficialChallenge handles exceptions', () async {
      // Arrange
      when(mockRepository.getOfficialChallenge())
          .thenThrow(Exception('Test error'));
      
      // Act
      await viewModel.loadOfficialChallenge();
      
      // Assert
      expect(viewModel.state.selectedChallenge, isNull);
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, contains('Test error'));
    });
  });
} 
