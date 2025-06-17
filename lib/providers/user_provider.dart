import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User _currentUser = User(
    id: 'default_id', // Provide a default ID
    name: 'Guest',
    email: '',
    bio: null,
    profileImage: null,
  );

  User get currentUser => _currentUser;

  // Method to update user profile
  void updateProfile({
    required String name,
    required String email,
    String? bio,
  }) {
    // In a real app, this would typically involve an API call
    _currentUser = _currentUser.copyWith(name: name, email: email, bio: bio);
    notifyListeners();
  }

  // Method to update profile picture
  void updateProfilePicture(String? imageUrl) {
    _currentUser = _currentUser.copyWith(profileImage: imageUrl);
    notifyListeners();
  }

  // Method to remove profile picture
  void removeProfilePicture() {
    _currentUser = _currentUser.copyWith(profileImage: null);
    notifyListeners();
  }

  // Example method for setting user data (e.g., after login)
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
