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
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWords();
    _searchController.addListener(() {
      _filterWords();
    });
  }

  Future<void> _fetchWords() async {
    final words = await _dbHelper.getWords();
    setState(() {
      _words = words;
      _filteredWords = words;
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

  void _updateWord(Word word) async {
    final TextEditingController englishController =
        TextEditingController(text: word.english);
    final TextEditingController turkishController =
        TextEditingController(text: word.turkish);

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
              onPressed: () async {
                final updatedWord = Word(
                  id: word.id,
                  english: englishController.text,
                  turkish: turkishController.text,
                  image: word.image,
                );
                await _dbHelper.updateWord(updatedWord);
                _fetchWords();
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWord(int id) async {
    await _dbHelper.deleteWord(id);
    _fetchWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Words'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWords.length,
              itemBuilder: (context, index) {
                final word = _filteredWords[index];
                final imageBytes = base64Decode(word.image);

                return Card(
                  child: ListTile(
                    leading: word.image.isNotEmpty
                        ? Image.memory(imageBytes,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                    title: Text(word.english),
                    subtitle: Text(word.turkish),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
