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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
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

  List<WordPair> favourites = [];

  void toggleFavouritism() {
    if (favourites.contains(currentRandomWord)) {
      favourites.remove(currentRandomWord);
    } else {
      favourites.add(currentRandomWord);
    }
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navigationIndex = 0;
  List<Widget> pages = [NameGeneratorPage(), FavouritesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(
                  icon: Icon(Icons.favorite), label: Text("Favorites"))
            ],
            selectedIndex: navigationIndex,
            extended: false,
            onDestinationSelected: (value) {
              setState(() {
                if (navigationIndex == 0) {
                  navigationIndex = 1;
                } else {
                  navigationIndex = 0;
                }
              });
            },
          )),
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: pages[navigationIndex],
          )),
        ],
      ),
    );
  }
}

class NameGeneratorPage extends StatelessWidget {
  const NameGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NiceAppState>();
    var randomWordPair = appState.currentRandomWord;

    IconData icon;
    if (appState.favourites.contains(randomWordPair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NameCard(randomWordPair: randomWordPair),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavouritism();
                  },
                  label: Text("Like"),
                  icon: Icon(icon),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      appState.getNextRandomWord();
                    },
                    child: Text("Next")),
              ],
            )
          ],
        ),
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
          randomWordPair.asPascalCase,
          style: style,
          semanticsLabel: "${randomWordPair.first} ${randomWordPair.second}",
        ),
      ),
    );
  }
}

class FavouritesPage extends StatelessWidget {
  FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NiceAppState>();
    return Column();
  }
}
