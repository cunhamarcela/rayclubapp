import 'package:freezed_annotation/freezed_annotation.dart';

part 'benefit.freezed.dart';
part 'benefit.g.dart';

/// Representa um benefício disponível para os usuários do app.
@freezed
class Benefit with _$Benefit {
  const factory Benefit({
    /// Identificador único do benefício
    required String id,
    
    /// Título do benefício
    required String title,
    
    /// Descrição detalhada do benefício
    required String description,
    
    /// URL da imagem que representa o benefício
    required String imageUrl,
    
    /// Quantidade de pontos necessários para resgatar o benefício
    required int pointsRequired,
    
    /// Data de expiração do benefício (opcional)
    DateTime? expirationDate,
    
    /// Código promocional do benefício (opcional)
    String? promoCode,
    
    /// Empresa ou marca parceira que fornece o benefício
    String? partner,
    
    /// Categoria do benefício para agrupamento
    @Default("Outros") String category,
    
    /// Termos e condições para uso do benefício
    String? termsAndConditions,
    
    /// Indica se o benefício foi destacado para promoção especial
    @Default(false) bool isFeatured,
    
    /// Quantidade disponível (null para ilimitado)
    int? availableQuantity,
    
    /// Link externo para redireção ao resgatar o benefício
    String? externalUrl,
  }) = _Benefit;

  /// Cria um benefício a partir de JSON
  factory Benefit.fromJson(Map<String, dynamic> json) => _$BenefitFromJson(json);
  
  /// Cria um benefício vazio com valores padrão
  factory Benefit.empty() => const Benefit(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    pointsRequired: 0,
  );
} 