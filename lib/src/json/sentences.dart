import 'package:json_annotation/json_annotation.dart';

import 'sentence.dart';

part 'sentences.g.dart';

/// A class to hold a list of [sentences].
@JsonSerializable()
class Sentences {
  /// Create an instance.
  const Sentences(this.sentences);

  /// Create an instance from a JSON object.
  factory Sentences.fromJson(final Map<String, dynamic> json) =>
      _$SentencesFromJson(json);

  /// The sentences which have been used.
  final List<Sentence> sentences;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$SentencesToJson(this);
}
