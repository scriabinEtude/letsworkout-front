class User {
  User({
    this.id,
    this.email,
    this.provider,
    this.tag,
    this.name,
    this.profileImage,
    this.createdAt,
  });

  final int? id;
  final String? email;
  final String? provider;
  final String? tag;
  final String? name;
  String? profileImage;
  final String? createdAt;

  User copyWith({
    int? id,
    String? email,
    String? provider,
    String? tag,
    String? name,
    String? profileImage,
    String? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        provider: provider ?? this.provider,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
        createdAt: createdAt ?? this.createdAt,
      );

  User deleteProfileImage() {
    profileImage = null;
    return copyWith();
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        provider: json["provider"],
        tag: json["tag"],
        name: json["name"],
        profileImage: json['profile_image'],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "provider": provider,
        "tag": tag,
        "name": name,
        'profile_image': profileImage,
        "created_at": createdAt,
      };

  static List<User> fromJsonList(List list) =>
      list.map((user) => User.fromJson(user)).toList();
}
