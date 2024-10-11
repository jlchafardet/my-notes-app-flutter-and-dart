import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'note_type_model.dart'; // Import the NoteType model

class AddNoteTypeScreen extends StatefulWidget {
  final NoteType? noteType; // Optional NoteType for editing
  final bool isEditing; // Flag to indicate if we are editing

  const AddNoteTypeScreen({Key? key, this.noteType, this.isEditing = false})
      : super(key: key);

  @override
  _AddNoteTypeScreenState createState() => _AddNoteTypeScreenState();
}

class _AddNoteTypeScreenState extends State<AddNoteTypeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.noteType != null) {
      _nameController.text = widget.noteType!.name; // Set the initial name
      _descriptionController.text =
          widget.noteType!.description ?? ''; // Set the initial description
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note Type' : 'Add Note Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Note Type Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle form submission
                if (_nameController.text.isNotEmpty) {
                  // Create a new note type object
                  final newNoteType = {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'updatedAt': DateTime.now(), // Update timestamp
                  };

                  if (widget.isEditing && widget.noteType != null) {
                    // Update the note type in Firestore
                    await FirebaseFirestore.instance
                        .collection('noteTypes')
                        .doc(widget
                            .noteType!.id) // Use the document ID to update
                        .update(newNoteType);
                  } else {
                    // Save the new note type to Firestore
                    await FirebaseFirestore.instance
                        .collection('noteTypes')
                        .add(newNoteType);
                  }

                  Navigator.pop(context); // Return to the previous screen
                }
              },
              child: Text(widget.isEditing ? 'Save Changes' : 'Save Note Type'),
            ),
            // Removed the delete button
          ],
        ),
      ),
    );
  }
}
