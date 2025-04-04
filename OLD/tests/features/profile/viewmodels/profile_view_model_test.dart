import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/profile/models/profile_model.dart';
import 'package:ray_club_app/features/profile/repositories/profile_repository.dart';
import 'package:ray_club_app/features/profile/viewmodels/profile_view_model.dart';
import 'package:ray_club_app/features/profile/viewmodels/profile_state.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileViewModel viewModel;
  late MockProfileRepository mockRepository;
  
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
        expect(viewModel.state, isA<_ProfileStateLoaded>());
        expect((viewModel.state as _ProfileStateLoaded).profile, testProfile);
      });

      test('deve atualizar o estado para error quando o perfil não é encontrado', () async {
        // Arrange
        when(() => mockRepository.getCurrentUserProfile())
            .thenAnswer((_) async => null);

        // Act
        await viewModel.loadCurrentUserProfile();

        // Assert
        verify(() => mockRepository.getCurrentUserProfile()).called(1);
        expect(viewModel.state, isA<_ProfileStateError>());
        expect((viewModel.state as _ProfileStateError).message, 'Perfil não encontrado');
      });

      test('deve atualizar o estado para error quando ocorre uma exceção', () async {
        // Arrange
        when(() => mockRepository.getCurrentUserProfile())
            .thenThrow(AppException(message: 'Erro de teste'));

        // Act
        await viewModel.loadCurrentUserProfile();

        // Assert
        verify(() => mockRepository.getCurrentUserProfile()).called(1);
        expect(viewModel.state, isA<_ProfileStateError>());
        expect((viewModel.state as _ProfileStateError).message, 'Erro de teste');
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
        expect(viewModel.state, isA<_ProfileStateLoaded>());
        expect((viewModel.state as _ProfileStateLoaded).profile, updatedProfile);
      });

      test('deve atualizar para estado de erro quando não há perfil atual', () async {
        // Act
        await viewModel.updateProfile(name: 'Test Name');

        // Assert
        verifyNever(() => mockRepository.updateProfile(any()));
        expect(viewModel.state, isA<_ProfileStateError>());
        expect(
          (viewModel.state as _ProfileStateError).message, 
          'Perfil não disponível para atualização'
        );
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
        expect(viewModel.state, isA<_ProfileStateLoaded>());
        expect(
          (viewModel.state as _ProfileStateLoaded).profile.favoriteWorkoutIds, 
          contains('workout-3')
        );
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
        expect(viewModel.state, isA<_ProfileStateLoaded>());
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
        
        expect(viewModel.state, isA<_ProfileStateLoaded>());
        expect((viewModel.state as _ProfileStateLoaded).profile.completedWorkouts, 11);
        expect((viewModel.state as _ProfileStateLoaded).profile.points, 515);
        expect((viewModel.state as _ProfileStateLoaded).profile.streak, 4);
      });
    });
    
    test('clearError deve limpar o estado de erro', () async {
      // Arrange
      when(() => mockRepository.getCurrentUserProfile())
          .thenThrow(AppException(message: 'Erro de teste'));
      await viewModel.loadCurrentUserProfile();
      expect(viewModel.state, isA<_ProfileStateError>());
      
      // Act
      viewModel.clearError();
      
      // Assert
      expect(viewModel.state, isA<_ProfileStateInitial>());
    });
  });
} 