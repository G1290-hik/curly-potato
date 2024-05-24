import 'package:flutter/material.dart';

import 'views/home.dart';
import 'new.dart';  // Assuming new.dart contains CustomTheme.lightTheme and CustomTheme.darkTheme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: _isDarkTheme ? CustomTheme.darkTheme : CustomTheme.lightTheme,
      home: MyHomePage(
        title: 'Todo',
        toggleTheme: _toggleTheme,
        isDarkTheme: _isDarkTheme,
      ),
    );
  }
}
