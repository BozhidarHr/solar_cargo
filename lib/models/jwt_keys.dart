class JwtKeys {
  String bearerToken;
  String refreshToken;

  JwtKeys({
    required this.bearerToken,
    required this.refreshToken,
  });

  factory JwtKeys.fromJson(Map<String, dynamic> json) {
    return JwtKeys(
      bearerToken: json['bearerToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bearerToken': bearerToken,
      'refreshToken': refreshToken,
    };
  }
}
