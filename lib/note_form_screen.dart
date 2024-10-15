import 'package:flutter/material.dart';
import 'note_model.dart'; // Import the Note model
import 'notetype_model.dart'; // Import the NoteType model
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'custom_app_bar.dart'; // Import the CustomAppBar
import 'custom_footer.dart'; // Import the CustomFooter
import 'menu_drawer.dart'; // Import the MenuDrawer

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({
    super.key,
    this.title,
    this.content,
    this.id,
    this.isEditing = false,
    this.selectedNoteType, // Keep this for editing
    this.tags, // Add this parameter to pass tags when editing
  });

  final String? title; // Title of the note (for editing)
  final String? content; // Content of the note (for editing)
  final String? id; // ID of the note (for editing)
  final bool isEditing; // Flag to indicate if we are editing
  final String? selectedNoteType; // Keep this for editing
  final List<String>? tags; // Add this to hold tags for editing

  @override
  NoteFormScreenState createState() => NoteFormScreenState();
}

class NoteFormScreenState extends State<NoteFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? selectedNoteType; // Variable to store the selected note type
  List<NoteType> noteTypes = []; // List to hold note types
  List<String> selectedTags = []; // State variable for selected tags

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _contentController.text = widget.content ?? '';

    if (!widget.isEditing) {
      _fetchNoteTypes(); // Fetch note types if adding a new note
    } else {
      // If editing, set the selected note type based on the note being edited
      selectedNoteType =
          widget.selectedNoteType; // Use the passed selectedNoteType
      selectedTags =
          widget.tags ?? []; // Initialize selectedTags with the passed tags

      // Debugging: Print the selected tags
      print("Selected Tags: $selectedTags");
    }
  }

  void _fetchNoteTypes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('noteTypes').get();
    setState(() {
      noteTypes = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Ensure that the name is not null
            if (data['name'] != null) {
              return NoteType.fromMap(data);
            } else {
              return null; // Return null if name is not valid
            }
          })
          .where((type) => type != null)
          .cast<NoteType>()
          .toList(); // Filter out nulls
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the CustomAppBar
      endDrawer: MenuDrawer(), // Use the MenuDrawer as an end drawer
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            // Heading for Add/Edit Note
            Center(
              // Center the heading
              child: Text(
                widget.isEditing ? 'Edit Note' : 'Add Note',
                style: TextStyle(
                  fontSize: 24, // Set font size for the heading
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
            ),
            SizedBox(height: 16), // Add some space between heading and dropdown
            // Dropdown for selecting note type or display note type name
            widget.isEditing
                ? Center(
                    child: Text(
                      selectedNoteType ?? 'No Type Selected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : DropdownButton<String>(
                    value: selectedNoteType,
                    hint: const Text('Select Note Type'),
                    isExpanded: true, // Make the dropdown full width
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNoteType =
                            newValue; // Update the selected note type
                      });
                    },
                    items: noteTypes
                        .map<DropdownMenuItem<String>>((NoteType type) {
                      return DropdownMenuItem<String>(
                        value: type.name,
                        child: Text(type.name),
                      );
                    }).toList(),
                  ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20), // Add top padding to the Save Note button

            // Tags section
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tags').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle errors
                }

                // Extract tags from the snapshot
                final tags =
                    snapshot.data!.docs.map((doc) => doc['name']).toList();

                return Wrap(
                  children: tags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag); // Add tag
                          } else {
                            selectedTags.remove(tag); // Remove tag
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),

            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  // Create a new note object
                  final newNote = Note(
                    title: _titleController.text,
                    content: _contentController.text,
                    noteType: selectedNoteType ??
                        'Normal', // Use selectedNoteType or default to 'Normal'
                    id: widget.id, // Pass the ID if editing
                    tags: selectedTags, // Add selected tags to the note
                  );

                  if (widget.isEditing && widget.id != null) {
                    // Update the note in Firestore
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(widget.id) // Use the document ID to update
                        .update(newNote.toMap());
                  } else {
                    // Save the note to Firestore
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .add(newNote.toMap());
                  }

                  // Check if the widget is still mounted before using context
                  if (mounted) {
                    Navigator.pop(context, newNote); // Return the new note
                  }
                }
              },
              child: Text(widget.isEditing
                  ? 'Save Note'
                  : 'Add Note'), // Change button text
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(), // Use the CustomFooter
    );
  }
}
