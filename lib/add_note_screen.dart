import 'package:flutter/material.dart';
import 'note_model.dart'; // Import the Note model
import 'note_type_model.dart'; // Import the NoteType model
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    this.title,
    this.content,
    this.id,
    this.isEditing = false,
    this.selectedNoteType,
    required this.noteTypes, // Add this line
  });

  final String? title; // Title of the note (for editing)
  final String? content; // Content of the note (for editing)
  final String? id; // ID of the note (for editing)
  final bool isEditing; // Flag to indicate if we are editing
  final String? selectedNoteType; // Selected note type
  final List<NoteType> noteTypes; // List of note types

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? selectedNoteType; // Variable to store the selected note type

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _contentController.text = widget.content ?? '';
    selectedNoteType = widget.selectedNoteType; // Set the selected note type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            // Dropdown for selecting note type
            DropdownButton<String>(
              value: selectedNoteType,
              hint: const Text('Select Note Type'),
              onChanged: widget.isEditing
                  ? null
                  : (String? newValue) {
                      setState(() {
                        selectedNoteType =
                            newValue; // Update the selected note type
                      });
                    },
              items: widget.noteTypes
                  .map<DropdownMenuItem<String>>((NoteType type) {
                return DropdownMenuItem<String>(
                  value: type.name,
                  child: Text(type.name),
                );
              }).toList(),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
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
