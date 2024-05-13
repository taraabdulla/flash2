import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../screens/flipcard_screen.dart';
import '../screens/questions.dart';

class FlashcardScreen extends StatefulWidget {
  final String deckName;
  final int deckId;

  static const routeName = '/flashcard';

  const FlashcardScreen(
      {super.key, required this.deckName, required this.deckId});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late List<Map<String, dynamic>> flashcards = [];

  @override
  void initState() {
    super.initState();
    _getFlashcardsFromDatabase(widget.deckId);
  }

  Future<void> _getFlashcardsFromDatabase(int deckId) async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'flashcard_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE flashcards(id INTEGER PRIMARY KEY AUTOINCREMENT, question TEXT, answer TEXT, deckId INTEGER)',
        );
      },
      version: 1,
    );

    final List<Map<String, dynamic>> flashcardsFromDb = await database.query(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
    );
    setState(() {
      flashcards = flashcardsFromDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionScreen(
                    deckId: widget.deckId,
                  ),
                ),
              ).then((_) {
                _getFlashcardsFromDatabase(widget.deckId);
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlipCardScreen(
                    flashcards: flashcards,
                    currentIndex: index,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          flashcards[index]['question'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Divider(
                      indent: 17,
                      endIndent: 17,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          flashcards[index]['answer'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
