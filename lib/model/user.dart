class User {
  User({
    this.userId,
    this.userType,
    this.email,
    this.provider,
    this.tag,
    this.name,
    this.profileImage,
    this.fcmToken,
    this.createdAt,
  });

  final String? userId;
  final String? userType;
  final String? email;
  final String? provider;
  final String? tag;
  final String? name;
  String? profileImage;
  final String? fcmToken;
  final String? createdAt;

  User copyWith({
    String? userId,
    String? userType,
    String? email,
    String? provider,
    String? tag,
    String? name,
    String? profileImage,
    String? fcmToken,
    String? createdAt,
  }) =>
      User(
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        email: email ?? this.email,
        provider: provider ?? this.provider,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt ?? this.createdAt,
      );

  static User? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return User(
      userId: json["_id"],
      userType: json["userType"],
      email: json["email"],
      provider: json["provider"],
      tag: json["tag"],
      name: json["name"],
      profileImage: json['profileImage'],
      fcmToken: json['fcmToken'],
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": userId,
        "userType": userType,
        "email": email,
        "provider": provider,
        "tag": tag,
        "name": name,
        'profileImage': profileImage,
        'fcm_token': fcmToken,
        "createdAt": createdAt,
      };

  static List<User> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((user) => User.fromJson(user)!).toList();
  }

  User deleteProfileImage() {
    profileImage = null;
    return copyWith();
  }
}
