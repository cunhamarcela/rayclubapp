import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:ray_club_app/features/workout/repositories/workout_repository.dart';
import 'package:ray_club_app/features/workout/viewmodels/states/workout_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider para o repositório de treinos
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  // Para desenvolvimento, usamos o repositório mock
  // Em produção, usaremos a implementação com Supabase
  return MockWorkoutRepository();
  
  // Quando migrar para produção:
  // final supabase = Supabase.instance.client;
  // return SupabaseWorkoutRepository(supabase);
});

/// Provider para o WorkoutViewModel
final workoutViewModelProvider = StateNotifierProvider<WorkoutViewModel, WorkoutState>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return WorkoutViewModel(repository);
});

/// ViewModel para gerenciar treinos
class WorkoutViewModel extends StateNotifier<WorkoutState> {
  final WorkoutRepository _repository;

  WorkoutViewModel(this._repository) : super(WorkoutState.initial()) {
    loadWorkouts();
  }

  /// Carrega todos os treinos disponíveis
  Future<void> loadWorkouts() async {
    try {
      state = WorkoutState.loading();
      
      final workouts = await _repository.getWorkouts();
      
      // Extrair categorias únicas
      final categoriesSet = <String>{};
      for (var workout in workouts) {
        if (workout.type.isNotEmpty) {
          categoriesSet.add(workout.type);
        }
      }
      
      state = WorkoutState.loaded(
        workouts: workouts,
        categories: categoriesSet.toList(),
      );
    } on AppException catch (e) {
      state = WorkoutState.error(e.message);
    } catch (e) {
      state = WorkoutState.error('Erro ao carregar treinos: ${e.toString()}');
    }
  }

  /// Filtra treinos por categoria
  void filterByCategory(String category) {
    if (state.workouts.isEmpty) return;
    
    try {
      // Se a categoria for vazia (todas), remove o filtro
      if (category.isEmpty) {
        state = state.copyWith(
          filteredWorkouts: state.workouts,
          filter: state.filter.copyWith(category: ''),
        );
        return;
      }

      final filtered = state.workouts
          .where((workout) => workout.type.toLowerCase() == category.toLowerCase())
          .toList();

      state = state.copyWith(
        filteredWorkouts: filtered,
        filter: state.filter.copyWith(category: category),
      );
    } catch (e) {
      state = WorkoutState.error('Erro ao filtrar treinos: ${e.toString()}');
    }
  }

  /// Filtra treinos por duração máxima
  void filterByDuration(int minutes) {
    if (state.workouts.isEmpty) return;
    
    try {
      // Se minutos for 0, remove o filtro de duração
      if (minutes == 0) {
        // Manter apenas o filtro de categoria se existir
        if (state.filter.category.isNotEmpty) {
          filterByCategory(state.filter.category);
        } else {
          state = state.copyWith(
            filteredWorkouts: state.workouts,
            filter: state.filter.copyWith(maxDuration: 0),
          );
        }
        return;
      }

      // Aplicar filtro de duração junto com o filtro de categoria, se existir
      List<Workout> baseWorkouts = state.workouts;
      if (state.filter.category.isNotEmpty) {
        baseWorkouts = baseWorkouts
            .where((w) => w.type.toLowerCase() == state.filter.category.toLowerCase())
            .toList();
      }

      final durationFiltered = baseWorkouts
          .where((workout) => workout.durationMinutes <= minutes)
          .toList();

      state = state.copyWith(
        filteredWorkouts: durationFiltered,
        filter: state.filter.copyWith(maxDuration: minutes),
      );
    } catch (e) {
      state = WorkoutState.error('Erro ao filtrar treinos: ${e.toString()}');
    }
  }

  /// Filtra treinos por dificuldade
  void filterByDifficulty(String difficulty) {
    if (state.workouts.isEmpty) return;
    
    try {
      // Se a dificuldade for vazia (todas), remove o filtro
      if (difficulty.isEmpty) {
        // Reaplica outros filtros se existirem
        if (state.filter.category.isNotEmpty || state.filter.maxDuration > 0) {
          List<Workout> filtered = state.workouts;
          
          if (state.filter.category.isNotEmpty) {
            filtered = filtered
                .where((w) => w.type.toLowerCase() == state.filter.category.toLowerCase())
                .toList();
          }
          
          if (state.filter.maxDuration > 0) {
            filtered = filtered
                .where((w) => w.durationMinutes <= state.filter.maxDuration)
                .toList();
          }
          
          state = state.copyWith(
            filteredWorkouts: filtered,
            filter: state.filter.copyWith(difficulty: ''),
          );
        } else {
          state = state.copyWith(
            filteredWorkouts: state.workouts,
            filter: state.filter.copyWith(difficulty: ''),
          );
        }
        return;
      }

      // Aplicar filtro de dificuldade junto com outros filtros, se existirem
      List<Workout> baseWorkouts = state.workouts;
      
      if (state.filter.category.isNotEmpty) {
        baseWorkouts = baseWorkouts
            .where((w) => w.type.toLowerCase() == state.filter.category.toLowerCase())
            .toList();
      }
      
      if (state.filter.maxDuration > 0) {
        baseWorkouts = baseWorkouts
            .where((w) => w.durationMinutes <= state.filter.maxDuration)
            .toList();
      }

      final difficultyFiltered = baseWorkouts
          .where((workout) => workout.difficulty.toLowerCase() == difficulty.toLowerCase())
          .toList();

      state = state.copyWith(
        filteredWorkouts: difficultyFiltered,
        filter: state.filter.copyWith(difficulty: difficulty),
      );
    } catch (e) {
      state = WorkoutState.error('Erro ao filtrar treinos: ${e.toString()}');
    }
  }

  /// Reseta todos os filtros aplicados
  void resetFilters() {
    if (state.workouts.isEmpty) return;
    
    state = state.copyWith(
      filteredWorkouts: state.workouts,
      filter: const WorkoutFilter(),
    );
  }

  /// Seleciona um treino específico para visualização detalhada
  Future<void> selectWorkout(String id) async {
    try {
      state = WorkoutState.loading();
      
      final workout = await _repository.getWorkoutById(id);
      
      state = WorkoutState.selectedWorkout(
        workout: workout,
        workouts: state.workouts,
        categories: state.categories,
      );
    } on AppException catch (e) {
      state = WorkoutState.error(e.message);
    } catch (e) {
      state = WorkoutState.error('Erro ao selecionar treino: ${e.toString()}');
    }
  }

  /// Limpa o treino selecionado e volta para a listagem
  void clearSelection() {
    if (state.workouts.isEmpty) {
      loadWorkouts();
      return;
    }
    
    state = WorkoutState.loaded(
      workouts: state.workouts,
      filteredWorkouts: state.filteredWorkouts,
      categories: state.categories,
      filter: state.filter,
    );
  }

  /// Cria um novo treino
  Future<void> createWorkout(Workout workout) async {
    try {
      state = WorkoutState.loading();
      
      final createdWorkout = await _repository.createWorkout(workout);
      
      // Adicionar o novo treino à lista e recarregar categorias
      final updatedWorkouts = [...state.workouts, createdWorkout];
      
      // Atualizar categorias
      final categoriesSet = <String>{};
      for (var w in updatedWorkouts) {
        if (w.type.isNotEmpty) {
          categoriesSet.add(w.type);
        }
      }
      
      state = WorkoutState.loaded(
        workouts: updatedWorkouts,
        filteredWorkouts: state.filter == const WorkoutFilter() 
            ? updatedWorkouts 
            : state.filteredWorkouts,
        categories: categoriesSet.toList(),
        filter: state.filter,
      );
    } on AppException catch (e) {
      state = WorkoutState.error(e.message);
    } catch (e) {
      state = WorkoutState.error('Erro ao criar treino: ${e.toString()}');
    }
  }

  /// Atualiza um treino existente
  Future<void> updateWorkout(Workout workout) async {
    try {
      state = WorkoutState.loading();
      
      final updatedWorkout = await _repository.updateWorkout(workout);
      
      // Atualizar o treino na lista
      final updatedWorkouts = state.workouts.map((w) => 
        w.id == updatedWorkout.id ? updatedWorkout : w
      ).toList();
      
      // Atualizar treinos filtrados também
      final updatedFilteredWorkouts = state.filteredWorkouts.map((w) => 
        w.id == updatedWorkout.id ? updatedWorkout : w
      ).toList();
      
      state = WorkoutState.loaded(
        workouts: updatedWorkouts,
        filteredWorkouts: updatedFilteredWorkouts,
        categories: state.categories,
        filter: state.filter,
      );
    } on AppException catch (e) {
      state = WorkoutState.error(e.message);
    } catch (e) {
      state = WorkoutState.error('Erro ao atualizar treino: ${e.toString()}');
    }
  }

  /// Exclui um treino
  Future<void> deleteWorkout(String id) async {
    try {
      state = WorkoutState.loading();
      
      await _repository.deleteWorkout(id);
      
      // Remover o treino da lista
      final updatedWorkouts = state.workouts.where((w) => w.id != id).toList();
      
      // Remover o treino da lista filtrada também
      final updatedFilteredWorkouts = state.filteredWorkouts.where((w) => w.id != id).toList();
      
      // Atualizar categorias (alguma categoria pode ter desaparecido)
      final categoriesSet = <String>{};
      for (var w in updatedWorkouts) {
        if (w.type.isNotEmpty) {
          categoriesSet.add(w.type);
        }
      }
      
      state = WorkoutState.loaded(
        workouts: updatedWorkouts,
        filteredWorkouts: updatedFilteredWorkouts,
        categories: categoriesSet.toList(),
        filter: state.filter,
      );
    } on AppException catch (e) {
      state = WorkoutState.error(e.message);
    } catch (e) {
      state = WorkoutState.error('Erro ao excluir treino: ${e.toString()}');
    }
  }
} 