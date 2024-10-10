import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore// Import Firestore

class AddNoteTypeScreen extends StatefulWidget {
  const AddNoteTypeScreen({Key? key}) : super(key: key);

  @override
  _AddNoteTypeScreenState createState() => _AddNoteTypeScreenState();
}

class _AddNoteTypeScreenState extends State<AddNoteTypeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note Type'),
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
                    'createdAt': DateTime.now(), // Add createdAt timestamp
                    'updatedAt': DateTime.now(), // Add updatedAt timestamp
                  };

                  // Save the new note type to Firestore
                  await FirebaseFirestore.instance
                      .collection('noteTypes')
                      .add(newNoteType);

                  Navigator.pop(context); // Return to the previous screen
                }
              },
              child: const Text('Save Note Type'),
            ),
          ],
        ),
      ),
    );
  }
}
