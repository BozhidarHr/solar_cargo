import 'dart:convert';

import 'package:solar_cargo/models/token_storage.dart';

import '../screens/common/user_location.dart';
import '../services/services.dart';

class User {
  final int userID;
  final String userName;
  final String? userFullName;
  final String? userRole;
  final List<UserLocation> locations;
  final String? imageUrl;

  User({
    required this.userID,
    required this.userName,
    required this.userFullName,
    required this.locations,
    this.userRole,
    this.imageUrl,
  });

  UserLocation? _currentLocation;

  UserLocation? get currentLocation => _currentLocation;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userID: map['userID'] ?? 0,
      userName: map['userName'] ?? '',
      userFullName: map['fullName'] ?? '',
      userRole: map['userRole'],
      locations: map['locations'] != null
          ? List<UserLocation>.from(
              (map['locations']).map((item) => UserLocation.fromJson(item)))
          : [],
      imageUrl: map['imageUrl'],
    );
  }

  setUserLocation(UserLocation location) async {
    if (location == _currentLocation) {
      return; // No change needed
    }
    _currentLocation = location;
    await Services()
        .api
        .tokenStorage
        .write(StorageItem.location, jsonEncode(location.toJson()));
  }

  @override
  String toString() {
    return 'User(userID: $userID, userName: $userName, userRole: $userRole)';
  }

  bool get isAdmin {
    return userRole == 'admin';
  }
}
