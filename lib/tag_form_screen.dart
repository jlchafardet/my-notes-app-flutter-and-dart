// lib/tag_form_screen.dart

import 'package:flutter/material.dart';
import 'tag_model.dart';

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
      final newTag = Tag(
        id: widget.tag?.id ?? UniqueKey().toString(),
        name: _tagName,
      );
      widget.onSave(newTag); // Call the save callback
      Navigator.pop(context); // Go back to the previous screen
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
