import 'package:json_annotation/json_annotation.dart';

part 'sentence.g.dart';

/// A sentence which can be spoken.
@JsonSerializable()
class Sentence {
  /// Create an instance.
  Sentence({
    required this.text,
    required this.count,
  });

  /// Create an instance from a JSON object.
  factory Sentence.fromJson(final Map<String, dynamic> json) =>
      _$SentenceFromJson(json);

  /// The text to be spoken.
  final String text;

  /// The number of times this sentence has been spoken.
  int count;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$SentenceToJson(this);
}
