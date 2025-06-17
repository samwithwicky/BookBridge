import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

class LocationProvider with ChangeNotifier {
  // Add these getters to the LocationProvider class
  UserLocation? get selectedLocation => _selectedLocation;
  List<UserLocation> get locations => List.unmodifiable(_locations);
  List<UserLocation> _locations = [];
  UserLocation? _selectedLocation;
  static const String _locationsKey = 'user_locations';
  static const String _selectedLocationKey = 'selected_location_id';

  LocationProvider() {
    _loadLocations();
  }

  // Load locations from SharedPreferences
  Future<void> _loadLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getString(_locationsKey);
      final selectedId = prefs.getString(_selectedLocationKey);

      if (locationsJson != null) {
        final List<dynamic> decoded = jsonDecode(locationsJson);
        _locations =
            decoded.map((item) => UserLocation.fromJson(item)).toList();

        if (selectedId != null && _locations.isNotEmpty) {
          _selectedLocation = _locations.firstWhere(
            (loc) => loc.id == selectedId,
            orElse: () => _locations.first,
          );
        } else if (_locations.isNotEmpty) {
          _selectedLocation = _locations.first;
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load locations: $e');
    }
  }

  // Save locations to SharedPreferences
  Future<void> _saveLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = jsonEncode(
        _locations.map((loc) => loc.toJson()).toList(),
      );

      await prefs.setString(_locationsKey, locationsJson);

      if (_selectedLocation != null) {
        await prefs.setString(_selectedLocationKey, _selectedLocation!.id);
      }
    } catch (e) {
      debugPrint('Failed to save locations: $e');
    }
  }

  // Rest of your existing methods with _saveLocations() added at the end

  void addLocation(UserLocation location) {
    // If this is the first location or marked as default, make it the selected location
    if (_locations.isEmpty || location.isDefault) {
      if (location.isDefault && _locations.isNotEmpty) {
        // If this is a new default, remove default from others
        _locations =
            _locations.map((loc) => loc.copyWith(isDefault: false)).toList();
      }
      _selectedLocation = location;
    }

    _locations.add(location);
    _saveLocations();
    notifyListeners();
  }

  void updateLocation(UserLocation location) {
    final index = _locations.indexWhere((loc) => loc.id == location.id);
    if (index >= 0) {
      // Handle default status changes
      if (location.isDefault) {
        _locations =
            _locations
                .map(
                  (loc) =>
                      loc.id != location.id
                          ? loc.copyWith(isDefault: false)
                          : loc,
                )
                .toList();
        _selectedLocation = location;
      }

      _locations[index] = location;
      _saveLocations();
      notifyListeners();
    }
  }

  void removeLocation(String locationId) {
    _locations.removeWhere((location) => location.id == locationId);

    // If we removed the selected location, select another one if available
    if (_selectedLocation != null && _selectedLocation!.id == locationId) {
      _selectedLocation =
          _locations.isNotEmpty
              ? _locations.firstWhere(
                (loc) => loc.isDefault,
                orElse: () => _locations.first,
              )
              : null;
    }

    _saveLocations();
    notifyListeners();
  }

  void selectLocation(String locationId) {
    final location = _locations.firstWhere(
      (loc) => loc.id == locationId,
      orElse: () => throw Exception('Location not found'),
    );

    _selectedLocation = location;
    _saveLocations();
    notifyListeners();
  }
}
