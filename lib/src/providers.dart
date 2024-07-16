import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'json/sentences.dart';

part 'providers.g.dart';

/// Provide the shared preferences.
@riverpod
Future<SharedPreferences> sharedPreferences(final SharedPreferencesRef ref) =>
    SharedPreferences.getInstance();

/// The key where sentences are stored.
const sentencesKey = 'silence_sentences';

/// Provide sentences.
@riverpod
Future<Sentences> sentencesContext(final SentencesContextRef ref) async {
  final preferences = await ref.read(sharedPreferencesProvider.future);
  final source = preferences.getString(sentencesKey);
  if (source == null) {
    // ignore: prefer_const_constructors
    return Sentences([]);
  }
  return Sentences.fromJson(jsonDecode(source));
}
