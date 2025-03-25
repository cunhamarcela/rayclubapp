import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/errors/app_exception.dart';

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

  /// Sign in with Google OAuth
  /// Throws [AuthException] if sign in fails
  Future<supabase.User> signInWithGoogle();
}

/// Implementation of [IAuthRepository] using Supabase
class AuthRepository implements IAuthRepository {
  final supabase.SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  @override
  Future<supabase.User?> getCurrentUser() async {
    try {
      return _supabaseClient.auth.currentUser;
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to get current user',
        originalError: e,
        stackTrace: stackTrace,
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
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to sign up user',
        originalError: e,
        stackTrace: stackTrace,
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
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to sign in user',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to sign out user',
        originalError: e,
        stackTrace: stackTrace,
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
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to reset password',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw AuthException(message: 'User is not authenticated');
    }

    try {
      await _supabaseClient.auth.updateUser(
        supabase.UserAttributes(
          data: {
            if (name != null) 'name': name,
            if (photoUrl != null) 'avatar_url': photoUrl,
          },
        ),
      );
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to update profile',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<supabase.User> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: Uri.base.toString(),
      );
      
      if (!response.session?.provider == 'google') {
        throw AuthException(message: 'Google sign in failed or was cancelled');
      }
      
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw AuthException(message: 'Google sign in failed: no user returned');
      }
      
      return user;
    } on supabase.AuthException catch (e, stackTrace) {
      throw AuthException(
        message: e.message,
        code: e.statusCode?.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Failed to sign in with Google',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
} 