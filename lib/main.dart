// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_model.dart'; // Import your Note model
import 'note_form_screen.dart'; // Import your AddNote screen
import 'notetype_model.dart'; // Import your NoteType model
import 'tag_model.dart'; // Import your Tag model
import 'custom_app_bar.dart'; // Import the CustomAppBar widget
import 'menu_drawer.dart'; // Import the MenuDrawer widget
import 'custom_footer.dart'; // Import the CustomFooter widget

// Define FirebaseOptions
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyD_TUt6VkF3X8Da0mW_OhXieD8YhoCktkY",
  authDomain: "mynotesapp-jlch-flutter.firebaseapp.com",
  projectId: "mynotesapp-jlch-flutter",
  storageBucket: "mynotesapp-jlch-flutter.appspot.com",
  messagingSenderId: "795559777376",
  appId: "1:795559777376:web:279e3fd30bfb16ed3e5f05",
  measurementId: "G-GG546T0NWW",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String selectedNoteType = 'All'; // Default value
  List<String> activeTags = [];
  bool isAdmin = true; // Set to true to simulate admin access
  List<Note> notes = []; // List to hold notes

  @override
  void initState() {
    super.initState();
    _fetchNotes(); // Fetch notes when the screen is initialized
  }

  void _fetchNotes() async {
    // Fetch notes from Firestore
    final snapshot = await FirebaseFirestore.instance.collection('notes').get();
    setState(() {
      notes = snapshot.docs
          .map(
              (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList(); // Pass doc.id
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (activeTags.contains(tag)) {
        activeTags.remove(tag); // Remove tag to de-filter
      } else {
        activeTags.add(tag); // Add tag to filter
      }
    });
  }

  List<Note> _filterNotes() {
    return notes.where((note) {
      final matchesType =
          selectedNoteType == 'All' || note.noteType == selectedNoteType;
      final matchesTags = activeTags.isEmpty ||
          note.tags.any((tag) => activeTags.contains(tag));
      return matchesType && matchesTags; // Both conditions must be true
    }).toList();
  }

  void _confirmDelete(String? noteId) {
    if (noteId != null) {
      // Ensure noteId is not null
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Delete the note
                  FirebaseFirestore.instance
                      .collection('notes')
                      .doc(noteId)
                      .delete()
                      .then((_) {
                    Navigator.pop(context); // Close the dialog
                    _fetchNotes(); // Refresh the notes list
                  }).catchError((error) {
                    // Handle any errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting note: $error')),
                    );
                  });
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context), // Close the dialog
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  void _editNote(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormScreen(
          id: note.id, // Use id instead of noteId
          title: note.title,
          content: note.content,
          isEditing: true,
          selectedNoteType: note.noteType,
          noteTypes: [], // Ensure this is passed correctly
        ),
      ),
    );

    if (updatedNote != null) {
      // Refresh the notes list after editing
      _fetchNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the CustomAppBar
      drawer: MenuDrawer(), // Use the MenuDrawer
      body: Column(
        children: [
          // Type of Notes Filter
          Container(
            padding: EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('noteTypes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No note types available'));
                }

                final noteTypes = snapshot.data!.docs.map((doc) {
                  return doc['name']
                      as String; // Ensure this is a non-nullable String
                }).toList();

                return SizedBox(
                  width: 200, // Set a specific width for the dropdown
                  child: DropdownButton<String>(
                    value: selectedNoteType,
                    hint: Text('Select Note Type'),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedNoteType =
                              newValue; // Update the selected note type
                        });
                      }
                    },
                    items: ['All', ...noteTypes]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          // Tag Filter
          Container(
            padding: EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tags').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No tags available'));
                }

                final tags = snapshot.data!.docs.map((doc) {
                  return Tag.fromMap(doc.data() as Map<String, dynamic>)
                      .name; // Extract tag names
                }).toList();

                return Wrap(
                  spacing: 8.0,
                  children: tags.map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: activeTags.contains(tag),
                      onSelected: (isSelected) {
                        _toggleTag(tag); // Toggle tag selection
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // Notes Listing
          Expanded(
            child: ListView.builder(
              itemCount: _filterNotes().length,
              itemBuilder: (context, index) {
                final note = _filterNotes()[index];
                return ListTile(
                  title: Text(note.title), // Only display the title
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      print(
                          "Delete button pressed for note ID: ${note.id}"); // Debugging line
                      _confirmDelete(note.id); // Confirm deletion
                    },
                  ),
                  onTap: () {
                    _editNote(note); // Edit note on tap
                  },
                );
              },
            ),
          ),
          // Footer Bar
          CustomFooter(), // Use the CustomFooter
        ],
      ),
    );
  }
}
