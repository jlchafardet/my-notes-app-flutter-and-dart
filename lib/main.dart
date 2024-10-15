// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'note_model.dart'; // Import your Note model
import 'note_form_screen.dart'; // Import your AddNote screen
//import 'notetype_model.dart'; // Import your NoteType model
import 'tag_model.dart'; // Import your Tag model
import 'custom_app_bar.dart'; // Import the CustomAppBar widget
import 'menu_drawer.dart'; // Import the MenuDrawer widget
import 'custom_footer.dart'; // Import the CustomFooter widget
import 'admin_state.dart'; // Import the AdminState

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
      home: NotesScreen(), // No need to pass isAdmin
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the CustomAppBar
      endDrawer: MenuDrawer(), // Use endDrawer to open from the right
      body: Builder(
        builder: (context) {
          return Column(
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
                        isExpanded:
                            true, // Make the dropdown take the full width
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
                  stream:
                      FirebaseFirestore.instance.collection('tags').snapshots(),
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No notes available'));
                    }

                    final notes = snapshot.data!.docs
                        .map((doc) => Note.fromMap(
                            doc.data() as Map<String, dynamic>, doc.id))
                        .toList();

                    return ListView.builder(
                      itemCount: _filterNotes(notes).length,
                      itemBuilder: (context, index) {
                        final note = _filterNotes(notes)[index];
                        return ListTile(
                          title: Text(note.title), // Only display the title
                          trailing: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors
                                  .red, // Red background for delete button
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.white), // White icon
                              onPressed: () {
                                print(
                                    "Delete button pressed for note ID: ${note.id}"); // Debugging line
                                if (note.id != null) {
                                  // Check if note.id is not null
                                  _confirmDelete(note
                                      .id!); // Use the non-null assertion operator
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error: Note ID is null')),
                                  );
                                }
                              },
                            ),
                          ),
                          onTap: () {
                            _editNote(note); // Edit note on tap
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Footer Bar
              CustomFooter(), // Use the CustomFooter
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteFormScreen(
                isEditing: false, // Ensure this is false for adding a new note
              ),
            ),
          );
        },
        child: Icon(Icons.add), // "+" icon
        backgroundColor: Colors.blue, // Set the background color
      ),
    );
  }

  List<Note> _filterNotes(List<Note> notes) {
    return notes.where((note) {
      final matchesType =
          selectedNoteType == 'All' || note.noteType == selectedNoteType;
      final matchesTags = activeTags.isEmpty ||
          note.tags.any((tag) => activeTags.contains(tag));
      return matchesType && matchesTags; // Both conditions must be true
    }).toList();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (activeTags.contains(tag)) {
        activeTags.remove(tag); // Remove tag if already selected
      } else {
        activeTags.add(tag); // Add tag if not selected
      }
    });
  }

  void _confirmDelete(String noteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // No
              child: Text('No Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Red background
                foregroundColor: Colors.white, // White text
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('notes')
                    .doc(noteId)
                    .delete()
                    .then((_) {
                  Navigator.pop(context); // Close the dialog
                }).catchError((error) {
                  // Handle any errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting note: $error')),
                  );
                });
              },
              child: Text('Yes Delete'),
            ),
          ],
        );
      },
    );
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
          selectedNoteType:
              note.noteType ?? 'Simple', // Provide a default value
        ),
      ),
    );

    if (updatedNote != null) {
      // Refresh the notes list after editing
      // No need to call _fetchNotes() since we are using StreamBuilder
    }
  }
}
