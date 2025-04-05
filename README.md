# BookBridge

BookBridge is an online book renting service that allows users to rent and lend books seamlessly through a digital platform.

## Features

- **Book Catalog**: Browse a wide selection of books available for rent.
- **User Accounts**: Create and manage personal accounts to keep track of rented and lent books.
- **Search Functionality**: Easily search for books by title, author, or genre.
- **Renting System**: Request to rent books from other users and manage rental durations.
- **Notifications**: Receive updates on rental requests, due dates, and other important information.

## Getting Started

These instructions will help you set up and run the BookBridge project on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install): Ensure you have Flutter installed on your system.
- [Dart SDK](https://dart.dev/get-dart): Dart comes pre-packaged with Flutter; no separate installation is required.
- [Firebase Account](https://firebase.google.com/): BookBridge uses Firebase for backend services.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/samwithwicky/BookBridge.git
   ```

2. **Navigate to the Project Directory**:

   ```bash
   cd BookBridge
   ```

3. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

4. **Set Up Firebase**:

   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your app to the Firebase project by registering it with the appropriate platform (iOS, Android, Web).
   - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) files.
   - Place these files in the respective platform directories as guided by the [Firebase setup instructions](https://firebase.flutter.dev/docs/overview/).

5. **Run the Application**:

   ```bash
   flutter run
   ```

   Ensure that you have a device or emulator running.

## Project Structure

The project is organized as follows:

- **lib/**: Contains the main application code.
- **assets/images/**: Stores image assets used in the application.
- **ios/**, **android/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific code and configurations.
- **test/**: Contains test files for the application.

## Contributing

We welcome contributions to enhance BookBridge. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgments

- [Flutter](https://flutter.dev/): The UI toolkit used to build the application.
- [Firebase](https://firebase.google.com/): Provides backend services for the application.

---

Requires your own firebase setup to run otherwise will pop error.
