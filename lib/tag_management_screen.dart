// lib/tag_management_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'tag_form_screen.dart'; // Import the Tag Form Screen
import 'tag_model.dart'; // Import the Tag Model
import 'custom_app_bar.dart'; // Import the Custom App Bar
import 'custom_footer.dart'; // Import the Custom Footer
import 'menu_drawer.dart'; // Import the Menu Drawer

class TagManagementScreen extends StatefulWidget {
  @override
  _TagManagementScreenState createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  List<String> tags = []; // This will hold the list of tags

  @override
  void initState() {
    super.initState();
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
              child: Text('No Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Red background
                foregroundColor: Colors.white, // White text
              ),
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: Text('Yes Delete'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      // Proceed with deletion
      await FirebaseFirestore.instance.collection('tags').doc(tag).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the Custom App Bar
      endDrawer: MenuDrawer(), // Use endDrawer for the right-side drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tags',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('tags').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No tags available'));
                  }

                  final tags = snapshot.data!.docs
                      .map((doc) => doc['name'] as String)
                      .toList();

                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return ListTile(
                        title: Text(tag),
                        onTap: () => _editTag(tag),
                        trailing: Ink(
                          decoration: const ShapeDecoration(
                            color:
                                Colors.red, // Red background for delete button
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.white), // White icon
                            onPressed: () => _deleteTag(tag),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(), // Use the CustomFooter
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, // Position the FAB at the bottom right, docked above the footer
      floatingActionButton: FloatingActionButton(
        onPressed: _addTag,
        child: Icon(Icons.add), // Icon for the FAB
        backgroundColor: Colors.blue, // Background color for the FAB
      ),
    );
  }
}
