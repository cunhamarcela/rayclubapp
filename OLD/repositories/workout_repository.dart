import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/models/workout.dart';
import 'package:ray_club_app/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IWorkoutRepository {
  Future<List<Workout>> getWorkouts();
  Future<List<Workout>> getWorkoutsByCategory(String category);
  Future<Workout> getWorkoutById(String id);
}

/// Repository for handling workout data
class WorkoutRepository implements IWorkoutRepository {
  final ApiService _apiService;
  
  WorkoutRepository(this._apiService);

  /// Get all workouts from the API
  @override
  Future<List<Workout>> getWorkouts() async {
    try {
      // TEMPORÁRIO: Usando dados mockados até termos uma API real
      return _getMockWorkouts();
      
      // Código original para quando tivermos uma API real:
      /*
      final response = await _apiService.get('/workouts');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Workout.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workouts: ${response.statusCode}');
      }
      */
    } on DioException catch (e) {
      throw Exception('Failed to load workouts: ${e.message}');
    }
  }

  /// Get workouts by category
  @override
  Future<List<Workout>> getWorkoutsByCategory(String category) async {
    try {
      // TEMPORÁRIO: Usando dados mockados até termos uma API real
      final allWorkouts = _getMockWorkouts();
      return allWorkouts.where((workout) => 
        workout.type.toLowerCase() == category.toLowerCase()
      ).toList();
      
      // Código original para quando tivermos uma API real:
      /*
      final response = await _apiService.get('/workouts?category=$category');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Workout.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workouts: ${response.statusCode}');
      }
      */
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting workouts by category: $e');
    }
  }

  /// Get workout details by ID
  @override
  Future<Workout> getWorkoutById(String id) async {
    try {
      // TEMPORÁRIO: Usando dados mockados até termos uma API real
      final allWorkouts = _getMockWorkouts();
      final workout = allWorkouts.firstWhere(
        (workout) => workout.id == id,
        orElse: () => throw Exception('Workout not found')
      );
      return workout;
      
      // Código original para quando tivermos uma API real:
      /*
      final response = await _apiService.get('/workouts/$id');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Workout.fromJson(data);
      } else {
        throw Exception('Failed to load workout: ${response.statusCode}');
      }
      */
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting workout: $e');
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
          'main': ['Agachamento simples', 'Flexão de joelhos', 'Prancha de antebraço', 'Elevação de pernas'],
          'cooldown': ['Respiração profunda', 'Alongamentos']
        },
        creatorId: 'instrutor3',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
