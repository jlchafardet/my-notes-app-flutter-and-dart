import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class NoteType {
  String name;
  String? description; // Optional
  DateTime createdAt;
  DateTime updatedAt;

  NoteType({
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a NoteType object into a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a NoteType object from a Map
  factory NoteType.fromMap(Map<String, dynamic> map) {
    return NoteType(
      name: map['name'],
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
      updatedAt: (map['updatedAt'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }
}
