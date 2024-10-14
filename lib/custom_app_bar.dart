import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAdmin; // Add a parameter to check if the user is an admin

  CustomAppBar(
      {this.isAdmin = false}); // Constructor with optional isAdmin parameter

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'My Notes',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey[800], // Dark gray background
      centerTitle: true, // Center the title
      leading: IconButton(
        icon:
            Icon(Icons.menu, color: Colors.white), // Change icon color to white
        onPressed: () {
          // Open the drawer when the hamburger icon is tapped
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white), // White icon
          onSelected: (value) {
            if (value == 'tag_management') {
              // Navigate to tag management screen
              // Add your navigation logic here
            } else if (value == 'admin_panel') {
              // Navigate to admin panel
              // Add your navigation logic here
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'tag_management',
                child: Text('Tag Management'),
              ),
              if (isAdmin) // Show Admin Panel only if isAdmin is true
                PopupMenuItem<String>(
                  value: 'admin_panel',
                  child: Text('Admin Panel'),
                ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
