import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user.dart';

part 'auth_state.freezed.dart';

/// Represents the authentication state of the application.
/// This state is immutable and uses Freezed for code generation.
@freezed
class AuthState with _$AuthState {
  /// Initial state when the app starts
  const factory AuthState.initial() = _Initial;

  /// State when checking authentication status
  const factory AuthState.loading() = _Loading;

  /// State when user is authenticated
  const factory AuthState.authenticated({
    required AppUser user,
  }) = _Authenticated;

  /// State when user is not authenticated
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// State when an operation succeeds
  const factory AuthState.success({
    required String message,
  }) = _Success;

  /// State when an error occurs
  const factory AuthState.error({
    required String message,
  }) = _Error;
}
