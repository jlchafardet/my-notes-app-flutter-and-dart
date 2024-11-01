// lib/tag_form_screen.dart

import 'package:flutter/material.dart';
import 'tag_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'custom_app_bar.dart'; // Import the Custom App Bar
import 'custom_footer.dart'; // Import the Custom Footer
import 'menu_drawer.dart'; // Import the Menu Drawer

class TagFormScreen extends StatefulWidget {
  final Tag? tag; // Optional tag for editing
  final Function(Tag) onSave; // Callback for saving the tag

  const TagFormScreen({super.key, this.tag, required this.onSave});

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
      appBar: CustomAppBar(), // Use the CustomAppBar
      endDrawer: MenuDrawer(), // Use the MenuDrawer as an end drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              // Center the header
              child: Text(
                widget.tag == null
                    ? 'Add New Tag'
                    : 'Edit Tag', // Conditional header text
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold), // Header style
              ),
            ),
            SizedBox(height: 20), // Space between header and form
            Form(
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
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(), // Use the CustomFooter
    );
  }
}
