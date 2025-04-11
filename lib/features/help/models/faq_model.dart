// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_model.freezed.dart';
part 'faq_model.g.dart';

/// Modelo de uma pergunta frequente
@freezed
class Faq with _$Faq {
  /// Factory para o modelo de FAQ
  const factory Faq({
    /// Pergunta
    required String question,
    
    /// Resposta
    required String answer,
    
    /// Categoria (opcional)
    String? category,
  }) = _Faq;
  
  /// Converter de JSON para objeto
  factory Faq.fromJson(Map<String, dynamic> json) => _$FaqFromJson(json);
} 