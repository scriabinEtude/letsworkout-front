class FoodCompany {
  FoodCompany({
    this.name,
    this.refCount = 0,
  });

  final String? name;
  final int? refCount;

  FoodCompany copyWith({
    String? name,
    int? refCount,
  }) =>
      FoodCompany(
        name: name ?? this.name,
        refCount: refCount ?? this.refCount,
      );

  factory FoodCompany.fromJson(Map<String, dynamic> json) => FoodCompany(
        name: json["name"],
        refCount: json["refCount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "refCount": refCount,
      };

  static List<FoodCompany> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((e) => FoodCompany.fromJson(e)).toList();
  }
}
