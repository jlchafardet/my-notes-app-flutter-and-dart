import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0, // Set a fixed height for the footer
      color: Colors.grey[800], // Match the app bar color
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          '© 2024 - JLChafardet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
