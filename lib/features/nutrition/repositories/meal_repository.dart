import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/nutrition/models/meal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for MealRepository
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(Supabase.instance.client);
});

/// Repository for managing meal data
class MealRepository {
  final SupabaseClient _client;
  
  MealRepository(this._client);
  
  /// Fetch all meals for a user
  Future<List<Meal>> getMeals({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _client
          .from('meals')
          .select()
          .eq('user_id', userId)
          .order('date_time', ascending: false);
      
      // Add date filters if provided
      if (startDate != null) {
        query = query.gte('date_time', startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.lte('date_time', endDate.toIso8601String());
      }
      
      final response = await query;
      
      return response.map((data) => Meal.fromJson(data)).toList();
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to fetch meals',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Add a new meal
  Future<Meal> addMeal(Meal meal, String userId) async {
    try {
      final mealJson = meal.toJson();
      mealJson['user_id'] = userId;
      
      final response = await _client
          .from('meals')
          .insert(mealJson)
          .select()
          .single();
      
      return Meal.fromJson(response);
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to add meal',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Update an existing meal
  Future<Meal> updateMeal(Meal meal) async {
    try {
      final response = await _client
          .from('meals')
          .update(meal.toJson())
          .eq('id', meal.id)
          .select()
          .single();
      
      return Meal.fromJson(response);
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to update meal',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _client
          .from('meals')
          .delete()
          .eq('id', mealId);
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to delete meal',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
} 