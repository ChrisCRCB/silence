import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../extensions.dart';
import '../json/sentence.dart';
import '../json/sentences.dart';
import '../providers.dart';
import 'voices_screen.dart';

/// The main screen for the application.
class MainScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const MainScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  MainScreenState createState() => MainScreenState();
}

/// State for [MainScreen].
class MainScreenState extends ConsumerState<MainScreen> {
  /// The form key to use.
  late final GlobalKey<FormState> formKey;

  /// The controller to use.
  late final TextEditingController controller;

  /// The TTS system to use.
  late final FlutterTts tts;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
    controller = TextEditingController();
    tts = FlutterTts();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    tts.stop();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(sentencesContextProvider);
    const fontSize = 24.0;
    return SimpleScaffold(
      title: 'Silence',
      actions: [
        ElevatedButton(
          onPressed: () => context.pushWidgetBuilder(
            (final _) => VoicesScreen(
              tts: tts,
            ),
          ),
          child: const Icon(
            Icons.speaker_group_outlined,
            semanticLabel: 'Select voice',
          ),
        ),
      ],
      body: value.when(
        data: (final sentencesObject) {
          final sentences = sentencesObject.sentences
            ..sort(
              (final a, final b) {
                if (a.count == b.count) {
                  return a.text.toLowerCase().compareTo(b.text.toLowerCase());
                }
                return a.count.compareTo(b.count);
              },
            );
          return Column(
            children: [
              Expanded(
                child: sentences.isEmpty
                    ? const Center(
                        child: Text(
                          'Type something first.',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (final context, final index) {
                          final sentence = sentences[index];
                          return CommonShortcuts(
                            deleteCallback: () {
                              sentences.remove(sentence);
                              ref.saveSentences(Sentences(sentences));
                            },
                            child: ListTile(
                              title: Text(
                                sentence.text,
                                style: const TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onLongPress: () {
                                sentences.remove(sentence);
                                ref.saveSentences(Sentences(sentences));
                              },
                              onTap: () {
                                sentence.count++;
                                speak(sentence.text);
                                ref.saveSentences(
                                  Sentences(sentences),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: sentences.length,
                      ),
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.yellow,
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    helperText: 'Enter text to speak and press enter.',
                    helperStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    suffix: IconButton(
                      onPressed: speakText,
                      icon: const Icon(
                        Icons.send_outlined,
                        semanticLabel: 'Send',
                      ),
                    ),
                  ),
                  onFieldSubmitted: (final _) => speakText(),
                  style: const TextStyle(
                    fontSize: fontSize,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
        error: ErrorListView.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }

  /// Speak interrupted.
  Future<void> speak(final String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  /// Speak text.
  Future<void> speakText() async {
    final text = controller.text;
    if (text.trim().isEmpty) {
      return;
    }
    controller.text = '';
    await speak(text);
    final sentences =
        (await ref.read(sentencesContextProvider.future)).sentences;
    for (final sentence in sentences) {
      if (sentence.text == text) {
        sentence.count++;
        await ref.saveSentences(
          Sentences(sentences),
        );
        return;
      }
    }
    final sentence = Sentence(text: text, count: 1);
    sentences.add(sentence);
    await ref.saveSentences(Sentences(sentences));
  }
}
