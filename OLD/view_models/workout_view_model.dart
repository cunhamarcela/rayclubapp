import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/workout.dart';
import '../repositories/workout_repository.dart';
import '../core/exceptions/repository_exception.dart';
import '../core/providers/providers.dart';
import '../services/storage_service.dart';

part 'workout_view_model.freezed.dart';

/// State for the workout view model
@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState({
    @Default([]) List<Workout> workouts,
    @Default([]) List<Workout> filteredWorkouts,
    @Default([]) List<String> categories,
    @Default('') String selectedCategory,
    @Default(0) int selectedDurationFilter,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _WorkoutState;

  /// Initial state
  const factory WorkoutState.initial() = _Initial;

  /// Loading state
  const factory WorkoutState.loading() = _Loading;

  /// Success state with data
  const factory WorkoutState.success({
    required List<Workout> workouts,
    required List<Workout> filteredWorkouts,
    required List<String> categories,
    @Default('') String selectedCategory,
    @Default(0) int selectedDurationFilter,
    String? message,
  }) = _Success;

  /// Error state
  const factory WorkoutState.error({
    required String message,
  }) = _Error;
}

/// Provider for the workout view model
final workoutViewModelProvider = StateNotifierProvider<WorkoutViewModel, WorkoutState>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return WorkoutViewModel(repository: repository, storageService: storageService);
});

/// ViewModel for managing workouts
class WorkoutViewModel extends StateNotifier<WorkoutState> {
  final IWorkoutRepository _repository;
  final StorageService _storageService;

  WorkoutViewModel({
    required IWorkoutRepository repository,
    required StorageService storageService,
  })  : _repository = repository,
        _storageService = storageService,
        super(const WorkoutState.initial()) {
    loadWorkouts();
  }

  /// Extracts error message from an exception
  String _getErrorMessage(dynamic error) {
    if (error is RepositoryException) {
      return error.message;
    }
    return error.toString();
  }

  /// Loads all workouts from the repository
  Future<void> loadWorkouts() async {
    try {
      state = const WorkoutState.loading();
      final workouts = await _repository.getWorkouts();
      
      // Extract unique categories
      final categorySet = <String>{};
      for (var workout in workouts) {
        if (workout.type.isNotEmpty) {
          categorySet.add(workout.type);
        }
      }
      
      state = WorkoutState.success(
        workouts: workouts,
        filteredWorkouts: workouts,
        categories: categorySet.toList(),
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }

  /// Filters workouts by category
  void filterByCategory(String category) {
    // Keep the current workouts
    final currentWorkouts = state.maybeWhen(
      success: (workouts, _, __, ___, ____, _____) => workouts,
      orElse: () => <Workout>[],
    );
    
    if (currentWorkouts.isEmpty) return;
    
    try {
      if (category.isEmpty) {
        // Reset filters
        state = WorkoutState.success(
          workouts: currentWorkouts,
          filteredWorkouts: currentWorkouts,
          categories: state.categories,
          selectedCategory: '',
          selectedDurationFilter: state.selectedDurationFilter,
        );
        return;
      }

      final filteredWorkouts = currentWorkouts
          .where((workout) => workout.type.toLowerCase() == category.toLowerCase())
          .toList();

      state = WorkoutState.success(
        workouts: currentWorkouts,
        filteredWorkouts: filteredWorkouts,
        categories: state.categories,
        selectedCategory: category,
        selectedDurationFilter: state.selectedDurationFilter,
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }

  /// Filters workouts by duration
  void filterByDuration(int minutes) {
    // Keep the current workouts
    final currentWorkouts = state.maybeWhen(
      success: (workouts, _, __, ___, ____, _____) => workouts,
      orElse: () => <Workout>[],
    );
    
    if (currentWorkouts.isEmpty) return;
    
    try {
      if (minutes == 0) {
        // Just apply category filter if any
        filterByCategory(state.selectedCategory);
        return;
      }

      // Start with base workouts filtered by category if selected
      final baseWorkouts = state.selectedCategory.isEmpty
          ? currentWorkouts
          : currentWorkouts
              .where((w) => w.type.toLowerCase() == state.selectedCategory.toLowerCase())
              .toList();

      final durationFiltered = baseWorkouts
          .where((workout) => workout.durationMinutes <= minutes)
          .toList();

      state = WorkoutState.success(
        workouts: currentWorkouts,
        filteredWorkouts: durationFiltered,
        categories: state.categories,
        selectedCategory: state.selectedCategory,
        selectedDurationFilter: minutes,
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }

  /// Resets all filters
  void resetFilters() {
    // Keep the current workouts
    final currentWorkouts = state.maybeWhen(
      success: (workouts, _, __, ___, ____, _____) => workouts,
      orElse: () => <Workout>[],
    );
    
    state = WorkoutState.success(
      workouts: currentWorkouts,
      filteredWorkouts: currentWorkouts,
      categories: state.categories,
      selectedCategory: '',
      selectedDurationFilter: 0,
    );
  }

  /// Creates a new workout
  Future<void> createWorkout(Workout workout, {String? imagePath}) async {
    try {
      state = const WorkoutState.loading();
      
      // Upload image if provided
      String? imageUrl;
      if (imagePath != null) {
        final fileName = 'workout_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await _storageService.uploadFile(
          bucketName: 'workout_images',
          filePath: imagePath,
          fileName: fileName,
        );
        
        // Create workout with uploaded image URL
        final workoutWithImage = workout.copyWith(imageUrl: imageUrl);
        await _repository.createWorkout(workoutWithImage);
      } else {
        // Create workout without image
        await _repository.createWorkout(workout);
      }
      
      // Reload workouts after creation
      await loadWorkouts();
      
      state = state.copyWith(
        successMessage: 'Treino criado com sucesso!',
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }

  /// Updates an existing workout
  Future<void> updateWorkout(Workout workout, {String? imagePath}) async {
    try {
      state = const WorkoutState.loading();
      
      // Upload new image if provided
      String? imageUrl;
      if (imagePath != null) {
        final fileName = 'workout_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await _storageService.uploadFile(
          bucketName: 'workout_images',
          filePath: imagePath,
          fileName: fileName,
        );
        
        // Update workout with new image URL
        final workoutWithImage = workout.copyWith(imageUrl: imageUrl);
        await _repository.updateWorkout(workoutWithImage);
      } else {
        // Update workout without changing image
        await _repository.updateWorkout(workout);
      }
      
      // Reload workouts after update
      await loadWorkouts();
      
      state = state.copyWith(
        successMessage: 'Treino atualizado com sucesso!',
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }

  /// Deletes a workout
  Future<void> deleteWorkout(String workoutId) async {
    try {
      state = const WorkoutState.loading();
      await _repository.deleteWorkout(workoutId);
      
      // Reload workouts after deletion
      await loadWorkouts();
      
      state = state.copyWith(
        successMessage: 'Treino excluído com sucesso!',
      );
    } catch (e) {
      state = WorkoutState.error(message: _getErrorMessage(e));
    }
  }
} 