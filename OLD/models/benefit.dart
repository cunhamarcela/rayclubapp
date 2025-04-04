import 'package:freezed_annotation/freezed_annotation.dart';

part 'benefit.freezed.dart';
part 'benefit.g.dart';

/// Model representing a benefit or coupon
@freezed
class Benefit with _$Benefit {
  const factory Benefit({
    required String id,
    required String title,
    required String description,
    required String partner,
    String? imageUrl,
    String? qrCodeUrl,
    DateTime? expiresAt,
    String? terms,
    @Default(BenefitType.coupon) BenefitType type,
    String? actionUrl,
  }) = _Benefit;

  factory Benefit.fromJson(Map<String, dynamic> json) => _$BenefitFromJson(json);
}

/// Types of benefits available
enum BenefitType {
  coupon,
  qrCode,
  link
} 