# My Notes App

A Flutter application for managing notes.

## Features Implemented

### Step 1: Basic Notes Functionality

1. **Create a Screen to Add a New Note (Title, Content)**:
   - Users can input a title and content for a new note through a dedicated screen.

2. **Implement a List View to Display All Notes**:
   - The app displays a list of all notes that have been created, allowing users to see their notes at a glance.

3. **Add Functionality to Edit Existing Notes**:
   - Users can tap on a note to edit its title and content, making it easy to update information as needed.

### Step 2: Data Persistence with Firebase Firestore

1. **Set Up Firebase**:
   - The app is integrated with Firebase Firestore for data persistence, allowing users to save, retrieve, edit, and delete notes in real-time.

2. **CRUD Operations**:
   - Users can create new notes, read existing notes, update notes, and delete notes, all of which are reflected in Firestore.

## Getting Started

To run this project, you need to have Flutter installed on your machine. Follow the instructions below to get started.

### Prerequisites

- Flutter SDK
- Dart SDK
- Firebase account (for Firestore)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/USERNAME/my_notes_app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd my_notes_app
   ```

3. Get the dependencies:
   ```bash
   flutter pub get
   ```

4. **Set Up Firebase**:
   - Follow the instructions in the [Firebase Console](https://console.firebase.google.com/) to create a new project and enable Firestore.
   - Add the Firebase configuration to the `web/index.html` file as described in the tutorial.

### Running the App

To run the app, use the following command:
```bash
flutter run
```

## Resources

For more information on Flutter development, check out the official documentation:
- [Flutter Documentation](https://flutter.dev/docs)

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request. Ensure that any changes related to Firebase are well-documented.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Developed by:  
José Luis Chafardet Grimaldi
jose.chafardet@icloud.com  
10/8/2024
