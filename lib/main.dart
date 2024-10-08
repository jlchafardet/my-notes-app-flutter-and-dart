// ============================================================================
// Author: José Luis Chafardet G.
// Email: jose.chafardet@icloud.com
// Github: https://github.com/jlchafardet
//
// File Name: main.dart
// Description: A simple notes application that allows users to add, view, and edit notes.
// Created: 2023-10-04
// Last Modified: 2023-10-05
// ============================================================================

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

  void _addOrEditNote(Map<String, String> note, [int? index]) {
    if (index != null) {
      // Update existing note
      setState(() {
        _notes[index] = note; // Update the note at the specified index
      });
    } else {
      // Add new note
      setState(() {
        _notes.add(note); // Add note to the list
      });
    }
  }

  void _editNote(int index) async {
    final existingNote = _notes[index];
    final updatedNote = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(
          title: existingNote['title']!,
          content: existingNote['content']!,
          isEditing: true, // Indicate that we are editing
        ),
      ),
    );
    if (updatedNote != null) {
      _addOrEditNote(updatedNote, index); // Update the note if not null
    }
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
                    _addOrEditNote(newNote); // Add the new note if not null
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
                onTap: () => _editNote(index), // Edit note on tap
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen(
      {Key? key, this.title, this.content, this.isEditing = false})
      : super(key: key);

  final String? title;
  final String? content;
  final bool isEditing; // Flag to indicate if we are editing

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController =
        TextEditingController(text: title);
    final TextEditingController _contentController =
        TextEditingController(text: content);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? 'View Note' : 'Add Note'), // Change title based on mode
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title', // Only show "Title" in view mode
              ),
              readOnly: isEditing, // Make it read-only if in edit mode
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content', // Only show "Content" in view mode
              ),
              readOnly: isEditing, // Make it read-only if in edit mode
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
              child: const Text('Save Note'), // Button text remains the same
            ),
          ],
        ),
      ),
    );
  }
}
