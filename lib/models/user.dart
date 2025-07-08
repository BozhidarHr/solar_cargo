import 'package:solar_cargo/models/token_storage.dart';

import '../services/services.dart';

class User {
  final int userID;
  final String userName;
  final String? userRole;
  final List<String> locations;

  User({
    required this.userID,
    required this.userName,
    required this.locations,
    this.userRole,
  });

  String? _currentLocation;

  String? get currentLocation => _currentLocation;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userID: map['userID'] ?? 0,
      userName: map['userName'] ?? '',
      userRole: map['userRole'],
      // TODO: Remove hardcoded locations
      locations: List<String>.from(map['locations'] ??
          // ['Sofia']
          ['Sofia','Plovdiv','Varna']
          ),
    );
  }

  setUserLocation(String location)async {
    if (location == _currentLocation) {
      return; // No change needed
    }
    await Services().api.tokenStorage.write(StorageItem.location, location);
    _currentLocation = location;
  }

  @override
  String toString() {
    return 'User(userID: $userID, userName: $userName, userRole: $userRole)';
  }

  bool get isAdmin {
    return userRole == 'admin';
  }
}
