import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../core/errors/app_exception.dart';

/// Interface for authentication-related operations
abstract class IAuthRepository {
  /// Gets the currently authenticated user
  /// Returns null if no user is authenticated
  Future<supabase.User?> getCurrentUser();

  /// Signs up a new user with email and password
  /// Throws [ValidationException] if email or password is invalid
  /// Throws [AuthException] if signup fails
  Future<supabase.User> signUp(String email, String password, String name);

  /// Signs in a user with email and password
  /// Throws [ValidationException] if email or password is invalid
  /// Throws [AuthException] if credentials are incorrect
  Future<supabase.User> signIn(String email, String password);

  /// Signs out the current user
  /// Throws [AuthException] if signout fails
  Future<void> signOut();

  /// Resets the password for the given email
  /// Throws [ValidationException] if email is invalid
  /// Throws [AuthException] if reset fails
  Future<void> resetPassword(String email);

  /// Updates the current user's profile
  /// Throws [AuthException] if user is not authenticated
  /// Throws [ValidationException] if data is invalid
  Future<void> updateProfile({String? name, String? photoUrl});

  /// Signs in the user with Google OAuth
  /// Returns the session if successful or null if canceled
  /// Throws [AuthException] if sign in fails
  Future<supabase.Session?> signInWithGoogle();
}

/// Implementation of [IAuthRepository] using Supabase
class AuthRepository implements IAuthRepository {
  final supabase.SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  @override
  Future<supabase.User?> getCurrentUser() async {
    try {
      return _supabaseClient.auth.currentUser;
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to get current user',
        originalError: e,
      );
    }
  }

  @override
  Future<supabase.User> signUp(
      String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw ValidationException(message: 'Email, password and name are required');
    }

    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw AuthException(message: 'Sign up failed: no user returned');
      }

      return response.user!;
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to sign up user',
        originalError: e,
      );
    }
  }

  @override
  Future<supabase.User> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ValidationException(message: 'Email and password are required');
    }

    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException(message: 'Sign in failed: no user returned');
      }

      return response.user!;
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to sign in user',
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to sign out user',
        originalError: e,
      );
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw ValidationException(message: 'Email is required');
    }

    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to reset password',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      final updates = <String, dynamic>{};
      
      if (name != null) {
        updates['data'] = {'name': name};
      }
      
      if (photoUrl != null) {
        // If no data has been set yet, initialize it
        if (!updates.containsKey('data')) {
          updates['data'] = {};
        }
        updates['data']['avatar_url'] = photoUrl;
      }
      
      if (updates.isEmpty) {
        return; // Nothing to update
      }

      await _supabaseClient.auth.updateUser(
        supabase.UserAttributes(
          data: updates['data'],
        ),
      );
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to update profile',
        originalError: e,
      );
    }
  }

  @override
  Future<supabase.Session?> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: Uri.base.toString(),
      );
      
      // A response não tem uma session diretamente, apenas um indicador de sucesso
      // A session será recuperada posteriormente após o redirecionamento
      
      // Note que este método pode retornar null se o usuário cancelar o processo de login
      // O fluxo OAuth requer um redirecionamento para uma página de consentimento externa
      return _supabaseClient.auth.currentSession;
    } on supabase.AuthException catch (e) {
      throw AuthException(
        message: e.message,
        code: e.statusCode.toString(),
        originalError: e,
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to sign in with Google',
        originalError: e,
      );
    }
  }
}
