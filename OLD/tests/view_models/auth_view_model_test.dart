import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ray_club_app/repositories/auth_repository.dart';
import 'package:ray_club_app/view_models/auth_view_model.dart';
import 'package:ray_club_app/models/user.dart';
import 'package:ray_club_app/view_models/states/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'auth_view_model_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late MockIAuthRepository mockAuthRepository;
  late AuthViewModel viewModel;

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    viewModel = AuthViewModel(repository: mockAuthRepository);
  });

  group('AuthViewModel', () {
    test('Inicialmente o estado deve estar como Initial', () {
      expect(viewModel.state, isA<_Initial>());
    });
    
    test('signInWithGoogle com sucesso altera o estado para Authenticated', () async {
      // Criar um usuário Supabase mockado
      final mockUser = supabase.User(
        id: '123',
        email: 'test@example.com',
        appMetadata: {},
        userMetadata: {
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png'
        },
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      );
      
      // Mock da sessão
      final mockSession = supabase.Session(
        accessToken: 'fake-token',
        refreshToken: 'fake-refresh-token',
        user: mockUser,
        expiresIn: 3600,
        tokenType: 'bearer',
      );
      
      when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => mockSession);
      when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => mockUser);
      
      await viewModel.signInWithGoogle();
      
      expect(viewModel.state, isA<_Authenticated>());
      final authState = viewModel.state as _Authenticated;
      expect(authState.user.id, equals('123'));
      expect(authState.user.email, equals('test@example.com'));
    });
    
    test('signOut com sucesso altera o estado para Unauthenticated', () async {
      // Primeiro autenticar
      final mockUser = supabase.User(
        id: '123',
        email: 'test@example.com',
        appMetadata: {},
        userMetadata: {
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png'
        },
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      );
      
      // Mock da sessão
      final mockSession = supabase.Session(
        accessToken: 'fake-token',
        refreshToken: 'fake-refresh-token',
        user: mockUser,
        expiresIn: 3600,
        tokenType: 'bearer',
      );
      
      when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => mockSession);
      when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => mockUser);
      await viewModel.signInWithGoogle();
      
      // Depois deslogar
      when(mockAuthRepository.signOut()).thenAnswer((_) async => {});
      
      await viewModel.signOut();
      
      expect(viewModel.state, isA<_Unauthenticated>());
    });
  });
}
