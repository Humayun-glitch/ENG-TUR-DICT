// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bilingualbridge/screens/home_screen.dart';
import 'package:bilingualbridge/screens/add_word_screen.dart';
import 'package:bilingualbridge/screens/view_words_screen.dart';
import 'package:bilingualbridge/screens/set_password_screen.dart';
import 'package:bilingualbridge/screens/login_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the platform is not mobile
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Initialize databaseFactory for non-mobile platforms
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English-Turkish Dictionary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 152, 58),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          // ignore: deprecated_member_use
          headline1: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          headline3: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 18, color: Colors.black87),
          bodyText2: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SetPasswordScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const AddWordScreen(),
        '/view': (context) => ViewWordsScreen(),
      },
    );
  }
}
