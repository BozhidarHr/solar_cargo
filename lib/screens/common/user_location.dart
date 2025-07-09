class UserLocation {
  final int id;
  final String name;

  UserLocation({
    required this.id,
    required this.name,
  });

  UserLocation.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['currentLocation'] ?? '';
}
