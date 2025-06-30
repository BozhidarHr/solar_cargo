class User {
  final int userID;
  final String userName;
  final String? userRole;

  User({
    required this.userID,
    required this.userName,
    this.userRole,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userID: map['userID'] ?? 0,
      userName: map['userName'] ?? '',
      userRole: map['userRole'],
    );
  }

  @override
  String toString() {
    return 'User(userID: $userID, userName: $userName, userRole: $userRole)';
  }
  bool get isAdmin{
    return userRole == 'admin';
  }
}