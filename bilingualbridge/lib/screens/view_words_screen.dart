// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_final_fields, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bilingualbridge/database_helper.dart';
import 'package:bilingualbridge/models/word.dart';

class ViewWordsScreen extends StatefulWidget {
  @override
  _ViewWordsScreenState createState() => _ViewWordsScreenState();
}

class _ViewWordsScreenState extends State<ViewWordsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWords();
    _searchController.addListener(_filterWords);
  }

  Future<void> _fetchWords() async {
    final wordsList = await _dbHelper.getWords();
    setState(() {
      _words = wordsList.map((wordMap) => Word.fromMap(wordMap)).toList();
      _filteredWords = _words;
    });
  }

  void _filterWords() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWords = _words.where((word) {
        return word.english.toLowerCase().contains(query) ||
            word.turkish.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _deleteWord(int id) async {
    await _dbHelper.deleteWord(id);
    _fetchWords();
  }

  Future<void> _updateWord(Word word) async {
    // Implement the update functionality (e.g., show a dialog to edit the word)
    final englishController = TextEditingController(text: word.english);
    final turkishController = TextEditingController(text: word.turkish);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: const InputDecoration(labelText: 'English'),
              ),
              TextField(
                controller: turkishController,
                decoration: const InputDecoration(labelText: 'Turkish'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedWord = Word(
                  id: word.id,
                  english: englishController.text,
                  turkish: turkishController.text,
                  image: word.image,
                );
                await _dbHelper.updateWord(updatedWord.toMap());
                Navigator.pop(context);
                _fetchWords();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Words'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredWords.length,
                itemBuilder: (context, index) {
                  final word = _filteredWords[index];
                  return ListTile(
                    title: Text(word.english,
                        style: const TextStyle(fontFamily: 'Montserrat')),
                    subtitle: Text(word.turkish,
                        style: const TextStyle(fontFamily: 'Montserrat')),
                    leading: word.image.isNotEmpty
                        ? Image.memory(base64Decode(word.image))
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateWord(word),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteWord(word.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
