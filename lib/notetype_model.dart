import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class NoteType {
  String id; // Add this line to store the document ID
  String name;
  String? description; // Optional
  DateTime createdAt;
  DateTime updatedAt;

  NoteType({
    required this.id, // Include id in the constructor
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a NoteType object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a NoteType object from a Map
  factory NoteType.fromMap(Map<String, dynamic> map) {
    return NoteType(
      id: map['id'] ?? '', // Ensure id is not null
      name: map['name'] ?? 'Unnamed', // Default to 'Unnamed' if null
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
