// Project imports:
import '../models/faq_model.dart';

/// Interface para o repositório de ajuda
abstract class HelpRepository {
  /// Obtém a lista de FAQs
  Future<List<Faq>> getFaqs();
  
  /// Envia uma mensagem para o suporte
  Future<void> sendSupportMessage({
    required String name,
    required String email,
    required String message,
  });
} 