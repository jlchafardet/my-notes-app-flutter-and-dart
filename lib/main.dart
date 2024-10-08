import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
        ),
        body: const Center(
          child: Text('Welcome to My Notes App!'),
        ),
      ),
    );
  }
}
