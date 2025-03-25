import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../models/benefit.dart';
import '../models/redeemed_benefit.dart';
import '../repositories/benefit_repository.dart';
import '../repositories/mock_benefit_repository.dart';
import 'benefit_state.dart';

/// Provider do repositório de benefícios
final benefitRepositoryProvider = Provider<BenefitRepository>((ref) {
  // TODO: Substituir por SupabaseBenefitRepository em produção
  return MockBenefitRepository();
});

/// Provider do ViewModel de benefícios
final benefitViewModelProvider = StateNotifierProvider<BenefitViewModel, BenefitState>((ref) {
  return BenefitViewModel(ref.watch(benefitRepositoryProvider));
});

/// ViewModel para gerenciar benefícios
class BenefitViewModel extends StateNotifier<BenefitState> {
  final BenefitRepository _repository;
  
  BenefitViewModel(this._repository) : super(const BenefitState());
  
  /// Carrega todos os benefícios disponíveis
  Future<void> loadBenefits() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final benefits = await _repository.getBenefits();
      final categories = await _repository.getBenefitCategories();
      
      // Se o repositório for MockBenefitRepository, obtém pontos do usuário
      int? userPoints;
      if (_repository is MockBenefitRepository) {
        userPoints = await (_repository as MockBenefitRepository).getUserPoints();
      }
      
      state = state.copyWith(
        benefits: benefits,
        categories: categories,
        userPoints: userPoints,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Carrega os benefícios resgatados pelo usuário
  Future<void> loadRedeemedBenefits() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final redeemedBenefits = await _repository.getRedeemedBenefits();
      
      state = state.copyWith(
        redeemedBenefits: redeemedBenefits,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Filtra benefícios por categoria
  Future<void> filterByCategory(String? category) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, selectedCategory: category);
      
      // Se categoria for nula, carrega todos os benefícios
      final benefits = category == null 
          ? await _repository.getBenefits()
          : await _repository.getBenefitsByCategory(category);
      
      state = state.copyWith(
        benefits: benefits,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Seleciona um benefício para visualização detalhada
  Future<void> selectBenefit(String benefitId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final benefit = await _repository.getBenefitById(benefitId);
      
      if (benefit == null) {
        throw StorageException(
          message: 'Benefício não encontrado',
          code: 'benefit_not_found',
        );
      }
      
      state = state.copyWith(
        selectedBenefit: benefit,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Seleciona um benefício resgatado para visualização
  Future<void> selectRedeemedBenefit(String redeemedBenefitId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final redeemedBenefit = await _repository.getRedeemedBenefitById(redeemedBenefitId);
      
      if (redeemedBenefit == null) {
        throw StorageException(
          message: 'Benefício resgatado não encontrado',
          code: 'redeemed_benefit_not_found',
        );
      }
      
      state = state.copyWith(
        selectedRedeemedBenefit: redeemedBenefit,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Resgata um benefício
  Future<RedeemedBenefit?> redeemBenefit(String benefitId) async {
    try {
      final benefit = await _repository.getBenefitById(benefitId);
      
      if (benefit == null) {
        throw StorageException(
          message: 'Benefício não encontrado',
          code: 'benefit_not_found',
        );
      }
      
      state = state.copyWith(
        isRedeeming: true,
        errorMessage: null,
        benefitBeingRedeemed: benefit,
      );
      
      // Verifica se tem pontos suficientes
      final hasEnough = await _repository.hasEnoughPoints(benefitId);
      if (!hasEnough) {
        throw ValidationException(
          message: 'Pontos insuficientes para resgatar este benefício',
          code: 'insufficient_points',
        );
      }
      
      final redeemedBenefit = await _repository.redeemBenefit(benefitId);
      
      // Atualiza pontos do usuário se estiver usando MockBenefitRepository
      int? userPoints;
      if (_repository is MockBenefitRepository) {
        userPoints = await (_repository as MockBenefitRepository).getUserPoints();
      }
      
      // Carrega benefícios resgatados novamente para atualizar a lista
      final redeemedBenefits = await _repository.getRedeemedBenefits();
      
      state = state.copyWith(
        isRedeeming: false,
        benefitBeingRedeemed: null,
        redeemedBenefits: redeemedBenefits,
        userPoints: userPoints,
        selectedRedeemedBenefit: redeemedBenefit,
      );
      
      return redeemedBenefit;
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(
        isRedeeming: false,
        benefitBeingRedeemed: null,
        errorMessage: errorMessage,
      );
      return null;
    }
  }
  
  /// Marca um benefício como utilizado
  Future<bool> markBenefitAsUsed(String redeemedBenefitId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final updatedBenefit = await _repository.markBenefitAsUsed(redeemedBenefitId);
      
      // Atualiza a lista de benefícios resgatados
      final redeemedBenefits = await _repository.getRedeemedBenefits();
      
      state = state.copyWith(
        redeemedBenefits: redeemedBenefits,
        selectedRedeemedBenefit: updatedBenefit,
        isLoading: false,
      );
      
      return true;
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }
  
  /// Cancela um benefício resgatado
  Future<bool> cancelRedeemedBenefit(String redeemedBenefitId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await _repository.cancelRedeemedBenefit(redeemedBenefitId);
      
      // Atualiza pontos do usuário se estiver usando MockBenefitRepository
      int? userPoints;
      if (_repository is MockBenefitRepository) {
        userPoints = await (_repository as MockBenefitRepository).getUserPoints();
      }
      
      // Atualiza a lista de benefícios resgatados
      final redeemedBenefits = await _repository.getRedeemedBenefits();
      
      state = state.copyWith(
        redeemedBenefits: redeemedBenefits,
        userPoints: userPoints,
        selectedRedeemedBenefit: null,
        isLoading: false,
      );
      
      return true;
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }
  
  /// Carrega benefícios em destaque
  Future<void> loadFeaturedBenefits() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final featuredBenefits = await _repository.getFeaturedBenefits();
      
      state = state.copyWith(
        benefits: featuredBenefits,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      final errorMessage = _handleError(e, stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
    }
  }
  
  /// Limpa o benefício selecionado
  void clearSelectedBenefit() {
    state = state.copyWith(selectedBenefit: null);
  }
  
  /// Limpa o benefício resgatado selecionado
  void clearSelectedRedeemedBenefit() {
    state = state.copyWith(selectedRedeemedBenefit: null);
  }
  
  /// Limpa mensagem de erro
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  
  /// Adiciona pontos ao usuário (apenas para testes com MockBenefitRepository)
  Future<void> addUserPoints(int points) async {
    if (_repository is MockBenefitRepository) {
      final userPoints = await (_repository as MockBenefitRepository).addUserPoints(points);
      state = state.copyWith(userPoints: userPoints);
    }
  }
  
  /// Trata erros de maneira unificada e retorna uma mensagem adequada para o usuário
  String _handleError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Error in BenefitViewModel: $error');
      print(stackTrace);
    }
    
    if (error is AppException) {
      return error.message;
    }
    
    return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
  }
} 