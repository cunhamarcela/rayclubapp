// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../core/theme/app_theme.dart';
import '../../../shared/bottom_navigation_bar.dart';
import '../viewmodels/nutrition_view_model.dart';
import '../../../core/router/app_router.dart';

/// Tela de nutrição que exibe receitas da nutricionista e da Ray
@RoutePage()
class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionState = ref.watch(nutritionViewModelProvider);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildTabBar(),
              Expanded(
                child: nutritionState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : nutritionState.errorMessage != null
                        ? Center(
                            child: Text('Erro: ${nutritionState.errorMessage}'),
                          )
                        : _buildTabContent(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título da página
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nutrição',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Receitas saudáveis e deliciosas',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ),
          
          // Ícone de pesquisa
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 28),
              color: const Color(0xFF333333),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFF09ADFC),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF555555),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: 'Receitas da Nutricionista'),
          Tab(text: 'Receitas da Ray'),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return TabBarView(
      children: [
        _buildNutritionistRecipes(context),
        _buildRayRecipes(context),
      ],
    );
  }

  Widget _buildNutritionistRecipes(BuildContext context) {
    // Dados mock para demonstração
    final recipes = [
      {
        'id': 'quinoa_salad',
        'title': 'Salada de Quinoa com Legumes',
        'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Rica em proteínas e fibras, perfeita para o almoço',
        'prepTime': '25 min',
        'calories': '320 kcal',
        'featured': true,
      },
      {
        'id': 'acai_bowl',
        'title': 'Bowl de Açaí com Frutas',
        'image': 'https://images.unsplash.com/photo-1546039907-7fa05f864c02?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Antioxidantes naturais com frutas da estação',
        'prepTime': '10 min',
        'calories': '280 kcal',
        'featured': false,
      },
      {
        'id': 'green_smoothie',
        'title': 'Smoothie Verde Detox',
        'image': 'https://images.unsplash.com/photo-1556881286-ba11a90bb0b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Perfeito para desintoxicar o organismo',
        'prepTime': '5 min',
        'calories': '150 kcal',
        'featured': false,
      },
      {
        'id': 'oat_pancakes',
        'title': 'Panquecas de Aveia e Banana',
        'image': 'https://images.unsplash.com/photo-1565299543923-37dd37887442?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Café da manhã saudável e energético',
        'prepTime': '15 min',
        'calories': '310 kcal',
        'featured': false,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner destaque
          _buildFeaturedRecipe(context, recipes.firstWhere((recipe) => recipe['featured'] == true)),
          
          const SizedBox(height: 32),
          const Text(
            'Todas as Receitas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // Lista de receitas
          ...recipes
              .where((recipe) => recipe['featured'] != true)
              .map((recipe) => _buildRecipeCard(context, recipe))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRayRecipes(BuildContext context) {
    // Dados mock para demonstração
    final recipes = [
      {
        'id': 'chicken_wrap',
        'title': 'Wrap de Frango Fit',
        'image': 'https://images.unsplash.com/photo-1513442542250-854d436a73f2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Perfeito para o pós-treino, rico em proteínas',
        'prepTime': '15 min',
        'calories': '380 kcal',
        'featured': true,
      },
      {
        'id': 'egg_whites_omelet',
        'title': 'Omelete de Claras com Vegetais',
        'image': 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Alto teor proteico e baixas calorias',
        'prepTime': '10 min',
        'calories': '220 kcal',
        'featured': false,
      },
      {
        'id': 'strawberry_shake',
        'title': 'Shake Proteico de Morango',
        'image': 'https://images.unsplash.com/photo-1553530666-ba11a90bb0b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Recuperação muscular pós-treino',
        'prepTime': '5 min',
        'calories': '250 kcal',
        'featured': false,
      },
      {
        'id': 'tuna_salad',
        'title': 'Salada de Atum com Ovos',
        'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        'description': 'Refeição rápida e nutritiva',
        'prepTime': '10 min',
        'calories': '340 kcal',
        'featured': false,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner destaque
          _buildFeaturedRecipe(context, recipes.firstWhere((recipe) => recipe['featured'] == true)),
          
          const SizedBox(height: 32),
          const Text(
            'Todas as Receitas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // Lista de receitas
          ...recipes
              .where((recipe) => recipe['featured'] != true)
              .map((recipe) => _buildRecipeCard(context, recipe))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildFeaturedRecipe(BuildContext context, Map<String, dynamic> recipe) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          Image.network(
            recipe['image'],
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) => Container(
              color: const Color(0xFF09ADFC).withOpacity(0.3),
            ),
          ),
          
          // Gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09ADFC),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Destaque',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  recipe['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe['description'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Material para efeito de toque
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navegação para detalhes da receita
                final recipeWithDetails = {
                  ...recipe,
                  'id': recipe['id'] ?? '1',
                  'rating': '4.5',
                  'servings': '03',
                  'difficulty': 'Easy',
                  'category': 'Breakfast'
                };
                
                AppNavigator.navigateToRecipeDetail(
                  context,
                  recipeWithDetails['id'],
                  recipeWithDetails,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navegação para detalhes da receita
            final recipeWithDetails = {
              ...recipe,
              'id': recipe['id'] ?? '1',
              'rating': '4.5',
              'servings': '03',
              'difficulty': 'Easy',
              'category': 'Meal'
            };
            
            AppNavigator.navigateToRecipeDetail(
              context,
              recipeWithDetails['id'],
              recipeWithDetails,
            );
          },
          child: Row(
            children: [
              // Imagem da receita
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: Image.network(
                    recipe['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => Container(
                      color: const Color(0xFF09ADFC).withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              
              // Detalhes da receita
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Tempo de preparo
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Color(0xFF09ADFC),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                recipe['prepTime'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Calorias
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.local_fire_department,
                                  size: 16,
                                  color: Color(0xFF09ADFC),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                recipe['calories'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
