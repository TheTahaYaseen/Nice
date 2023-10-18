import 'dart:js';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(NiceApp());
}

class NiceApp extends StatelessWidget {
  const NiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NiceAppState(),
      child: MaterialApp(
        title: "Nice",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
        home: HomePage(),
      ),
    );
  }
}

class NiceAppState extends ChangeNotifier {
  var currentRandomWord = WordPair.random();

  void getNextRandomWord() {
    currentRandomWord = WordPair.random();
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NiceAppState>();
    var randomWordPair = appState.currentRandomWord;

    return Scaffold(
      body: Column(
        children: [
          Text("A Random Word Idea -"),
          NameCard(randomWordPair: randomWordPair),
          ElevatedButton(
              onPressed: () {
                appState.getNextRandomWord();
              },
              child: Text("Next"))
        ],
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
    required this.randomWordPair,
  });

  final WordPair randomWordPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          randomWordPair.asCamelCase,
          style: style,
        ),
      ),
    );
  }
}
