// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'faq_model.dart';

part 'help_state.freezed.dart';

/// Estado para a tela de ajuda
@freezed
class HelpState with _$HelpState {
  /// Factory para o estado da tela de ajuda
  const factory HelpState({
    /// Lista de perguntas frequentes
    @Default([]) List<Faq> faqs,
    
    /// Índice da FAQ expandida, -1 se nenhuma estiver expandida
    @Default(-1) int expandedFaqIndex,
    
    /// Indica se está carregando dados
    @Default(false) bool isLoading,
    
    /// Mensagem de erro, se houver
    String? errorMessage,
  }) = _HelpState;
} 