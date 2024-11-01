import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAdmin; // Add a parameter to check if the user is an admin

  const CustomAppBar(
      {super.key, this.isAdmin = false}); // Constructor with optional isAdmin parameter

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'My Notes',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey[800], // Dark gray background
      centerTitle: true, // Center the title
      iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      actions: [
        Tooltip(
          message: 'Show navigation menu', // Tooltip message
          child: IconButton(
            icon: Icon(Icons.menu, color: Colors.white), // Right hamburger icon
            onPressed: () {
              // Open the end drawer when the hamburger icon is tapped
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
