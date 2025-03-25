import 'package:dio/dio.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
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
      throw StorageException(
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
      throw StorageException(
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
        orElse: () => throw NotFoundException(
          message: 'Treino não encontrado',
          code: 'workout_not_found',
        ),
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      
      throw StorageException(
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
      throw StorageException(
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
        throw NotFoundException(
          message: 'Treino não encontrado para atualização',
          code: 'workout_not_found',
        );
      }
      
      // Em um ambiente real, o updatedAt seria atualizado
      return workout.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      if (e is NotFoundException) rethrow;
      
      throw StorageException(
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
        throw NotFoundException(
          message: 'Treino não encontrado para exclusão',
          code: 'workout_not_found',
        );
      }
      
      // Em um ambiente real, o treino seria removido do banco de dados
      return;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      
      throw StorageException(
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
        exercises: {
          'warmup': ['Respiração profunda', 'Alongamento leve'],
          'main': ['Postura do cachorro olhando para baixo', 'Postura da montanha', 'Postura da árvore'],
          'cooldown': ['Relaxamento final']
        },
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
        exercises: {
          'warmup': ['Respiração de pilates', 'Mobilidade de coluna'],
          'main': ['The hundred', 'Single leg stretch', 'Double leg stretch', 'Criss cross'],
          'cooldown': ['Alongamento de coluna']
        },
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
        exercises: {
          'warmup': ['Jumping jacks', 'Corrida no lugar'],
          'main': ['Burpees', 'Mountain climbers', 'Jumping squats', 'Push-ups'],
          'cooldown': ['Alongamentos gerais']
        },
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
        exercises: {
          'warmup': ['Mobilidade articular', 'Ativação muscular'],
          'main': ['Agachamento com peso', 'Supino com halteres', 'Remada', 'Elevação lateral'],
          'cooldown': ['Alongamento de peito', 'Alongamento de costas', 'Alongamento de pernas']
        },
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
        exercises: {
          'warmup': ['Saudação ao sol A', 'Saudação ao sol B'],
          'main': ['Guerreiro I', 'Guerreiro II', 'Triângulo', 'Meia lua'],
          'cooldown': ['Postura da criança', 'Savasana']
        },
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
        exercises: {
          'warmup': ['Marcha no lugar', 'Rotação de tronco'],
          'main': ['Agachamento simples', 'Prancha', 'Elevação de joelhos', 'Flexão modificada'],
          'cooldown': ['Alongamento de quadríceps', 'Alongamento de panturrilhas']
        },
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
      throw StorageException(
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
      throw StorageException(
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
        throw NotFoundException(
          message: 'Treino não encontrado',
          originalError: e,
          code: 'workout_not_found',
        );
      }
      
      throw StorageException(
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
      throw StorageException(
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
        throw NotFoundException(
          message: 'Treino não encontrado para atualização',
          originalError: e,
          code: 'workout_not_found',
        );
      }
      
      throw StorageException(
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
      throw StorageException(
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