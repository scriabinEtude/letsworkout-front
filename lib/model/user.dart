class User {
  User({
    this.id,
    this.email,
    this.provider,
    this.tag,
    this.name,
    this.createdAt,
  });

  final int? id;
  final String? email;
  final String? provider;
  final String? tag;
  final String? name;
  final String? createdAt;

  User copyWith({
    int? id,
    String? email,
    String? provider,
    String? tag,
    String? name,
    String? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        provider: provider ?? this.provider,
        tag: tag ?? this.tag,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        provider: json["provider"],
        tag: json["tag"],
        name: json["name"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "provider": provider,
        "tag": tag,
        "name": name,
        "createdAt": createdAt,
      };
}
