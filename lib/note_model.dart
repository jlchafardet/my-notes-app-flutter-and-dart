class Note {
  String title;
  String content;
  String? id; // Optional: to store the document ID from Firestore
  String noteType; // Add this line to store the note type

  Note({
    required this.title,
    required this.content,
    required this.noteType, // Include noteType in the constructor
    this.id,
  });

  // Convert a Note object into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'noteType': noteType, // Include noteType in the map
    };
  }

  // Create a Note object from a Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      noteType: map['noteType'], // Include noteType in the factory
      id: map['id'],
    );
  }
}
