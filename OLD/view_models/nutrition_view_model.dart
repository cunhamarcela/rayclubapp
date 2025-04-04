import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/nutrition_item.dart';
import '../repositories/nutrition_repository.dart';
import '../core/exceptions/repository_exception.dart';
import '../core/providers/providers.dart';

part 'nutrition_view_model.freezed.dart';

/// State for the nutrition view model
@freezed
class NutritionState with _$NutritionState {
  /// Default state with parameters
  const factory NutritionState({
    @Default([]) List<NutritionItem> nutritionItems,
    @Default([]) List<NutritionItem> filteredItems,
    @Default([]) List<String> categories,
    @Default('') String selectedCategory,
    NutritionItem? selectedItem,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _NutritionState;

  /// Initial state
  const factory NutritionState.initial() = _Initial;

  /// Loading state
  const factory NutritionState.loading() = _Loading;

  /// Success state with data
  const factory NutritionState.success({
    required List<NutritionItem> nutritionItems,
    required List<NutritionItem> filteredItems,
    required List<String> categories,
    @Default('') String selectedCategory,
    NutritionItem? selectedItem,
    String? message,
  }) = _Success;

  /// Error state
  const factory NutritionState.error({
    required String message,
  }) = _Error;
}

/// Provider for the nutrition view model
final nutritionViewModelProvider = StateNotifierProvider<NutritionViewModel, NutritionState>((ref) {
  final repository = ref.watch(nutritionRepositoryProvider);
  return NutritionViewModel(repository: repository);
});

/// ViewModel for managing nutrition items
class NutritionViewModel extends StateNotifier<NutritionState> {
  final NutritionRepository _repository;

  NutritionViewModel({required NutritionRepository repository})
      : _repository = repository,
        super(const NutritionState.initial()) {
    loadNutritionItems();
  }

  /// Extracts error message from an exception
  String _getErrorMessage(dynamic error) {
    if (error is RepositoryException) {
      return error.message;
    }
    return error.toString();
  }

  /// Loads all nutrition items from the repository
  Future<void> loadNutritionItems() async {
    try {
      state = const NutritionState.loading();
      final items = await _repository.getNutritionItems();
      
      // Extract unique categories
      final categorySet = <String>{};
      for (var item in items) {
        if (item.category.isNotEmpty) {
          categorySet.add(item.category);
        }
      }
      
      state = NutritionState.success(
        nutritionItems: items,
        filteredItems: items,
        categories: categorySet.toList(),
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Gets details for a specific nutrition item
  Future<void> getNutritionItemDetails(String itemId) async {
    try {
      state = const NutritionState.loading();
      final item = await _repository.getNutritionItemById(itemId);
      
      // Keep current state values
      state = state.copyWith(
        isLoading: false,
        selectedItem: item,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Filters nutrition items by category
  void filterByCategory(String category) {
    // Keep current items
    final currentItems = state.nutritionItems;
    
    if (currentItems.isEmpty) return;
    
    try {
      if (category.isEmpty) {
        // Reset filters
        state = state.copyWith(
          filteredItems: currentItems,
          selectedCategory: '',
        );
        return;
      }
      
      // Filter items by category
      final filteredItems = currentItems
          .where((item) => item.category.toLowerCase() == category.toLowerCase())
          .toList();
      
      state = state.copyWith(
        filteredItems: filteredItems,
        selectedCategory: category,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Filter recipes by author (nutri or ray)
  void filterRecipesByAuthor(String author) {
    // Keep current items
    final currentItems = state.nutritionItems;
    
    if (currentItems.isEmpty) return;
    
    try {
      // Filter recipes by the specified author
      final filteredItems = currentItems
          .where((item) => 
              item.category.toLowerCase() == 'recipe' && 
              item.author.toLowerCase() == author.toLowerCase())
          .toList();
      
      state = state.copyWith(
        filteredItems: filteredItems,
        selectedCategory: 'recipe',
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Loads featured nutrition items
  Future<void> loadFeaturedItems() async {
    try {
      state = const NutritionState.loading();
      final items = await _repository.getFeaturedNutritionItems();
      
      // Keep current items and categories
      state = state.copyWith(
        filteredItems: items,
        isLoading: false,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Creates a new nutrition item
  Future<void> createNutritionItem(NutritionItem item) async {
    try {
      state = const NutritionState.loading();
      final newItem = await _repository.createNutritionItem(item);
      
      // Update lists with new item
      final updatedItems = [...state.nutritionItems, newItem];
      
      // Update categories if needed
      final updatedCategories = [...state.categories];
      if (!updatedCategories.contains(newItem.category)) {
        updatedCategories.add(newItem.category);
      }
      
      state = state.copyWith(
        nutritionItems: updatedItems,
        filteredItems: state.selectedCategory.isEmpty ?
            updatedItems :
            state.selectedCategory == newItem.category ?
                [...state.filteredItems, newItem] :
                state.filteredItems,
        categories: updatedCategories,
        successMessage: 'Item de nutrição criado com sucesso!',
        isLoading: false,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Updates an existing nutrition item
  Future<void> updateNutritionItem(NutritionItem item) async {
    try {
      state = const NutritionState.loading();
      final updatedItem = await _repository.updateNutritionItem(item);
      
      // Update item in lists
      final updatedItems = state.nutritionItems.map((i) {
        return i.id == item.id ? updatedItem : i;
      }).toList();
      
      // Update filtered items
      final updatedFiltered = state.filteredItems.map((i) {
        return i.id == item.id ? updatedItem : i;
      }).toList();
      
      state = state.copyWith(
        nutritionItems: updatedItems,
        filteredItems: updatedFiltered,
        selectedItem: updatedItem,
        successMessage: 'Item de nutrição atualizado com sucesso!',
        isLoading: false,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }

  /// Deletes a nutrition item
  Future<void> deleteNutritionItem(String itemId) async {
    try {
      state = const NutritionState.loading();
      await _repository.deleteNutritionItem(itemId);
      
      // Remove item from lists
      final updatedItems = state.nutritionItems
          .where((i) => i.id != itemId)
          .toList();
      
      final updatedFiltered = state.filteredItems
          .where((i) => i.id != itemId)
          .toList();
      
      // Recalculate categories
      final categorySet = <String>{};
      for (var item in updatedItems) {
        if (item.category.isNotEmpty) {
          categorySet.add(item.category);
        }
      }
      
      state = state.copyWith(
        nutritionItems: updatedItems,
        filteredItems: updatedFiltered,
        categories: categorySet.toList(),
        successMessage: 'Item de nutrição excluído com sucesso!',
        isLoading: false,
      );
    } catch (e) {
      state = NutritionState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Clears the selected item
  void clearSelectedItem() {
    state = state.copyWith(selectedItem: null);
  }

  /// Resets all filters
  void resetFilters() {
    state = state.copyWith(
      filteredItems: state.nutritionItems,
      selectedCategory: '',
    );
  }
} 