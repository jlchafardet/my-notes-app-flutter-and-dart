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
      print(
          '${note['title']} note was modified'); // Log when a note is modified
    } else {
      // Add new note
      setState(() {
        _notes.add(note); // Add note to the list
      });
      print('New note added: ${note['title']}'); // Log when a new note is added
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

  // Method to delete a note
  void _deleteNote(int index) {
    final deletedNoteTitle =
        _notes[index]['title']; // Get the title of the note being deleted
    setState(() {
      _notes.removeAt(index); // Remove the note at the specified index
    });
    print('$deletedNoteTitle was deleted'); // Log when a note is deleted
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
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red, // Background color for the delete button
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.white), // Set icon color to white
                    onPressed: () {
                      _deleteNote(index); // Call delete method on press
                    },
                  ),
                ),
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

  final String? title; // Title of the note (for editing)
  final String? content; // Content of the note (for editing)
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
            isEditing ? 'Edit Note' : 'Add Note'), // Change title based on mode
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title', // Label for the title field
              ),
              readOnly: false, // Allow editing of the title
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content', // Label for the content field
              ),
              readOnly: false, // Allow editing of the content
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
