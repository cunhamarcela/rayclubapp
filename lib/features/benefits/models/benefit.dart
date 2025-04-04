import 'package:freezed_annotation/freezed_annotation.dart';

part 'benefit.freezed.dart';
part 'benefit.g.dart';

/// Model representing a benefit or coupon
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
    String? imageUrl,
    
    /// URL do QR Code do benefício (opcional)
    String? qrCodeUrl,
    
    /// Data de expiração do benefício (opcional)
    DateTime? expiresAt,
    
    /// Empresa ou marca parceira que fornece o benefício
    required String partner,
    
    /// Termos e condições para uso do benefício
    String? terms,
    
    /// Tipo do benefício
    @Default(BenefitType.coupon) BenefitType type,
    
    /// URL de ação associada ao benefício
    String? actionUrl,
  }) = _Benefit;

  /// Cria um benefício a partir de JSON
  factory Benefit.fromJson(Map<String, dynamic> json) => _$BenefitFromJson(json);
  
  /// Cria um benefício vazio com valores padrão
  factory Benefit.empty() => const Benefit(
    id: '',
    title: '',
    description: '',
    partner: '',
  );
}

/// Types of benefits available
enum BenefitType {
  coupon,
  qrCode,
  link
} 