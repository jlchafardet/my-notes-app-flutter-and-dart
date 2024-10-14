// lib/tag_management_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'tag_form_screen.dart'; // Import the Tag Form Screen
import 'tag_model.dart'; // Import the Tag Model

class TagManagementScreen extends StatefulWidget {
  @override
  _TagManagementScreenState createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  List<String> tags = []; // This will hold the list of tags

  @override
  void initState() {
    super.initState();
    // Remove the call to _fetchTags() here
  }

  void _addTag() {
    // Navigate to the Tag Form Screen to add a new tag
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagFormScreen(
          onSave: (newTag) {
            // Logic to add the new tag to Firestore
            FirebaseFirestore.instance.collection('tags').add({'name': newTag});
            // Remove the call to _fetchTags() here
          },
        ),
      ),
    );
  }

  void _editTag(String tagName) {
    // Fetch the tag document from Firestore to get the document ID
    FirebaseFirestore.instance
        .collection('tags')
        .where('name', isEqualTo: tagName)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first; // Get the first document
        final tag = Tag(name: tagName); // Create Tag with name

        // Navigate to the Tag Form Screen to edit the selected tag
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TagFormScreen(
              tag: tag, // Pass the Tag object
              onSave: (updatedTag) {
                // Logic to update the tag in Firestore
                doc.reference.update({'name': updatedTag});
                // Remove the call to _fetchTags() here
              },
            ),
          ),
        );
      }
    });
  }

  void _deleteTag(String tag) async {
    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this tag?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      // Logic to delete the tag from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('tags')
          .where('name', isEqualTo: tag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete(); // Delete the document
        // Remove the call to _fetchTags() here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Management'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tags')
            .snapshots(), // Listen for changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Handle errors
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No tags available')); // Handle empty state
          }

          // Map the fetched documents to a list of tag names
          final tags =
              snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                title: Text(tag),
                onTap: () => _editTag(tag), // Edit tag on tap
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red, // Background color for the delete button
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.white), // Set icon color to white
                    onPressed: () => _deleteTag(tag), // Delete tag
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTag, // Call the method to add a new tag
        child: Icon(Icons.add), // Icon for the button
        backgroundColor: Colors.blue, // Set the background color
      ),
    );
  }
}
