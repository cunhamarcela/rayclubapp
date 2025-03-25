import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';

part 'workout_state.freezed.dart';

/// Estado dos treinos no ViewModel
@freezed
class WorkoutState with _$WorkoutState {
  const WorkoutState._();

  /// Estado inicial, sem dados carregados
  const factory WorkoutState.initial() = _WorkoutStateInitial;

  /// Estado de carregamento
  const factory WorkoutState.loading() = _WorkoutStateLoading;

  /// Estado com os treinos carregados
  const factory WorkoutState.loaded({
    @Default([]) List<Workout> workouts,
    @Default([]) List<Workout> filteredWorkouts,
    @Default([]) List<String> categories,
    @Default(WorkoutFilter()) WorkoutFilter filter,
  }) = _WorkoutStateLoaded;

  /// Estado com um treino específico selecionado
  const factory WorkoutState.selectedWorkout({
    required Workout workout,
    @Default([]) List<Workout> workouts,
    @Default([]) List<Workout> filteredWorkouts,
    @Default([]) List<String> categories,
    @Default(WorkoutFilter()) WorkoutFilter filter,
  }) = _WorkoutStateSelectedWorkout;

  /// Estado de erro
  const factory WorkoutState.error(String message) = _WorkoutStateError;

  /// Verifica se está em estado de carregando
  bool get isLoading => maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

  /// Lista de treinos atual (considerando filtros se aplicados)
  List<Workout> get currentWorkouts => maybeWhen(
        loaded: (workouts, filteredWorkouts, _, __) => 
            filteredWorkouts.isNotEmpty ? filteredWorkouts : workouts,
        selectedWorkout: (_, workouts, filteredWorkouts, __, ___) => 
            filteredWorkouts.isNotEmpty ? filteredWorkouts : workouts,
        orElse: () => [],
      );

  /// Treino atualmente selecionado
  Workout? get selectedWorkout => maybeWhen(
        selectedWorkout: (workout, _, __, ___, ____) => workout,
        orElse: () => null,
      );

  /// Função helper para copiar o estado atual com novos valores
  WorkoutState copyWith({
    List<Workout>? workouts,
    List<Workout>? filteredWorkouts,
    List<String>? categories,
    WorkoutFilter? filter,
    Workout? selectedWorkout,
  }) {
    return when(
      initial: () => const WorkoutState.initial(),
      loading: () => const WorkoutState.loading(),
      loaded: (currentWorkouts, currentFiltered, currentCategories, currentFilter) =>
          WorkoutState.loaded(
            workouts: workouts ?? currentWorkouts,
            filteredWorkouts: filteredWorkouts ?? currentFiltered,
            categories: categories ?? currentCategories,
            filter: filter ?? currentFilter,
          ),
      selectedWorkout: (currentSelected, currentWorkouts, currentFiltered, currentCategories, currentFilter) =>
          WorkoutState.selectedWorkout(
            workout: selectedWorkout ?? currentSelected,
            workouts: workouts ?? currentWorkouts,
            filteredWorkouts: filteredWorkouts ?? currentFiltered,
            categories: categories ?? currentCategories,
            filter: filter ?? currentFilter,
          ),
      error: (message) => WorkoutState.error(message),
    );
  }
}

/// Modelo para armazenar os filtros aplicados
@freezed
class WorkoutFilter with _$WorkoutFilter {
  const factory WorkoutFilter({
    @Default('') String category,
    @Default(0) int maxDuration,
    @Default('') String difficulty,
  }) = _WorkoutFilter;
} 