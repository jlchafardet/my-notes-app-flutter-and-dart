import 'package:flutter/material.dart';
import 'tag_management_screen.dart'; // Import the Tag Management screen
import 'notetype_admin_screen.dart'; // Import the NoteType Admin screen
import 'admin_state.dart'; // Import the AdminState
import 'main.dart'; // Import the MainScreen to access NotesScreen
import 'about_screen.dart'; // Import the About screen

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 56.0, // Set the height to match the AppBar
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800], // Match the AppBar background
              ),
              margin: EdgeInsets.all(0.0), // Remove margin
              padding: EdgeInsets.all(0.0), // Remove padding
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white), // Close icon
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Expanded(
                    // Allow the text to take available space
                    child: Center(
                      // Center the text vertically
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust font size if needed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // New link to go back to the main screen
          ListTile(
            title: Text('Notes'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotesScreen()), // Navigate to Notes Screen
                (Route<dynamic> route) => false, // Remove all other screens
              );
            },
          ),
          ListTile(
            title: Text('Tag Management'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TagManagementScreen()), // Navigate to Tag Management screen
              );
            },
          ),
          // Conditionally show the NoteType Admin link if isAdmin is true
          if (AdminState().isAdmin) // Check if the user is an admin
            ListTile(
              title: Text('Note Type Management'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoteTypeAdminScreen()), // Navigate to Note Type Admin screen
                );
              },
            ),
          // Add the About screen link as the last item
          ListTile(
            title: Text('About'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AboutScreen()), // Navigate to About screen
              );
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}
