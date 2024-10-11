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
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'note_model.dart'; // Import the Note model
import 'add_note_type_screen.dart'; // Import the AddNoteTypeScreen
import 'note_type_model.dart'; // Import the NoteType model
import 'add_note_screen.dart'; // Import the AddNoteScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD_TUt6VkF3X8Da0mW_OhXieD8YhoCktkY",
      authDomain: "mynotesapp-jlch-flutter.firebaseapp.com",
      projectId: "mynotesapp-jlch-flutter",
      storageBucket: "mynotesapp-jlch-flutter.appspot.com",
      messagingSenderId: "795559777376",
      appId: "1:795559777376:web:279e3fd30bfb16ed3e5f05",
      measurementId: "G-GG546T0NWW",
    ),
  );
  await FirebaseFirestore.instance
      .enablePersistence(); // Enable offline persistence
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
  final List<Note> _notes = []; // Initialize with an empty list
  bool isAdmin = true; // Set to true to simulate admin access
  List<String> noteTypes = [
    'Normal',
    'To-Do',
    'Shopping List'
  ]; // Example note types
  List<NoteType> _noteTypes = []; // List to store fetched note types
  String selectedNoteType = 'All'; // Default to show all notes

  @override
  void initState() {
    super.initState();
    _fetchNotes(); // Fetch notes from Firestore when the screen is initialized
    _fetchNoteTypes(); // Fetch note types from Firestore
  }

  // Method to fetch notes from Firestore
  void _fetchNotes() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('notes').get();
      final notes = snapshot.docs.map((doc) {
        return Note.fromMap(
            doc.data()..['id'] = doc.id); // Include the document ID
      }).toList();

      setState(() {
        _notes.clear(); // Clear the existing notes
        _notes.addAll(notes); // Add the fetched notes to the list
      });
    } catch (e) {
      print('Error fetching notes: $e'); // Log any errors
    }
  }

  void _addOrEditNote(Note note, [int? index]) {
    if (index != null) {
      // Update existing note
      setState(() {
        _notes[index] = note; // Update the note at the specified index
      });
      print('${note.title} note was modified'); // Log when a note is modified
    } else {
      // Add new note
      setState(() {
        _notes.add(note); // Add note to the list
      });
      print('New note added: ${note.title}'); // Log when a new note is added
    }
  }

  void _editNote(int index) async {
    final existingNote = _notes[index];
    final updatedNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(
          title: existingNote.title,
          content: existingNote.content,
          id: existingNote.id, // Pass the ID for editing
          isEditing: true, // Indicate that we are editing
          selectedNoteType:
              existingNote.noteType, // Pass the existing note type
          noteTypes: _noteTypes, // Pass the fetched note types
        ),
      ),
    );
    if (updatedNote != null) {
      _addOrEditNote(updatedNote, index); // Update the note if not null
    }
  }

  void _deleteNote(int index) async {
    final deletedNoteId =
        _notes[index].id; // Get the ID of the note being deleted
    final deletedNoteTitle =
        _notes[index].title; // Get the title of the note being deleted
    setState(() {
      _notes.removeAt(index); // Remove the note at the specified index
    });
    print('$deletedNoteTitle was deleted'); // Log when a note is deleted

    // Delete the note from Firestore
    if (deletedNoteId != null) {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(deletedNoteId)
          .delete();
    }
  }

  void _showAdminOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height: MediaQuery.of(context).size.height *
                0.5, // 50% of screen height
            child: Column(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Manage Note Types',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                // List of Note Types
                Expanded(
                  child: ListView.builder(
                    itemCount: _noteTypes
                        .length, // Assuming _noteTypes is a list of your note types
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _noteTypes[index]
                                    .name, // Display note type name
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .red, // Set the background color to red
                                shape: BoxShape.circle, // Make it circular
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white), // Trash icon
                                onPressed: () async {
                                  // Confirm deletion
                                  bool? confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                            'Are you sure you want to delete this note type?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false), // No
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(true), // Yes
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    // Delete the note type from Firestore
                                    await FirebaseFirestore.instance
                                        .collection('noteTypes')
                                        .doc(_noteTypes[index]
                                            .id) // Use the document ID to delete
                                        .delete();

                                    // Update the local list
                                    setState(() {
                                      _noteTypes.removeAt(
                                          index); // Remove from the list
                                    });
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddNoteTypeScreen(),
                          ),
                        ); // Navigate to AddNoteTypeScreen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            0xFF65B6FC), // Set to the same color as the add button
                      ),
                      child: const Text(
                        'Add New Note Type',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold), // White bold text
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // Close the dialog
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Set to orange
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold), // White bold text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _fetchNoteTypes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('noteTypes')
          .get(); // Ensure this matches the Firestore collection name
      final noteTypes = snapshot.docs.map((doc) {
        return NoteType.fromMap(
            doc.data()..['id'] = doc.id); // Include the document ID
      }).toList();

      setState(() {
        _noteTypes = noteTypes; // Store the fetched note types
      });

      // Debug output to confirm note types are fetched
      print(
          'Fetched note types: ${_noteTypes.map((type) => type.name).toList()}');
    } catch (e) {
      print('Error fetching note types: $e'); // Log any errors
    }
  }

  void _editNoteType() async {
    // Assuming you have a way to select which note type to edit
    final selectedNoteType =
        await _selectNoteType(); // Implement this method to select a note type
    if (selectedNoteType != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddNoteTypeScreen(noteType: selectedNoteType, isEditing: true),
        ),
      );
      _fetchNoteTypes(); // Refresh the note types after editing
    }
  }

  // Add this method to your NotesScreenState class
  Future<NoteType?> _selectNoteType() async {
    // Create a list of note type names for selection
    List<String> noteTypeNames = _noteTypes.map((type) => type.name).toList();

    // Show a dialog to select a note type
    return showDialog<NoteType>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Note Type to Edit'),
          content: SingleChildScrollView(
            child: ListBody(
              children: noteTypeNames.map((String noteTypeName) {
                return ListTile(
                  title: Text(noteTypeName),
                  onTap: () {
                    // Find the NoteType object by name
                    NoteType selectedType = _noteTypes
                        .firstWhere((type) => type.name == noteTypeName);
                    Navigator.of(context)
                        .pop(selectedType); // Return the selected note type
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without selection
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a filtered list based on the selected note type
    List<Note> filteredNotes = selectedNoteType == 'All'
        ? _notes
        : _notes.where((note) => note.noteType == selectedNoteType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          if (isAdmin) // Only show admin options if isAdmin is true
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showAdminOptions, // Show admin options
            ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown for selecting note type
          DropdownButton<String>(
            value: selectedNoteType,
            onChanged: (String? newValue) {
              setState(() {
                selectedNoteType = newValue!;
              });
            },
            items: ['All', ..._noteTypes.map((type) => type.name)]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: Container(
              width:
                  MediaQuery.of(context).size.width * 0.9, // Set width to 90%
              child: ListView.builder(
                itemCount: filteredNotes.length, // Use filtered notes count
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(filteredNotes[index].title), // Display note title
                    onTap: () => _editNote(index), // Edit note on tap
                    trailing: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors
                            .red, // Background color for the delete button
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddNoteScreen to add a new note
          final newNote = await Navigator.push<Note>(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(
                noteTypes: _noteTypes, // Pass the fetched note types
              ),
            ),
          );
          if (newNote != null) {
            _addOrEditNote(newNote); // Add the new note if not null
          }
        },
        child: const Icon(Icons.add), // Icon for the add button
        backgroundColor:
            const Color(0xFF65B6FC), // Set the background color to light blue
      ),
    );
  }
}
