// lib/tag_management_screen.dart

import 'package:flutter/material.dart';
import 'tag_form_screen.dart'; // Import the Tag Form Screen
import 'tag_model.dart'; // Import the Tag Model (if applicable)

class TagManagementScreen extends StatefulWidget {
  @override
  _TagManagementScreenState createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  List<String> tags = []; // This will hold the list of tags

  @override
  void initState() {
    super.initState();
    _fetchTags(); // Fetch existing tags from Firestore
  }

  void _fetchTags() {
    // TODO: Implement Firestore fetching logic
  }

  void _addTag() {
    // Navigate to the Tag Form Screen to add a new tag
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagFormScreen()),
    ).then((_) {
      _fetchTags(); // Refresh the tag list after adding
    });
  }

  void _editTag(String tag) {
    // Navigate to the Tag Form Screen to edit the selected tag
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagFormScreen(tag: tag)),
    ).then((_) {
      _fetchTags(); // Refresh the tag list after editing
    });
  }

  void _deleteTag(String tag) {
    // TODO: Implement delete confirmation and Firestore deletion logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addTag, // Add new tag
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return ListTile(
            title: Text(tag),
            onTap: () => _editTag(tag), // Edit tag on tap
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTag(tag), // Delete tag
            ),
          );
        },
      ),
    );
  }
}
