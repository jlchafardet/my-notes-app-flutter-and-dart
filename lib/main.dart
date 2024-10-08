import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Notes App',
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  // Initial hard-coded notes
  final List<Map<String, String>> _notes = [
    {
      'title': 'First Note',
      'content': 'This is the content of the first note.'
    },
    {
      'title': 'Second Note',
      'content': 'This is the content of the second note.'
    },
  ];

  void _addNote(Map<String, String> note) {
    setState(() {
      _notes.add(note); // Add note to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.blue, // Background color for the button
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.add,
                    color: Colors.white), // Set icon color to white
                onPressed: () async {
                  // Navigate to AddNoteScreen and wait for the result
                  final newNote = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNoteScreen()),
                  );
                  if (newNote != null) {
                    _addNote(newNote); // Add the new note if not null
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Set width to 90%
          child: ListView.builder(
            itemCount: _notes.length, // Display the number of notes
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_notes[index]['title']!), // Display note title
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter note title',
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Enter note content',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  // Create a new note map
                  final newNote = {
                    'title': _titleController.text,
                    'content': _contentController.text,
                  };
                  Navigator.pop(context, newNote); // Return the new note
                }
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
