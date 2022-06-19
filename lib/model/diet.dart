class Diet {
  Diet({
    this.id,
  });

  final int? id;

  Diet copyWith({
    int? id,
  }) =>
      Diet(
        id: id ?? this.id,
      );

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
