import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, AuthException;
import 'package:ray_club_app/core/errors/app_exception.dart' as app;
import 'package:ray_club_app/features/auth/models/user.dart';
import 'package:ray_club_app/features/auth/repositories/auth_repository.dart';
import 'package:ray_club_app/features/auth/viewmodels/auth_view_model.dart';
import 'package:ray_club_app/features/auth/models/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockUser extends Mock implements User {}
class MockSession extends Mock implements Session {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthViewModel viewModel;
  late User mockSupabaseUser;
  late Session mockSession;

  setUp(() {
    mockRepository = MockAuthRepository();
    viewModel = AuthViewModel(repository: mockRepository);
    mockSupabaseUser = MockUser();
    mockSession = MockSession();

    // Configurar o mock do usuário
    when(() => mockSupabaseUser.id).thenReturn('test-id');
    when(() => mockSupabaseUser.email).thenReturn('test@example.com');
    when(() => mockSupabaseUser.userMetadata).thenReturn({'name': 'Test User'});
    when(() => mockSupabaseUser.createdAt).thenReturn('2023-01-01T00:00:00Z');
    when(() => mockSupabaseUser.emailConfirmedAt).thenReturn('2023-01-01T00:00:00Z');
  });

  group('AuthViewModel Tests', () {
    test('initial state should be AuthState.initial', () {
      expect(viewModel.state, isA<AuthState>());
      
      viewModel.state.maybeWhen(
        initial: () => expect(true, true),
        orElse: () => fail('Estado inicial deve ser initial'),
      );
    });

    test('checkAuthStatus should update state to authenticated when user is logged in', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => mockSupabaseUser);

      // Act
      await viewModel.checkAuthStatus();

      // Assert
      viewModel.state.maybeWhen(
        authenticated: (user) {
          expect(user.id, equals('test-id'));
          expect(user.email, equals('test@example.com'));
          expect(user.name, equals('Test User'));
          expect(user.isEmailVerified, isTrue);
        },
        orElse: () => fail('State should be authenticated'),
      );
    });

    test('checkAuthStatus should update state to unauthenticated when no user is logged in', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      await viewModel.checkAuthStatus();

      // Assert
      viewModel.state.maybeWhen(
        unauthenticated: () => expect(true, true),
        orElse: () => fail('State should be unauthenticated'),
      );
    });

    test('checkAuthStatus should update state to error when an exception occurs', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenThrow(
        app.AuthException(message: 'Failed to get current user')
      );

      // Act
      await viewModel.checkAuthStatus();

      // Assert
      viewModel.state.maybeWhen(
        error: (message) {
          expect(message, equals('Failed to get current user'));
        },
        orElse: () => fail('State should be error'),
      );
    });

    test('signIn should update state to authenticated when login succeeds', () async {
      // Arrange
      when(() => mockRepository.signIn('test@example.com', 'password123'))
          .thenAnswer((_) async => mockSupabaseUser);

      // Act
      await viewModel.signIn('test@example.com', 'password123');

      // Assert
      viewModel.state.maybeWhen(
        authenticated: (user) {
          expect(user.id, equals('test-id'));
          expect(user.email, equals('test@example.com'));
        },
        orElse: () => fail('State should be authenticated'),
      );
    });
    
    test('signIn should update state to error when login fails', () async {
      // Arrange
      when(() => mockRepository.signIn('test@example.com', 'password123'))
          .thenThrow(app.AuthException(message: 'Invalid credentials'));

      // Act
      await viewModel.signIn('test@example.com', 'password123');

      // Assert
      viewModel.state.maybeWhen(
        error: (message) {
          expect(message, equals('Invalid credentials'));
        },
        orElse: () => fail('State should be error'),
      );
    });

    test('signOut should update state to unauthenticated', () async {
      // Arrange
      when(() => mockRepository.signOut()).thenAnswer((_) async => {});

      // Act
      await viewModel.signOut();

      // Assert
      viewModel.state.maybeWhen(
        unauthenticated: () => expect(true, true),
        orElse: () => fail('State should be unauthenticated'),
      );
    });

    test('signUp should update state to authenticated when registration succeeds', () async {
      // Arrange
      when(() => mockRepository.signUp('test@example.com', 'password123', 'Test User'))
          .thenAnswer((_) async => mockSupabaseUser);

      // Act
      await viewModel.signUp('test@example.com', 'password123', 'Test User');

      // Assert
      viewModel.state.maybeWhen(
        authenticated: (user) {
          expect(user.id, equals('test-id'));
          expect(user.email, equals('test@example.com'));
          expect(user.name, equals('Test User'));
        },
        orElse: () => fail('State should be authenticated'),
      );
    });
    
    test('signUp should update state to error when registration fails', () async {
      // Arrange
      when(() => mockRepository.signUp('test@example.com', 'password123', 'Test User'))
          .thenThrow(app.AuthException(message: 'Email already in use'));

      // Act
      await viewModel.signUp('test@example.com', 'password123', 'Test User');

      // Assert
      viewModel.state.maybeWhen(
        error: (message) {
          expect(message, equals('Email already in use'));
        },
        orElse: () => fail('State should be error'),
      );
    });
    
    test('resetPassword should update state to success when email is sent', () async {
      // Arrange
      when(() => mockRepository.resetPassword('test@example.com'))
          .thenAnswer((_) async => {});

      // Act
      await viewModel.resetPassword('test@example.com');

      // Assert
      viewModel.state.maybeWhen(
        success: (message) {
          expect(message, contains('Email de redefinição de senha enviado'));
        },
        orElse: () => fail('State should be success'),
      );
    });
    
    test('resetPassword should update state to error when operation fails', () async {
      // Arrange
      when(() => mockRepository.resetPassword('test@example.com'))
          .thenThrow(app.AuthException(message: 'Invalid email'));

      // Act
      await viewModel.resetPassword('test@example.com');

      // Assert
      viewModel.state.maybeWhen(
        error: (message) {
          expect(message, equals('Invalid email'));
        },
        orElse: () => fail('State should be error'),
      );
    });
    
    test('signInWithGoogle should update state to authenticated when login succeeds', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => mockSession);
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => mockSupabaseUser);

      // Act
      await viewModel.signInWithGoogle();

      // Assert
      viewModel.state.maybeWhen(
        authenticated: (user) {
          expect(user.id, equals('test-id'));
          expect(user.email, equals('test@example.com'));
        },
        orElse: () => fail('State should be authenticated'),
      );
    });
    
    test('signInWithGoogle should update state to error when login fails', () async {
      // Arrange
      when(() => mockRepository.signInWithGoogle())
          .thenThrow(app.AuthException(message: 'Google sign in failed'));

      // Act
      await viewModel.signInWithGoogle();

      // Assert
      viewModel.state.maybeWhen(
        error: (message) {
          expect(message, equals('Google sign in failed'));
        },
        orElse: () => fail('State should be error'),
      );
    });
    
    test('updateProfile should update user data in authenticated state', () async {
      // Primeiro autenticar o usuário
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => mockSupabaseUser);
      await viewModel.checkAuthStatus();
      
      // Arrange
      when(() => mockRepository.updateProfile(name: 'New Name', photoUrl: 'https://example.com/photo.jpg'))
          .thenAnswer((_) async => {});
      
      // Act
      await viewModel.updateProfile(name: 'New Name', photoUrl: 'https://example.com/photo.jpg');
      
      // Assert
      viewModel.state.maybeWhen(
        authenticated: (user) {
          expect(user.name, equals('New Name'));
          expect(user.photoUrl, equals('https://example.com/photo.jpg'));
        },
        orElse: () => fail('State should be authenticated with updated profile'),
      );
    });
  });
}
