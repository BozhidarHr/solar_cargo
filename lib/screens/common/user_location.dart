class UserLocation {
  final int id;
  final String name;

  UserLocation({
    required this.id,
    required this.name,
  });

  UserLocation.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];

  UserLocation.fromJsonPVLocation(Map<String, dynamic> map)
      : id = map['location'],
        name = map['location_name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };

}}
