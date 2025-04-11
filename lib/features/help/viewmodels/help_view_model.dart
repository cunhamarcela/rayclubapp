// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/faq_model.dart';
import '../models/help_state.dart';
import '../repositories/help_repository.dart';
import '../repositories/help_repository_impl.dart';

/// Provider para o repositório de ajuda
final helpRepositoryProvider = Provider<HelpRepository>((ref) {
  final supabase = Supabase.instance.client;
  return HelpRepositoryImpl(supabase);
});

/// Provider para o ViewModel de ajuda
final helpViewModelProvider = StateNotifierProvider<HelpViewModel, HelpState>((ref) {
  final repository = ref.watch(helpRepositoryProvider);
  return HelpViewModel(repository);
});

/// ViewModel para gerenciar a tela de ajuda
class HelpViewModel extends StateNotifier<HelpState> {
  final HelpRepository _repository;
  
  /// Cria uma instância do ViewModel
  HelpViewModel(this._repository) : super(const HelpState()) {
    loadFaqs();
  }
  
  /// Carrega a lista de FAQs
  Future<void> loadFaqs() async {
    state = state.copyWith(isLoading: true);
    try {
      final faqs = await _repository.getFaqs();
      state = state.copyWith(faqs: faqs, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao carregar FAQs: $e',
        isLoading: false,
      );
    }
  }
  
  /// Atualiza o índice da FAQ expandida
  void setExpandedFaqIndex(int index) {
    // Se clicar na mesma FAQ que já está expandida, colapsa ela
    final newIndex = state.expandedFaqIndex == index ? -1 : index;
    state = state.copyWith(expandedFaqIndex: newIndex);
  }
  
  /// Envia uma mensagem de suporte
  Future<bool> sendSupportMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.sendSupportMessage(
        name: name,
        email: email,
        message: message,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao enviar mensagem: $e',
        isLoading: false,
      );
      return false;
    }
  }
  
  /// Limpa mensagens de erro
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
} 