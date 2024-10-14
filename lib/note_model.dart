class Note {
  String title;
  String content;
  String? id; // Optional: to store the document ID from Firestore
  String noteType; // To store the note type
  List<String> tags; // To store the tags associated with the note

  Note({
    required this.title,
    required this.content,
    required this.noteType,
    this.id,
    this.tags = const [],
  });

  // Convert a Note object into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'noteType': noteType,
      'tags': tags,
    };
  }

  // Create a Note object from a Map
  factory Note.fromMap(Map<String, dynamic> map, String documentId) {
    return Note(
      title: map['title'],
      content: map['content'],
      noteType: map['noteType'],
      id: documentId, // Set the document ID here
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
