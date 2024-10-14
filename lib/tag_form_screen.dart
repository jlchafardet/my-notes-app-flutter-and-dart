// lib/tag_form_screen.dart

import 'package:flutter/material.dart';
import 'tag_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class TagFormScreen extends StatefulWidget {
  final Tag? tag; // Optional tag for editing
  final Function(Tag) onSave; // Callback for saving the tag

  TagFormScreen({this.tag, required this.onSave});

  @override
  _TagFormScreenState createState() => _TagFormScreenState();
}

class _TagFormScreenState extends State<TagFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _tagName = '';

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      _tagName =
          widget.tag!.name; // Pre-fill the form with the existing tag name
    }
  }

  void _saveTag() {
    if (_formKey.currentState!.validate()) {
      final tagRef = FirebaseFirestore.instance
          .collection('tags'); // Reference to the tags collection

      if (widget.tag == null) {
        // Adding a new tag
        tagRef.add({'name': _tagName}).then((value) {
          Navigator.pop(context); // Close the form after saving
        }).catchError((error) {
          // Handle error
          print("Failed to add tag: $error");
        });
      } else {
        // Updating an existing tag
        tagRef
            .where('name', isEqualTo: widget.tag!.name)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            snapshot.docs.first.reference.update({'name': _tagName}).then((_) {
              Navigator.pop(context); // Close the form after saving
            }).catchError((error) {
              // Handle error
              print("Failed to update tag: $error");
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tag == null ? 'Add Tag' : 'Edit Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _tagName,
                decoration: InputDecoration(labelText: 'Tag Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _tagName = value; // Update the tag name as the user types
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTag,
                child: Text(widget.tag == null ? 'Add Tag' : 'Update Tag'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
