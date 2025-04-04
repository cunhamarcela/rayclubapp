import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/benefit.dart';
import '../repositories/benefits_repository.dart';
import '../core/exceptions/repository_exception.dart';
import '../core/providers/providers.dart';

part 'benefit_view_model.freezed.dart';

/// State for the benefit view model
@freezed
class BenefitState with _$BenefitState {
  /// Default state with parameters
  const factory BenefitState({
    @Default([]) List<Benefit> benefits,
    @Default([]) List<Benefit> filteredBenefits,
    @Default([]) List<String> partners,
    @Default('all') String activeFilter,
    Benefit? selectedBenefit,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _BenefitState;

  /// Initial state
  const factory BenefitState.initial() = _Initial;

  /// Loading state
  const factory BenefitState.loading() = _Loading;

  /// Success state with data
  const factory BenefitState.success({
    required List<Benefit> benefits,
    @Default([]) List<Benefit> filteredBenefits,
    @Default([]) List<String> partners,
    @Default('all') String activeFilter,
    Benefit? selectedBenefit,
    String? message,
  }) = _Success;

  /// Error state
  const factory BenefitState.error({
    required String message,
  }) = _Error;
}

/// Provider for the benefit view model
final benefitViewModelProvider = StateNotifierProvider<BenefitViewModel, BenefitState>((ref) {
  final repository = ref.watch(benefitRepositoryProvider);
  return BenefitViewModel(repository: repository);
});

/// ViewModel for managing benefits
class BenefitViewModel extends StateNotifier<BenefitState> {
  final BenefitsRepository _repository;

  BenefitViewModel({required BenefitsRepository repository})
      : _repository = repository,
        super(const BenefitState.initial()) {
    loadBenefits();
  }

  /// Extracts error message from an exception
  String _getErrorMessage(dynamic error) {
    if (error is RepositoryException) {
      return error.message;
    }
    return error.toString();
  }

  /// Loads all benefits from the repository
  Future<void> loadBenefits() async {
    try {
      state = const BenefitState.loading();
      final benefits = await _repository.getAllBenefits();
      
      // Extract unique partners
      final partnerSet = <String>{};
      for (var benefit in benefits) {
        if (benefit.partner.isNotEmpty) {
          partnerSet.add(benefit.partner);
        }
      }
      
      state = BenefitState.success(
        benefits: benefits,
        filteredBenefits: benefits,
        partners: partnerSet.toList(),
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Gets details for a specific benefit
  Future<void> getBenefitDetails(String benefitId) async {
    try {
      state = const BenefitState.loading();
      final benefit = await _repository.getBenefitById(benefitId);
      
      state = state.copyWith(
        isLoading: false,
        selectedBenefit: benefit,
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Filters benefits by type
  void filterByType(String type) {
    if (state.benefits.isEmpty) return;
    
    try {
      final allBenefits = state.benefits;
      
      // Reset to show all benefits
      if (type == 'all') {
        state = state.copyWith(
          filteredBenefits: allBenefits,
          activeFilter: 'all',
        );
        return;
      }
      
      // Filter benefits by type
      final filtered = allBenefits.where((benefit) {
        return benefit.type.toString().toLowerCase().contains(type.toLowerCase());
      }).toList();
      
      state = state.copyWith(
        filteredBenefits: filtered,
        activeFilter: type,
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Filters benefits by partner
  void filterByPartner(String partner) {
    if (state.benefits.isEmpty) return;
    
    try {
      final allBenefits = state.benefits;
      
      // Reset to show all benefits
      if (partner == 'all') {
        state = state.copyWith(
          filteredBenefits: allBenefits,
          activeFilter: 'all',
        );
        return;
      }
      
      // Filter benefits by partner
      final filtered = allBenefits.where((benefit) {
        return benefit.partner.toLowerCase() == partner.toLowerCase();
      }).toList();
      
      state = state.copyWith(
        filteredBenefits: filtered,
        activeFilter: partner,
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Creates a new benefit
  Future<void> createBenefit(Benefit benefit) async {
    try {
      state = const BenefitState.loading();
      final newBenefit = await _repository.createBenefit(benefit);
      
      // Update the list with the new benefit
      final updatedBenefits = [...state.benefits, newBenefit];
      
      // Update partners list if needed
      final updatedPartners = [...state.partners];
      if (!updatedPartners.contains(newBenefit.partner)) {
        updatedPartners.add(newBenefit.partner);
      }
      
      state = BenefitState.success(
        benefits: updatedBenefits,
        filteredBenefits: state.activeFilter == 'all' ? 
            updatedBenefits : 
            state.filteredBenefits,
        partners: updatedPartners,
        selectedBenefit: newBenefit,
        message: 'Benefício criado com sucesso!',
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Updates an existing benefit
  Future<void> updateBenefit(Benefit benefit) async {
    try {
      state = const BenefitState.loading();
      final updatedBenefit = await _repository.updateBenefit(benefit);
      
      // Update the benefit in the list
      final updatedBenefits = state.benefits.map((b) {
        return b.id == benefit.id ? updatedBenefit : b;
      }).toList();
      
      // Update filters
      final updatedFiltered = state.activeFilter == 'all' ?
          updatedBenefits :
          updatedBenefits.where((b) {
            if (state.activeFilter == b.partner) {
              return true;
            }
            return b.type.toString().toLowerCase().contains(state.activeFilter.toLowerCase());
          }).toList();
      
      // Update partners list if needed
      final updatedPartners = [...state.partners];
      if (!updatedPartners.contains(updatedBenefit.partner)) {
        updatedPartners.add(updatedBenefit.partner);
      }
      
      state = BenefitState.success(
        benefits: updatedBenefits,
        filteredBenefits: updatedFiltered,
        partners: updatedPartners,
        selectedBenefit: updatedBenefit,
        activeFilter: state.activeFilter,
        message: 'Benefício atualizado com sucesso!',
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Deletes a benefit
  Future<void> deleteBenefit(String benefitId) async {
    try {
      state = const BenefitState.loading();
      await _repository.deleteBenefit(benefitId);
      
      // Remove the benefit from the lists
      final updatedBenefits = state.benefits
          .where((b) => b.id != benefitId)
          .toList();
      
      final updatedFiltered = state.filteredBenefits
          .where((b) => b.id != benefitId)
          .toList();
      
      // Recalculate partners
      final partnerSet = <String>{};
      for (var benefit in updatedBenefits) {
        if (benefit.partner.isNotEmpty) {
          partnerSet.add(benefit.partner);
        }
      }
      
      state = BenefitState.success(
        benefits: updatedBenefits,
        filteredBenefits: updatedFiltered,
        partners: partnerSet.toList(),
        activeFilter: state.activeFilter,
        message: 'Benefício excluído com sucesso!',
      );
    } catch (e) {
      state = BenefitState.error(message: _getErrorMessage(e));
    }
  }

  /// Resets all filters
  void resetFilters() {
    state = state.copyWith(
      filteredBenefits: state.benefits,
      activeFilter: 'all',
    );
  }
} 