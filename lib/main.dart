import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Added key parameter

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Added 'const' here
      title: 'My Notes App',
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key); // Added key parameter

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  final List<Map<String, String>> _notes = []; // List to store notes as maps
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNote() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      setState(() {
        _notes.add({
          'title': _titleController.text,
          'content': _contentController.text,
        }); // Add note to the list
        _titleController.clear(); // Clear the title input field
        _contentController.clear(); // Clear the content input field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'), // Added 'const' here
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                // Added 'const' here
                labelText: 'Enter note title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                // Added 'const' here
                labelText: 'Enter note content',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote, // Add note when button is pressed
            child: const Text('Add Note'), // Added 'const' here
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length, // Display the number of notes
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index]['title']!), // Display note title
                  subtitle:
                      Text(_notes[index]['content']!), // Display note content
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
