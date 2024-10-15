// lib/tag_list_mainscreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class TagListMainScreen extends StatelessWidget {
  final Function(String) onTagSelected; // Callback for when a tag is selected
  final List<String> activeTags; // List of currently active tags

  TagListMainScreen({required this.onTagSelected, required this.activeTags});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tags')
          .snapshots(), // Listen for changes in the tags collection
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
          return Center(child: Text('No tags available')); // Handle empty state
        }

        // Map the fetched documents to a list of tag names
        final tags =
            snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

        return ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scrolling for tags
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            final isActive =
                activeTags.contains(tag); // Check if the tag is active

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? Colors.blueGrey
                      : null, // Change color if active
                  side: isActive
                      ? BorderSide(color: Colors.black)
                      : BorderSide.none, // Add border if active
                ),
                onPressed: () {
                  onTagSelected(
                      tag); // Call the callback when a tag is selected
                },
                child: Text(tag),
              ),
            );
          },
        );
      },
    );
  }
}
