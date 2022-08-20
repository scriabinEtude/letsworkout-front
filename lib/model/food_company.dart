class FoodCompany {
  FoodCompany({
    this.foodCompanyId,
    required this.name,
    this.refCount,
  });

  final String? foodCompanyId;
  final String name;
  final int? refCount;

  FoodCompany copyWith({
    String? foodCompanyId,
    String? name,
    int? refCount,
  }) =>
      FoodCompany(
        foodCompanyId: foodCompanyId ?? this.foodCompanyId,
        name: name ?? this.name,
        refCount: refCount ?? this.refCount,
      );

  factory FoodCompany.fromJson(Map<String, dynamic> json) => FoodCompany(
        foodCompanyId: json["_id"],
        name: json["name"],
        refCount: json["refCount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": foodCompanyId,
        "name": name,
        "refCount": refCount,
      };

  static List<FoodCompany> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((e) => FoodCompany.fromJson(e)).toList();
  }
}
