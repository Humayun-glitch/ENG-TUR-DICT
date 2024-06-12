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
    final word = Word(
      id: 0, // You can generate a unique ID or use auto-increment
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
        title:
            const Text('Add Word', style: TextStyle(fontFamily: 'Montserrat')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText: 'English',
                labelStyle: const TextStyle(
                    fontFamily: 'Montserrat', color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _turkishController,
              decoration: InputDecoration(
                labelText: 'Turkish',
                labelStyle: const TextStyle(
                    fontFamily: 'Montserrat', color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            _imageBase64.isEmpty
                ? const Text('No image selected.',
                    style: TextStyle(fontFamily: 'Montserrat'))
                : Image.memory(base64Decode(_imageBase64), height: 100),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWord,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}
