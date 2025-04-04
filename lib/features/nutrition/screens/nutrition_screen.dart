import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/features/nutrition/models/meal.dart';
import 'package:ray_club_app/features/nutrition/viewmodels/meal_view_model.dart';
import 'package:ray_club_app/features/nutrition/widgets/meal_card.dart';
import 'package:ray_club_app/features/nutrition/widgets/add_meal_sheet.dart';
import 'package:ray_club_app/shared/bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

/// Tela de nutrição que exibe receitas e dicas nutricionais
@RoutePage()
class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(mealViewModelProvider);
    
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 20,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Nutrição',
              style: TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _showDatePicker(context, ref);
            },
            color: AppColors.textDark,
          ),
        ],
      ),
      body: mealState.isLoading && mealState.meals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : mealState.error != null
              ? _buildErrorWidget(context, mealState.error!, ref)
              : _buildNutritionContent(context, mealState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealSheet(context, ref);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 2),
    );
  }

  // Widget para exibir mensagem de erro
  Widget _buildErrorWidget(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Ocorreu um erro:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(mealViewModelProvider.notifier).loadMeals();
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  // Conteúdo principal da tela
  Widget _buildNutritionContent(BuildContext context, MealState mealState) {
    if (mealState.meals.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumo de calorias
        _buildCaloriesSummary(context, mealState.meals),
        
        // Título das refeições
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Suas Refeições',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        
        // Lista de refeições - otimizada sem shrinkWrap
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mealState.meals.length,
            itemBuilder: (context, index) {
              return MealCard(
                meal: mealState.meals[index],
                onDelete: (mealId) {
                  _confirmDelete(context, mealId, ref);
                },
                onEdit: (meal) {
                  _showEditMealSheet(context, meal, ref);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget para estado vazio (sem refeições)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma refeição registrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione sua primeira refeição para começar a acompanhar sua nutrição',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showAddMealSheet(context, null);
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Refeição'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Resumo de calorias do dia
  Widget _buildCaloriesSummary(BuildContext context, List<Meal> meals) {
    // Filtrar refeições de hoje
    final today = DateTime.now();
    final todayMeals = meals.where((meal) {
      return meal.dateTime.year == today.year &&
          meal.dateTime.month == today.month &&
          meal.dateTime.day == today.day;
    }).toList();
    
    // Calcular totais
    final totalCalories = todayMeals.fold(0, (sum, meal) => sum + meal.calories);
    final totalProtein = todayMeals.fold(0.0, (sum, meal) => sum + meal.proteins);
    final totalCarbs = todayMeals.fold(0.0, (sum, meal) => sum + meal.carbs);
    final totalFats = todayMeals.fold(0.0, (sum, meal) => sum + meal.fats);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumo de Hoje',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(today),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutrientIndicator(
                'Calorias',
                totalCalories.toString(),
                'kcal',
                Colors.orange,
              ),
              _buildNutrientIndicator(
                'Proteínas',
                totalProtein.toStringAsFixed(1),
                'g',
                Colors.green,
              ),
              _buildNutrientIndicator(
                'Carboidratos',
                totalCarbs.toStringAsFixed(1),
                'g',
                Colors.blue,
              ),
              _buildNutrientIndicator(
                'Gorduras',
                totalFats.toStringAsFixed(1),
                'g',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Indicador de nutriente
  Widget _buildNutrientIndicator(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Mostrar seletor de data
  void _showDatePicker(BuildContext context, WidgetRef ref) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(initialDate.year - 1);
    final lastDate = DateTime(initialDate.year + 1);
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (selectedDate != null) {
      final endDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
      );
      
      ref.read(mealViewModelProvider.notifier).loadMeals(
        startDate: selectedDate,
        endDate: endDate,
      );
    }
  }

  // Mostrar bottom sheet para adicionar refeição
  void _showAddMealSheet(BuildContext context, WidgetRef? ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMealSheet(
        onSave: (Meal meal) {
          if (ref != null) {
            ref.read(mealViewModelProvider.notifier).addMeal(meal);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  // Mostrar bottom sheet para editar refeição
  void _showEditMealSheet(BuildContext context, Meal meal, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMealSheet(
        meal: meal,
        onSave: (updatedMeal) {
          ref.read(mealViewModelProvider.notifier).updateMeal(updatedMeal);
          Navigator.pop(context);
        },
      ),
    );
  }

  // Confirmar exclusão de refeição
  void _confirmDelete(BuildContext context, String mealId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta refeição?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(mealViewModelProvider.notifier).deleteMeal(mealId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
} 