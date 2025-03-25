// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BenefitImpl _$$BenefitImplFromJson(Map<String, dynamic> json) =>
    _$BenefitImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      pointsRequired: (json['pointsRequired'] as num).toInt(),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      promoCode: json['promoCode'] as String?,
      partner: json['partner'] as String?,
      category: json['category'] as String? ?? "Outros",
      termsAndConditions: json['termsAndConditions'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      availableQuantity: (json['availableQuantity'] as num?)?.toInt(),
      externalUrl: json['externalUrl'] as String?,
    );

Map<String, dynamic> _$$BenefitImplToJson(_$BenefitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'pointsRequired': instance.pointsRequired,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'promoCode': instance.promoCode,
      'partner': instance.partner,
      'category': instance.category,
      'termsAndConditions': instance.termsAndConditions,
      'isFeatured': instance.isFeatured,
      'availableQuantity': instance.availableQuantity,
      'externalUrl': instance.externalUrl,
    };
