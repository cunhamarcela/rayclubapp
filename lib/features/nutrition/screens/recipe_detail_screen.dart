// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

@RoutePage()
class RecipeDetailScreen extends ConsumerWidget {
  final String recipeId;
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    super.key,
    @PathParam('id') required this.recipeId,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              color: AppColors.charcoal,
              onPressed: () => context.router.maybePop(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border, size: 22),
                color: Colors.black54,
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildRecipeImage(context),
            _buildRecipeContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          // Imagem principal
          Positioned.fill(
            child: Image.network(
              recipe['image'] ?? 'https://images.unsplash.com/photo-1565299543923-37dd37887442',
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                color: AppColors.cream.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeContent(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e avaliação
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da receita
                      Text(
                        recipe['title'] ?? 'Crepes with Orange and Honey',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Categoria
                      Text(
                        recipe['category'] ?? 'Meal',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Avaliação
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe['rating']?.toString() ?? '4.5',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 36),
            
            // Informações rápidas
            _buildInfoBadgesRow(context),
            
            const SizedBox(height: 48),
            
            // Ingredientes
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),
            _buildIngredientsList(),
            
            const SizedBox(height: 48),
            
            // Instruções
            const Text(
              'Directions',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),
            _buildDirections(),
            
            // Espaço adicional no final
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadgesRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoBadge(
          icon: Icons.access_time,
          value: _extractNumericValue(recipe['prepTime']) ?? '10',
          label: 'mins',
        ),
        _buildInfoBadge(
          icon: Icons.people_alt_outlined,
          value: recipe['servings'] ?? '03',
          label: 'Servings',
        ),
        _buildInfoBadge(
          icon: Icons.local_fire_department_outlined,
          value: _extractNumericValue(recipe['calories']) ?? '280',
          label: 'kcal',
        ),
        _buildInfoBadge(
          icon: Icons.layers_outlined,
          value: recipe['difficulty'] ?? 'Easy',
          isValueText: true,
          label: '',
        ),
      ],
    );
  }

  String? _extractNumericValue(dynamic input) {
    if (input == null) return null;
    
    // Se já for uma string, tenta extrair números
    if (input is String) {
      // Extrai apenas os números da string
      final RegExp regExp = RegExp(r'(\d+)');
      final match = regExp.firstMatch(input);
      return match?.group(1);
    }
    
    // Se for um número, converte para string
    if (input is num) {
      return input.toString();
    }
    
    return null;
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String value,
    bool isValueText = false,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.cream,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(height: 4),
                isValueText
                    ? Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientsList() {
    // Ingredientes de exemplo ou do próprio objeto recipe se existir
    final ingredients = [
      {'amount': '2', 'name': 'Eggs'},
      {'amount': '1 Cup', 'name': 'All purpose flour'},
      {'amount': '1/2 Cup', 'name': 'Whole milk'},
      {'amount': '2 Tablespoon', 'name': 'Butter'},
      {'amount': '2 Tablespoon', 'name': 'Sugar'},
    ];

    return Column(
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      ingredient['amount'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ingredient['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDirections() {
    final steps = [
      'In a medium bowl, whisk together the flour, sugar, salt, and baking powder.',
      'Make a well in the center and pour in the milk, egg, and melted butter.',
      'Whisk until smooth and let rest for about 10 minutes.',
      'Heat a lightly oiled frying pan over medium-high heat.',
      'Pour the batter onto the pan, using approximately 1/4 cup for each crepe.',
      'Tilt the pan in a circular motion so that the batter coats the surface evenly.',
      'Cook for about 2 minutes, until the bottom is light brown. Loosen with a spatula, turn and cook the other side.',
      'Serve hot with your choice of toppings.',
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  steps[index],
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}