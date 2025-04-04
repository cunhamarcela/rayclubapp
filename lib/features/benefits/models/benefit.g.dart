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
      imageUrl: json['imageUrl'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      partner: json['partner'] as String,
      terms: json['terms'] as String?,
      type: $enumDecodeNullable(_$BenefitTypeEnumMap, json['type']) ??
          BenefitType.coupon,
      actionUrl: json['actionUrl'] as String?,
    );

Map<String, dynamic> _$$BenefitImplToJson(_$BenefitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'partner': instance.partner,
      'terms': instance.terms,
      'type': _$BenefitTypeEnumMap[instance.type]!,
      'actionUrl': instance.actionUrl,
    };

const _$BenefitTypeEnumMap = {
  BenefitType.coupon: 'coupon',
  BenefitType.qrCode: 'qrCode',
  BenefitType.link: 'link',
};
