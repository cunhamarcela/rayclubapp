// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FaqImpl _$$FaqImplFromJson(Map<String, dynamic> json) => _$FaqImpl(
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$FaqImplToJson(_$FaqImpl instance) => <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      if (instance.category case final value?) 'category': value,
    };
