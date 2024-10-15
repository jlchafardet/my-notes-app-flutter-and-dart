import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'notetype_model.dart'; // Import the NoteType model
import 'custom_app_bar.dart'; // Import the Custom App Bar
import 'custom_footer.dart'; // Import the Custom Footer
import 'menu_drawer.dart'; // Import the Menu Drawer

class AddNoteTypeScreen extends StatefulWidget {
  final NoteType? noteType; // Optional NoteType for editing
  final bool isEditing; // Flag to indicate if we are editing

  const AddNoteTypeScreen({super.key, this.noteType, this.isEditing = false});

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
      appBar: CustomAppBar(), // Use the Custom App Bar
      endDrawer: MenuDrawer(), // Use the Menu Drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              // Center the header
              child: Text(
                widget.isEditing
                    ? 'Edit Type of Note'
                    : 'Add New Type of Note', // Conditional header text
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold), // Header style
              ),
            ),
            SizedBox(height: 20), // Space between header and fields
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
                    'createdAt': widget.isEditing
                        ? widget.noteType!.createdAt
                        : DateTime.now(), // Set createdAt only when adding
                    'updatedAt': DateTime.now(), // Always update updatedAt
                    'fields': '{}', // Initialize fields as an empty JSON object
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
      bottomNavigationBar: CustomFooter(), // Use the Custom Footer
    );
  }
}
