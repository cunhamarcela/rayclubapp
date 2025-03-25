import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/auth_state.dart';
import '../repositories/auth_repository.dart';
import '../../../core/errors/app_exception.dart';

/// Provider global para o AuthViewModel
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(repository: repository);
});

/// Provider para o repositório de autenticação
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient);
});

/// ViewModel responsável por gerenciar operações relacionadas à autenticação.
class AuthViewModel extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthViewModel({required IAuthRepository repository})
      : _repository = repository,
        super(const AuthState.initial()) {
    checkAuthStatus();
  }

  /// Extrai a mensagem de erro de uma exceção
  String _getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    return error.toString();
  }

  /// Verifica o status atual de autenticação
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(
          user: AppUser.fromSupabaseUser(user),
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }

  /// Realiza login com email e senha
  Future<void> signIn(String email, String password) async {
    try {
      state = const AuthState.loading();
      final user = await _repository.signIn(email, password);
      state = AuthState.authenticated(
        user: AppUser.fromSupabaseUser(user),
      );
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }

  /// Registra um novo usuário
  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AuthState.loading();
      final user = await _repository.signUp(email, password, name);
      state = AuthState.authenticated(
        user: AppUser.fromSupabaseUser(user),
      );
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }

  /// Realiza logout
  Future<void> signOut() async {
    try {
      state = const AuthState.loading();
      await _repository.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }

  /// Solicita redefinição de senha para o email
  Future<void> resetPassword(String email) async {
    try {
      state = const AuthState.loading();
      await _repository.resetPassword(email);
      state = const AuthState.success(message: 'Email de redefinição de senha enviado');
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }

  /// Atualiza o perfil do usuário
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      state = const AuthState.loading();
      await _repository.updateProfile(
        name: name,
        photoUrl: photoUrl,
      );

      // Atualiza o estado do usuário atual se autenticado
      state.maybeWhen(
        authenticated: (user) {
          state = AuthState.authenticated(
            user: user.copyWith(
              name: name ?? user.name,
              photoUrl: photoUrl ?? user.photoUrl,
            ),
          );
        },
        orElse: () {},
      );
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Realiza login com Google
  Future<void> signInWithGoogle() async {
    try {
      state = const AuthState.loading();
      final user = await _repository.signInWithGoogle();
      state = AuthState.authenticated(
        user: AppUser.fromSupabaseUser(user),
      );
    } catch (e) {
      state = AuthState.error(message: _getErrorMessage(e));
    }
  }
} 