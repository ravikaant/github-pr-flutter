import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:github/components/chat.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _words = generateWordPairs().take(10).toList();
  final _bigFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word List'),
        actions: [
          IconButton(
            onPressed: _navigateToChatScreen,
            icon: const Icon(Icons.message_rounded),
            tooltip: 'Chat For Free',
          ),
          IconButton(
            onPressed: _displayFavourites,
            icon: const Icon(Icons.favorite_outline_rounded),
            tooltip: 'Favourite Words',
          ),
        ],
      ),
      body: _buildWordList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToChatScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ChatApp()));
  }

  void _displayFavourites() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final savedList = _saved.map((word) {
        return ListTile(
          title: Text(
            word.asPascalCase,
            style: _bigFont,
          ),
        );
      });
      final dividedList = savedList.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: savedList).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favourite Words'),
        ),
        body: ListView(
          children: dividedList,
        ),
      );
    }));
  }

  Widget _buildWordList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _words.length,
        itemBuilder: (context, i) {
          return Column(children: [
            _wordRow(_words[i], i),
            i == _words.length - 1
                ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _words.addAll(generateWordPairs().take(30));
                        });
                      },
                      child: const Text('Load More')),
                  const Divider()
                ])
                : const Divider()
          ]);
        });
  }

  Widget _wordRow(WordPair word, int index) {
    final alreadySaved = _saved.contains(word);
    return ListTile(
        title: Text(
          word.asPascalCase,
          style: _bigFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_outline,
          color: alreadySaved ? Colors.black : null,
        ),
        onTap: () => setState(() {
          alreadySaved ? _saved.remove(word) : _saved.add(word);
        }));
  }
}
