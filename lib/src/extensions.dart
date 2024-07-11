import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'json/sentences.dart';
import 'providers.dart';

/// Useful extensions.
extension FlutterTtsX on FlutterTts {
  /// Speak interrupted.
  Future<void> speakInterrupted(final String text) async {
    await stop();
    await speak(text);
  }
}

/// Useful extensions.
extension WidgetRefX on WidgetRef {
  /// Save [sentences].
  Future<void> saveSentences(final Sentences sentences) async {
    final preferences = await read(sharedPreferencesProvider.future);
    await preferences.setString(
      sentencesKey,
      jsonEncode(sentences),
    );
    invalidate(sentencesContextProvider);
  }
}
