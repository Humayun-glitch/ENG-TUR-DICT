// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bilingualbridge/database_helper.dart';
import 'package:bilingualbridge/models/word.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();
  String _imageBase64 = '';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _addWord() async {
    final id = DateTime.now().millisecondsSinceEpoch; // Generate a unique ID
    final word = Word(
      id: id,
      english: _englishController.text,
      turkish: _turkishController.text,
      image: _imageBase64,
    );
    await _dbHelper.insertWord(word.toMap());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _englishController,
              decoration: const InputDecoration(labelText: 'English'),
            ),
            TextField(
              controller: _turkishController,
              decoration: const InputDecoration(labelText: 'Turkish'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            _imageBase64.isEmpty
                ? const Text('No image selected.')
                : Image.memory(base64Decode(_imageBase64), height: 100),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWord,
              child: const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}
