// lib/about_screen.dart

import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // Import your custom AppBar
import 'custom_footer.dart'; // Import your custom Footer
import 'menu_drawer.dart'; // Import your custom Drawer

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key}); // Use super.key to pass the key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the custom AppBar
      endDrawer:
          MenuDrawer(), // Use the custom Drawer that slides from the right
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              // Heading for the About screen
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'About MY Notes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              // Image section
              Image.asset(
                'assets/images/note-1399152_1280.webp',
                width: MediaQuery.of(context).size.width *
                    0.5, // Set width to half of screen width
                height: MediaQuery.of(context).size.height *
                    0.5, // Set height to half of screen height
                fit: BoxFit.contain, // Maintain aspect ratio
              ),
              SizedBox(height: 20),
              // Description text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'This is the About screen. Here you can provide information about the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(), // Use the custom Footer
    );
  }
}
