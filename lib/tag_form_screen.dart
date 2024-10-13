// lib/tag_form_screen.dart

import 'package:flutter/material.dart';
import 'tag_model.dart';

class TagFormScreen extends StatelessWidget {
  final Tag? tag; // Optional tag for editing
  final Function(Tag) onSave; // Callback for saving the tag

  TagFormScreen({this.tag, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: tag?.name ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(tag == null ? 'Add Tag' : 'Edit Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Tag Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTag = Tag(
                  id: tag?.id ?? UniqueKey().toString(),
                  name: controller.text,
                );
                onSave(newTag); // Call the save callback
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(tag == null ? 'Add Tag' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
