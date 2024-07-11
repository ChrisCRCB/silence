// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentence _$SentenceFromJson(Map<String, dynamic> json) => Sentence(
      text: json['text'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$SentenceToJson(Sentence instance) => <String, dynamic>{
      'text': instance.text,
      'count': instance.count,
    };
