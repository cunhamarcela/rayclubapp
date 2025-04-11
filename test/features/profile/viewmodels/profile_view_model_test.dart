// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/profile/models/profile_model.dart';
import 'package:ray_club_app/features/profile/repositories/profile_repository.dart';
import 'package:ray_club_app/features/profile/viewmodels/profile_state.dart';
import 'package:ray_club_app/features/profile/viewmodels/profile_view_model.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}
class FakeProfile extends Fake implements Profile {}

void main() {
  late ProfileViewModel viewModel;
  late MockProfileRepository mockRepository;
  
  setUpAll(() {
    registerFallbackValue(FakeProfile());
  });
  
  final testProfile = Profile(
    id: 'test-id',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: null,
    completedWorkouts: 10,
    streak: 3,
    points: 500,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    bio: 'Test bio',
    goals: ['Perder peso', 'Ganhar massa muscular'],
    favoriteWorkoutIds: ['workout-1', 'workout-2'],
  );

  setUp(() {
    mockRepository = MockProfileRepository();
    viewModel = ProfileViewModel(mockRepository);
  });

  group('ProfileViewModel', () {
    test('estado inicial deve ser ProfileState.initial', () {
      expect(viewModel.state, const ProfileState.initial());
    });

    group('loadCurrentUserProfile', () {
      test('deve atualizar o estado para loaded com o perfil quando sucesso', () async {
        // Arrange
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);

        // Act
        await viewModel.loadCurrentUserProfile();

        // Assert
        verify(() => mockRepository.getCurrentUserProfile()).called(1);
        expect(viewModel.state, isA<ProfileState>());
        expect(viewModel.state.profile, testProfile);
      });

      test('deve atualizar o estado para error quando o perfil não é encontrado', () async {
        // Arrange
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => null);

        // Act
        await viewModel.loadCurrentUserProfile();

        // Assert
        verify(() => mockRepository.getCurrentUserProfile()).called(1);
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Perfil não encontrado');
      });

      test('deve atualizar o estado para error quando ocorre uma exceção', () async {
        // Arrange
        when(() => mockRepository.getCurrentUserProfile())
            .thenThrow(AppException(message: 'Erro de teste'));

        // Act
        await viewModel.loadCurrentUserProfile();

        // Assert
        verify(() => mockRepository.getCurrentUserProfile()).called(1);
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Erro de teste');
      });
    });

    group('loadProfileById', () {
      test('deve carregar perfil por ID com sucesso', () async {
        // Arrange
        when(() => mockRepository.getProfileById('user-id'))
            .thenAnswer((_) async => testProfile);

        // Act
        await viewModel.loadProfileById('user-id');

        // Assert
        verify(() => mockRepository.getProfileById('user-id')).called(1);
        expect(viewModel.state, isA<ProfileState>());
        expect(viewModel.state.profile, testProfile);
      });

      test('deve atualizar o estado para error quando o perfil não é encontrado', () async {
        // Arrange
        when(() => mockRepository.getProfileById('invalid-id'))
            .thenAnswer((_) async => null);

        // Act
        await viewModel.loadProfileById('invalid-id');

        // Assert
        verify(() => mockRepository.getProfileById('invalid-id')).called(1);
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Perfil não encontrado');
      });
    });

    group('updateProfile', () {
      test('deve atualizar o perfil quando existe um perfil atual', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        // Configura o mock para updateProfile
        final updatedProfile = testProfile.copyWith(
          name: 'Updated Name',
          bio: 'Updated Bio',
          goals: ['Novo objetivo'],
        );
        
        when(() => mockRepository.updateProfile(any()))
            .thenAnswer((_) async => updatedProfile);

        // Act
        await viewModel.updateProfile(
          name: 'Updated Name',
          bio: 'Updated Bio',
          goals: ['Novo objetivo'],
        );

        // Assert
        verify(() => mockRepository.updateProfile(any())).called(1);
        expect(viewModel.state.profile, updatedProfile);
        expect(viewModel.state.profile?.name, 'Updated Name');
        expect(viewModel.state.profile?.bio, 'Updated Bio');
        expect(viewModel.state.profile?.goals, ['Novo objetivo']);
      });

      test('deve atualizar para estado de erro quando não há perfil atual', () async {
        // Act
        await viewModel.updateProfile(name: 'Test Name');

        // Assert
        verifyNever(() => mockRepository.updateProfile(any()));
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Perfil não disponível para atualização');
      });
    });

    group('updateProfilePhoto', () {
      test('deve atualizar foto de perfil quando o perfil está carregado', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        const photoUrl = 'https://example.com/photo.jpg';
        
        when(() => mockRepository.updateProfilePhoto(any(), any()))
            .thenAnswer((_) async => photoUrl);

        // Act
        await viewModel.updateProfilePhoto('local/path/to/photo.jpg');

        // Assert
        verify(() => mockRepository.updateProfilePhoto('test-id', 'local/path/to/photo.jpg')).called(1);
        expect(viewModel.state.profile?.photoUrl, photoUrl);
      });

      test('deve atualizar para estado de erro quando não há perfil atual', () async {
        // Act
        await viewModel.updateProfilePhoto('local/path/to/photo.jpg');

        // Assert
        verifyNever(() => mockRepository.updateProfilePhoto(any(), any()));
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Perfil não disponível para atualização');
      });

      test('deve lidar com erros durante o upload da foto', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        when(() => mockRepository.updateProfilePhoto(any(), any()))
            .thenThrow(AppException(message: 'Erro ao fazer upload da foto'));

        // Act
        await viewModel.updateProfilePhoto('local/path/to/photo.jpg');

        // Assert
        verify(() => mockRepository.updateProfilePhoto('test-id', 'local/path/to/photo.jpg')).called(1);
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Erro ao fazer upload da foto');
      });
    });

    group('addWorkoutToFavorites', () {
      test('deve adicionar um treino aos favoritos quando o perfil está carregado', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        // Configura o mock para addWorkoutToFavorites
        final updatedProfile = testProfile.copyWith(
          favoriteWorkoutIds: [...testProfile.favoriteWorkoutIds, 'workout-3'],
        );
        
        when(() => mockRepository.addWorkoutToFavorites(any(), any()))
            .thenAnswer((_) async => updatedProfile);

        // Act
        await viewModel.addWorkoutToFavorites('workout-3');

        // Assert
        verify(() => mockRepository.addWorkoutToFavorites('test-id', 'workout-3')).called(1);
        expect(viewModel.state.profile, isNotNull);
        expect(viewModel.state.profile?.favoriteWorkoutIds, contains('workout-3'));
      });

      test('não deve chamar o repositório se o treino já está nos favoritos', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();

        // Act
        await viewModel.addWorkoutToFavorites('workout-1'); // workout-1 já está nos favoritos

        // Assert
        verifyNever(() => mockRepository.addWorkoutToFavorites(any(), any()));
        expect(viewModel.state.profile, isNotNull);
      });
    });

    group('removeWorkoutFromFavorites', () {
      test('deve remover um treino dos favoritos quando o perfil está carregado', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        // Configura o mock para removeWorkoutFromFavorites
        final updatedProfile = testProfile.copyWith(
          favoriteWorkoutIds: ['workout-2'], // Removeu 'workout-1'
        );
        
        when(() => mockRepository.removeWorkoutFromFavorites(any(), any()))
            .thenAnswer((_) async => updatedProfile);

        // Act
        await viewModel.removeWorkoutFromFavorites('workout-1');

        // Assert
        verify(() => mockRepository.removeWorkoutFromFavorites('test-id', 'workout-1')).called(1);
        expect(viewModel.state.profile?.favoriteWorkoutIds, isNot(contains('workout-1')));
        expect(viewModel.state.profile?.favoriteWorkoutIds.length, 1);
      });

      test('não deve chamar o repositório se o treino não está nos favoritos', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();

        // Act
        await viewModel.removeWorkoutFromFavorites('workout-999'); // não está nos favoritos

        // Assert
        verifyNever(() => mockRepository.removeWorkoutFromFavorites(any(), any()));
      });
    });

    group('completeWorkout', () {
      test('deve incrementar treinos completados e adicionar pontos', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        // Configura os mocks para as operações encadeadas
        final profileAfterIncrement = testProfile.copyWith(
          completedWorkouts: testProfile.completedWorkouts + 1,
        );
        
        final profileAfterPoints = profileAfterIncrement.copyWith(
          points: profileAfterIncrement.points + 15,
        );
        
        final profileAfterStreak = profileAfterPoints.copyWith(
          streak: profileAfterPoints.streak + 1,
        );
        
        when(() => mockRepository.incrementCompletedWorkouts(any()))
            .thenAnswer((_) async => profileAfterIncrement);
            
        when(() => mockRepository.addPoints(any(), any()))
            .thenAnswer((_) async => profileAfterPoints);
            
        when(() => mockRepository.updateStreak(any(), any()))
            .thenAnswer((_) async => profileAfterStreak);

        // Act
        await viewModel.completeWorkout(pointsEarned: 15);

        // Assert
        verify(() => mockRepository.incrementCompletedWorkouts('test-id')).called(1);
        verify(() => mockRepository.addPoints('test-id', 15)).called(1);
        verify(() => mockRepository.updateStreak('test-id', 4)).called(1); // streak + 1
        
        expect(viewModel.state.profile?.completedWorkouts, 11);
        expect(viewModel.state.profile?.points, 515);
        expect(viewModel.state.profile?.streak, 4);
      });
    });
    
    group('addPoints', () {
      test('deve adicionar pontos ao perfil do usuário', () async {
        // Arrange
        // Primeiro carrega um perfil
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => testProfile);
        await viewModel.loadCurrentUserProfile();
        
        final updatedProfile = testProfile.copyWith(
          points: 550, // 500 + 50
        );
        
        when(() => mockRepository.addPoints(any(), any()))
            .thenAnswer((_) async => updatedProfile);

        // Act
        await viewModel.addPoints(50);

        // Assert
        verify(() => mockRepository.addPoints('test-id', 50)).called(1);
        expect(viewModel.state.profile?.points, 550);
      });

      test('deve atualizar para estado de erro quando não há perfil atual', () async {
        // Act
        await viewModel.addPoints(50);

        // Assert
        verifyNever(() => mockRepository.addPoints(any(), any()));
        expect(viewModel.state.hasError, isTrue);
        expect(viewModel.state.errorMessage, 'Perfil não disponível para atualização');
      });
    });
    
    test('clearError deve limpar o estado de erro', () async {
      // Arrange
      when(() => mockRepository.getCurrentUserProfile())
          .thenThrow(AppException(message: 'Erro de teste'));
      await viewModel.loadCurrentUserProfile();
      expect(viewModel.state.hasError, isTrue);
      
      // Act
      viewModel.clearError();
      
      // Assert
      expect(viewModel.state, isA<ProfileState>());
      expect(viewModel.state.hasError, isFalse);
    });
  });
} 
