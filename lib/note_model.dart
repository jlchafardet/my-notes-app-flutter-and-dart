class Note {
  String title;
  String content;
  String? id; // Optional: to store the document ID from Firestore

  Note({
    required this.title,
    required this.content,
    this.id,
  });

  // Convert a Note object into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  // Create a Note object from a Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      id: map['id'],
    );
  }
}
