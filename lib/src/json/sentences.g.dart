// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentences _$SentencesFromJson(Map<String, dynamic> json) => Sentences(
      (json['sentences'] as List<dynamic>)
          .map((e) => Sentence.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SentencesToJson(Sentences instance) => <String, dynamic>{
      'sentences': instance.sentences,
    };
