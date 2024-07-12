import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions.dart';
import '../json/sentence.dart';
import '../json/sentences.dart';
import '../providers.dart';

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
  /// The controller to use.
  late final TextEditingController controller;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final tts = ref.watch(flutterTtsProvider);
    final value = ref.watch(sentencesContextProvider);
    const fontSize = 24.0;
    return SimpleScaffold(
      title: 'Silence',
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
                                tts.speakInterrupted(sentence.text);
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
              TextField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.yellow,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  helperText: 'Enter text to speak and press enter.',
                  helperStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                onSubmitted: (final value) {
                  if (value.trim().isEmpty) {
                    return;
                  }
                  controller.text = '';
                  tts.speakInterrupted(value);
                  for (final sentence in sentences) {
                    if (sentence.text == value) {
                      sentence.count++;
                      ref.saveSentences(
                        Sentences(sentences),
                      );
                      return;
                    }
                  }
                  final sentence = Sentence(text: value, count: 1);
                  sentences.add(sentence);
                  ref.saveSentences(Sentences(sentences));
                },
                style: const TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
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
}
