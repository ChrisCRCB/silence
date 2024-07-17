import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// A screen to select a new voice.
class VoicesScreen extends StatelessWidget {
  /// Create an instance.
  const VoicesScreen({
    required this.tts,
    super.key,
  });

  /// The tts to use.
  final FlutterTts tts;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final future = tts.getVoices;
    return Cancel(
      child: SimpleScaffold(
        title: 'Select Voice',
        body: SimpleFutureBuilder(
          future: future,
          done: (final context, final value) {
            final voices = value as List<dynamic>;
            if (voices.isEmpty) {
              return const Center(
                child: Text(
                  'There are no voices to show.',
                  style: TextStyle(fontSize: 20.0),
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (final context, final index) {
                if (index == 0) {
                  return ListTile(
                    autofocus: true,
                    title: const Text('Reset to default.'),
                    onTap: () async {
                      await tts.stop();
                      try {
                        await tts.clearVoice();
                        await tts.speak('Voice reset.');
                      } on MissingPluginException {
                        await tts.speak('Cannot reset voice.');
                      }
                    },
                  );
                }
                final voiceData = voices[index - 1] as Map<dynamic, dynamic>;
                final voice = <String, String>{};
                for (final MapEntry(key: key, value: value)
                    in voiceData.entries) {
                  if (value is String) {
                    voice[key.toString()] = value;
                  }
                }
                final voiceName = voice['name']!;
                return ListTile(
                  autofocus: index == 0,
                  title: Text(voiceName),
                  onTap: () async {
                    await tts.stop();
                    await tts.setVoice({'name': voiceName});
                    await tts.speak(voiceName);
                  },
                );
              },
              itemCount: voices.length + 1,
              shrinkWrap: true,
            );
          },
          loading: LoadingWidget.new,
          error: ErrorListView.withPositional,
        ),
      ),
    );
  }
}
