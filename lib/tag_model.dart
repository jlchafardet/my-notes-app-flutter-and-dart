// lib/tag_model.dart

class Tag {
  String name; // Name of the tag

  Tag({required this.name});

  // Method to convert a Tag object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Method to create a Tag object from a Map
  static Tag fromMap(Map<String, dynamic> map) {
    return Tag(
      name: map['name'],
    );
  }
}
