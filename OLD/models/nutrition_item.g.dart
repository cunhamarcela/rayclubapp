// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionItemImpl _$$NutritionItemImplFromJson(Map<String, dynamic> json) =>
    _$NutritionItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      preparationTimeMinutes: (json['preparationTimeMinutes'] as num).toInt(),
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isFeatured: json['isFeatured'] as bool? ?? false,
      nutritionistTip: json['nutritionistTip'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      author: json['author'] as String? ?? '',
    );

Map<String, dynamic> _$$NutritionItemImplToJson(_$NutritionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'preparationTimeMinutes': instance.preparationTimeMinutes,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'tags': instance.tags,
      'isFeatured': instance.isFeatured,
      'nutritionistTip': instance.nutritionistTip,
      'createdAt': instance.createdAt?.toIso8601String(),
      'author': instance.author,
    };
