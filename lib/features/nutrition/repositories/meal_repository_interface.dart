import 'package:ray_club_app/features/nutrition/models/meal.dart';

/// Interface para operações relacionadas a refeições
abstract class MealRepository {
  /// Busca todas as refeições do usuário
  Future<List<Meal>> getAllMeals();
  
  /// Busca uma refeição pelo ID
  Future<Meal?> getMealById(String id);
  
  /// Busca refeições por período
  Future<List<Meal>> getMealsByDateRange(DateTime startDate, DateTime endDate);
  
  /// Busca refeições por tipo
  Future<List<Meal>> getMealsByType(String type);
  
  /// Salva uma refeição (cria ou atualiza)
  Future<Meal> saveMeal(Meal meal);
  
  /// Exclui uma refeição
  Future<void> deleteMeal(String id);
  
  /// Marca uma refeição como favorita
  Future<void> toggleFavorite(String id, bool isFavorite);
  
  /// Adiciona imagem para uma refeição
  Future<String> uploadMealImage(String mealId, String localImagePath);
  
  /// Busca refeições favoritas
  Future<List<Meal>> getFavoriteMeals();
  
  /// Busca estatísticas de nutrição
  Future<Map<String, dynamic>> getNutritionStats(DateTime startDate, DateTime endDate);
} 