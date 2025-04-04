import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_item.freezed.dart';
part 'nutrition_item.g.dart';

/// Modelo para representar um item de nutrição (receita ou dica)
@freezed
class NutritionItem with _$NutritionItem {
  const factory NutritionItem({
    required String id,
    required String title,
    required String description,
    required String category, // Ex: 'recipe', 'tip'
    required String imageUrl,
    required int preparationTimeMinutes, // Tempo de preparo (apenas para receitas)
    @Default([]) List<String> ingredients,
    @Default([]) List<String> instructions,
    @Default([]) List<String> tags,
    @Default(false) bool isFeatured,
    String? nutritionistTip, // Dica da nutricionista (opcional)
    DateTime? createdAt,
    @Default('') String author, // Ex: 'nutri', 'ray'
  }) = _NutritionItem;

  factory NutritionItem.fromJson(Map<String, dynamic> json) => 
    _$NutritionItemFromJson(json);
} 