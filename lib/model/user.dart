class User {
  User({
    this.id,
    this.userType,
    this.email,
    this.provider,
    this.tag,
    this.name,
    this.profileImage,
    this.fcmToken,
    this.createdAt,
  });

  final int? id;
  final int? userType;
  final String? email;
  final String? provider;
  final String? tag;
  final String? name;
  String? profileImage;
  final String? fcmToken;
  final String? createdAt;

  User copyWith({
    int? id,
    int? userType,
    String? email,
    String? provider,
    String? tag,
    String? name,
    String? profileImage,
    String? fcmToken,
    String? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        userType: userType ?? this.userType,
        email: email ?? this.email,
        provider: provider ?? this.provider,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt ?? this.createdAt,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userType: json["user_type"],
        email: json["email"],
        provider: json["provider"],
        tag: json["tag"],
        name: json["name"],
        profileImage: json['profile_image'],
        fcmToken: json['fcm_token'],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "email": email,
        "provider": provider,
        "tag": tag,
        "name": name,
        'profile_image': profileImage,
        'fcm_token': fcmToken,
        "created_at": createdAt,
      };

  static List<User> fromJsonList(List list) =>
      list.map((user) => User.fromJson(user)).toList();

  User deleteProfileImage() {
    profileImage = null;
    return copyWith();
  }
}
