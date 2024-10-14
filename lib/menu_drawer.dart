import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
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
                  Expanded(
                    // Allow the text to take available space
                    child: Center(
                      // Center the text vertically
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20), // Adjust font size if needed
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white), // Close icon
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Tag Management'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add your navigation logic here
            },
          ),
          // Add more menu items as needed
        ],
      ),
    );
  }
}
