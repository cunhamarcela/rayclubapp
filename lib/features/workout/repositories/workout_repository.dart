import 'package:dio/dio.dart';
import 'package:ray_club_app/core/errors/app_exception.dart' as app_errors;
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Interface para o repositório de treinos
abstract class WorkoutRepository {
  /// Obtém todos os treinos
  Future<List<Workout>> getWorkouts();

  /// Obtém treinos por categoria
  Future<List<Workout>> getWorkoutsByCategory(String category);

  /// Obtém um treino específico pelo ID
  Future<Workout> getWorkoutById(String id);
  
  /// Cria um novo treino
  Future<Workout> createWorkout(Workout workout);
  
  /// Atualiza um treino existente
  Future<Workout> updateWorkout(Workout workout);
  
  /// Exclui um treino
  Future<void> deleteWorkout(String id);
}

/// Implementação mock do repositório para desenvolvimento
class MockWorkoutRepository implements WorkoutRepository {
  @override
  Future<List<Workout>> getWorkouts() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      return _getMockWorkouts();
    } catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao carregar treinos',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Workout>> getWorkoutsByCategory(String category) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final allWorkouts = _getMockWorkouts();
      return allWorkouts
          .where((workout) => workout.type.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao carregar treinos por categoria',
        originalError: e,
      );
    }
  }

  @override
  Future<Workout> getWorkoutById(String id) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final allWorkouts = _getMockWorkouts();
      return allWorkouts.firstWhere(
        (workout) => workout.id == id,
        orElse: () => throw app_errors.NotFoundException(
          message: 'Treino não encontrado',
          code: 'workout_not_found',
        ),
      );
    } catch (e) {
      if (e is app_errors.NotFoundException) rethrow;
      
      throw app_errors.StorageException(
        message: 'Erro ao carregar treino',
        originalError: e,
      );
    }
  }
  
  @override
  Future<Workout> createWorkout(Workout workout) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));
    
    try {
      // Em um ambiente real, o ID seria gerado pelo backend
      return workout.copyWith(
        id: 'new-${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao criar treino',
        originalError: e,
      );
    }
  }

  @override
  Future<Workout> updateWorkout(Workout workout) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      // Verificar se o treino existe
      final allWorkouts = _getMockWorkouts();
      final exists = allWorkouts.any((w) => w.id == workout.id);
      
      if (!exists) {
        throw app_errors.NotFoundException(
          message: 'Treino não encontrado para atualização',
          code: 'workout_not_found',
        );
      }
      
      // Em um ambiente real, o updatedAt seria atualizado
      return workout.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      if (e is app_errors.NotFoundException) rethrow;
      
      throw app_errors.StorageException(
        message: 'Erro ao atualizar treino',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 600));
    
    try {
      // Verificar se o treino existe
      final allWorkouts = _getMockWorkouts();
      final exists = allWorkouts.any((workout) => workout.id == id);
      
      if (!exists) {
        throw app_errors.NotFoundException(
          message: 'Treino não encontrado para exclusão',
          code: 'workout_not_found',
        );
      }
      
      // Em um ambiente real, o treino seria removido do banco de dados
      return;
    } catch (e) {
      if (e is app_errors.NotFoundException) rethrow;
      
      throw app_errors.StorageException(
        message: 'Erro ao excluir treino',
        originalError: e,
      );
    }
  }

  // TEMPORÁRIO: Método para gerar dados mockados
  List<Workout> _getMockWorkouts() {
    final now = DateTime.now();
    
    return [
      Workout(
        id: '1',
        title: 'Yoga para Iniciantes',
        description: 'Um treino de yoga suave para quem está começando a praticar.',
        imageUrl: 'assets/images/categories/yoga.png',
        type: 'Yoga',
        durationMinutes: 20,
        difficulty: 'Iniciante',
        equipment: ['Tapete', 'Bloco de yoga'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Respiração profunda'),
              Exercise(name: 'Alongamento leve'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'Postura do cachorro olhando para baixo'),
              Exercise(name: 'Postura da montanha'),
              Exercise(name: 'Postura da árvore'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Relaxamento final'),
            ],
          ),
        ],
        creatorId: 'instrutor1',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      Workout(
        id: '2',
        title: 'Pilates Abdominal',
        description: 'Treino focado no fortalecimento do core e abdômen usando técnicas de pilates.',
        imageUrl: 'assets/images/categories/pilates.png',
        type: 'Pilates',
        durationMinutes: 30,
        difficulty: 'Intermediário',
        equipment: ['Tapete', 'Bola pequena'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Respiração de pilates'),
              Exercise(name: 'Mobilidade de coluna'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'The hundred'),
              Exercise(name: 'Single leg stretch'),
              Exercise(name: 'Double leg stretch'),
              Exercise(name: 'Criss cross'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Alongamento de coluna'),
            ],
          ),
        ],
        creatorId: 'instrutor2',
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      Workout(
        id: '3',
        title: 'HIIT 15 minutos',
        description: 'Treino de alta intensidade para queimar calorias em pouco tempo.',
        imageUrl: 'assets/images/workout_default.jpg',
        type: 'HIIT',
        durationMinutes: 15,
        difficulty: 'Avançado',
        equipment: ['Tapete'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Jumping jacks'),
              Exercise(name: 'Corrida no lugar'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'Burpees'),
              Exercise(name: 'Mountain climbers'),
              Exercise(name: 'Jumping squats'),
              Exercise(name: 'Push-ups'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Alongamentos gerais'),
            ],
          ),
        ],
        creatorId: 'instrutor3',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Workout(
        id: '4',
        title: 'Treino de Força Total',
        description: 'Treino completo para ganho de força muscular em todo o corpo.',
        imageUrl: 'assets/images/categories/musculacao.jpg',
        type: 'Musculação',
        durationMinutes: 45,
        difficulty: 'Intermediário',
        equipment: ['Halteres', 'Banco'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Mobilidade articular'),
              Exercise(name: 'Ativação muscular'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'Agachamento com peso'),
              Exercise(name: 'Supino com halteres'),
              Exercise(name: 'Remada'),
              Exercise(name: 'Elevação lateral'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Alongamento de peito'),
              Exercise(name: 'Alongamento de costas'),
              Exercise(name: 'Alongamento de pernas'),
            ],
          ),
        ],
        creatorId: 'instrutor4',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Workout(
        id: '5',
        title: 'Yoga Flow',
        description: 'Sequência fluida de posturas de yoga para melhorar flexibilidade e equilíbrio.',
        imageUrl: 'assets/images/categories/yoga.png',
        type: 'Yoga',
        durationMinutes: 40,
        difficulty: 'Intermediário',
        equipment: ['Tapete', 'Bloco de yoga'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Saudação ao sol A'),
              Exercise(name: 'Saudação ao sol B'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'Guerreiro I'),
              Exercise(name: 'Guerreiro II'),
              Exercise(name: 'Triângulo'),
              Exercise(name: 'Meia lua'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Postura da criança'),
              Exercise(name: 'Savasana'),
            ],
          ),
        ],
        creatorId: 'instrutor1',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Workout(
        id: '6',
        title: 'HIIT para Iniciantes',
        description: 'Versão mais acessível de HIIT para quem está começando.',
        imageUrl: 'assets/images/workout_default.jpg',
        type: 'HIIT',
        durationMinutes: 20,
        difficulty: 'Iniciante',
        equipment: ['Tapete', 'Garrafa de água como peso'],
        sections: [
          WorkoutSection(
            name: 'Aquecimento',
            exercises: [
              Exercise(name: 'Marcha no lugar'),
              Exercise(name: 'Rotação de tronco'),
            ],
          ),
          WorkoutSection(
            name: 'Parte principal',
            exercises: [
              Exercise(name: 'Agachamento simples'),
              Exercise(name: 'Prancha'),
              Exercise(name: 'Elevação de joelhos'),
              Exercise(name: 'Flexão modificada'),
            ],
          ),
          WorkoutSection(
            name: 'Finalização',
            exercises: [
              Exercise(name: 'Alongamento de quadríceps'),
              Exercise(name: 'Alongamento de panturrilhas'),
            ],
          ),
        ],
        creatorId: 'instrutor3',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}

/// Implementação real do repositório usando Supabase
class SupabaseWorkoutRepository implements WorkoutRepository {
  final SupabaseClient _supabaseClient;

  SupabaseWorkoutRepository(this._supabaseClient);

  @override
  Future<List<Workout>> getWorkouts() async {
    try {
      final response = await _supabaseClient
          .from('workouts')
          .select()
          .order('created_at', ascending: false);
      
      return response.map((json) => Workout.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao carregar treinos do Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().getWorkouts();
    }
  }
  
  @override
  Future<List<Workout>> getWorkoutsByCategory(String category) async {
    try {
      final response = await _supabaseClient
          .from('workouts')
          .select()
          .eq('type', category)
          .order('created_at', ascending: false);
      
      return response.map((json) => Workout.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao carregar treinos por categoria do Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().getWorkoutsByCategory(category);
    }
  }
  
  @override
  Future<Workout> getWorkoutById(String id) async {
    try {
      final response = await _supabaseClient
          .from('workouts')
          .select()
          .eq('id', id)
          .single();
      
      return Workout.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw app_errors.NotFoundException(
          message: 'Treino não encontrado',
          originalError: e,
          code: 'workout_not_found',
        );
      }
      
      throw app_errors.StorageException(
        message: 'Erro ao carregar treino do Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().getWorkoutById(id);
    }
  }
  
  @override
  Future<Workout> createWorkout(Workout workout) async {
    try {
      // Remover o ID para que o Supabase gere um novo
      final workoutMap = workout.toJson();
      workoutMap.remove('id');
      
      // Adicionar o ID do usuário atual como criador
      workoutMap['creator_id'] = _supabaseClient.auth.currentUser?.id;
      
      final response = await _supabaseClient
          .from('workouts')
          .insert(workoutMap)
          .select()
          .single();
      
      return Workout.fromJson(response);
    } on PostgrestException catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao criar treino no Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().createWorkout(workout);
    }
  }
  
  @override
  Future<Workout> updateWorkout(Workout workout) async {
    try {
      final workoutMap = workout.toJson();
      workoutMap['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _supabaseClient
          .from('workouts')
          .update(workoutMap)
          .eq('id', workout.id)
          .select()
          .single();
      
      return Workout.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw app_errors.NotFoundException(
          message: 'Treino não encontrado para atualização',
          originalError: e,
          code: 'workout_not_found',
        );
      }
      
      throw app_errors.StorageException(
        message: 'Erro ao atualizar treino no Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().updateWorkout(workout);
    }
  }
  
  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await _supabaseClient
          .from('workouts')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw app_errors.StorageException(
        message: 'Erro ao excluir treino no Supabase',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      // Se não for um erro específico do Supabase, usar dados mockados em desenvolvimento
      return MockWorkoutRepository().deleteWorkout(id);
    }
  }
} 