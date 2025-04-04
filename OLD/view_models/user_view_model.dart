import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../core/exceptions/repository_exception.dart';
import '../core/providers/providers.dart';

part 'user_view_model.freezed.dart';

/// State class for the UserViewModel
@freezed
class UserState with _$UserState {
  const factory UserState({
    AppUser? user,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isSuccess,
    String? successMessage,
  }) = _UserState;

  /// Initial state
  const factory UserState.initial() = _Initial;

  /// Loading state
  const factory UserState.loading() = _Loading;

  /// Success state
  const factory UserState.success({
    required AppUser user,
    String? message,
  }) = _Success;

  /// Error state
  const factory UserState.error({
    required String message,
  }) = _Error;
}

/// Provider for UserViewModel
final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserViewModel(repository: userRepository);
});

/// ViewModel responsible for handling user-related operations
class UserViewModel extends StateNotifier<UserState> {
  final IUserRepository _repository;

  UserViewModel({required IUserRepository repository})
      : _repository = repository,
        super(const UserState.initial());

  /// Extracts error message from an exception
  String _getErrorMessage(dynamic error) {
    if (error is RepositoryException) {
      return error.message;
    }
    return error.toString();
  }

  /// Loads user data by ID
  Future<void> loadUser(String userId) async {
    try {
      state = const UserState.loading();
      final user = await _repository.getUser(userId);
      state = UserState.success(user: user);
    } catch (e) {
      state = UserState.error(message: _getErrorMessage(e));
    }
  }

  /// Updates user profile information
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      state = const UserState.loading();
      
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (photoUrl != null) data['avatar_url'] = photoUrl;
      if (additionalData != null) data.addAll(additionalData);
      
      await _repository.updateUser(userId, data);
      
      // Reload user data after update
      final updatedUser = await _repository.getUser(userId);
      state = UserState.success(
        user: updatedUser,
        message: 'Perfil atualizado com sucesso',
      );
    } catch (e) {
      state = UserState.error(message: _getErrorMessage(e));
    }
  }

  /// Updates user subscription status
  Future<void> updateSubscriptionStatus({
    required String userId,
    required bool isSubscriber,
  }) async {
    try {
      state = const UserState.loading();
      await _repository.updateUser(userId, {'is_subscriber': isSubscriber});
      
      // Reload user data
      final updatedUser = await _repository.getUser(userId);
      state = UserState.success(
        user: updatedUser,
        message: isSubscriber 
            ? 'Assinatura ativada com sucesso' 
            : 'Assinatura cancelada',
      );
    } catch (e) {
      state = UserState.error(message: _getErrorMessage(e));
    }
  }
} 