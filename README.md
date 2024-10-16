# My Notes App

A Flutter application for managing notes.

## Features Implemented

### Step 1: Basic Notes Functionality

1. **Phase 1: Basic Notes Functionality**
   - Implement note model and basic structure
     - Create note_model.dart for the Note class
     - Set up main.dart with basic app structure and navigation
   - Create a screen to add a new note
     Implement note_form_screen.dart for adding and editing notes
     Add form fields for title and content
   - Implement a list view to display all notes
     - Create a notes list view in main.dart
     - Implement navigation to note_form_screen.dart for editing
   - Add functionality to edit existing notes
     - Modify note_form_screen.dart to handle editing
     - Implement update logic in main.dart
   - Implement delete functionality for notes
     - Add delete option in the notes list
     - Implement delete logic in main.dart

2. **Phase 2: Data Persistence with Firebase Firestore**
   - Set up Firebase project and add dependencies
   - Configure Firebase in main.dart
   - Modify note_model.dart for Firestore compatibility
   - Implement CRUD operations with Firestore in main.dart
   - Update UI to use Firestore data
   - Implement offline capabilities and error handling
   - Test data persistence and synchronization

3. **Phase 3: Types of Notes**
   - Create notetype_model.dart for NoteType class
   - Implement notetype_form_screen.dart for adding/editing note types
   - Create notetype_admin_screen.dart for managing note types
   - Update note_form_screen.dart to include note type selection
   - Modify main.dart to incorporate note types in the list view
   - Implement admin-only access for note type management
   - Test functionality for different note types

4. **Phase 4: Tags**
   - Create tag_model.dart for Tag class
   - Implement tag_form_screen.dart for adding/editing tags
   - Create tag_management_screen.dart for managing tags
   - Implement tag_list_mainscreen.dart for displaying and filtering by tags
   - Update note_form_screen.dart to include tag selection
   - Modify main.dart to incorporate tags in the note list view
   - Implement tag filtering functionality
   - Test tagging system and filters

     ### Additional Components (Implemented across phases):

     - Implement admin_state.dart for managing admin privileges
     - Create custom_app_bar.dart for the app header
     - Implement menu_drawer.dart for navigation
     - Create custom_footer.dart for the app footer
     - Develop about_screen.dart for app information

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
