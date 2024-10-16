import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'notetype_form_screen.dart'; // Import the NoteType form screen
import 'custom_app_bar.dart'; // Import the Custom App Bar
import 'custom_footer.dart'; // Import the Custom Footer
import 'menu_drawer.dart'; // Import the Menu Drawer
import 'notetype_model.dart'; // Import the NoteType model

class NoteTypeAdminScreen extends StatefulWidget {
  @override
  _NoteTypeAdminScreenState createState() => _NoteTypeAdminScreenState();
}

class _NoteTypeAdminScreenState extends State<NoteTypeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the Custom App Bar
      endDrawer: MenuDrawer(), // Use the Menu Drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Use Column to stack header and list
          children: [
            Center(
              // Center the header
              child: Text(
                'Type of notes', // Header text
                style: TextStyle(
                  fontSize: 24, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
            SizedBox(height: 16), // Add some space between header and list
            Expanded(
              // Use Expanded to fill available space
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('noteTypes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No note types available'));
                  }

                  final noteTypes = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: noteTypes.length,
                    itemBuilder: (context, index) {
                      final noteType = noteTypes[index];
                      return ListTile(
                        title: Text(noteType['name']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNoteTypeScreen(
                                noteType: NoteType(
                                  id: noteType.id,
                                  name: noteType['name'],
                                  description: noteType['description'],
                                  createdAt: noteType['createdAt'].toDate(),
                                  updatedAt: noteType['updatedAt'].toDate(),
                                ),
                                isEditing: true,
                              ),
                            ),
                          );
                        },
                        trailing: Ink(
                          decoration: const ShapeDecoration(
                            color:
                                Colors.red, // Red background for delete button
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.white), // White icon
                            onPressed: () async {
                              bool confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Deletion'),
                                    content: Text(
                                        'Are you sure you want to delete this note type?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(false), // No
                                        child: Text('No Cancel'),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // Red background
                                          foregroundColor:
                                              Colors.white, // White text
                                        ),
                                        onPressed: () => Navigator.of(context)
                                            .pop(true), // Yes
                                        child: Text('Yes Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm) {
                                await FirebaseFirestore.instance
                                    .collection('noteTypes')
                                    .doc(noteType.id)
                                    .delete();
                              }
                            },
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
      bottomNavigationBar: CustomFooter(), // Use the Custom Footer
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, // Position the FAB at the bottom right, docked above the footer
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the NoteType form screen to add a new note type
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteTypeScreen(
                isEditing: false, // Indicate that we are adding a new note type
              ),
            ),
          );
        },
        backgroundColor: Colors.blue, // Background color for the FAB
        child: Icon(Icons.add, color: Colors.white), // Icon for the FAB
      ),
    );
  }
}
