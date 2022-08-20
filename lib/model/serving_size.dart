class ServingSize {
  ServingSize({
    required this.servingName,
    required this.servingSize,
    this.display,
  });

  final String servingName;
  final int servingSize;
  final String? display;

  ServingSize copyWith({
    String? servingName,
    int? servingSize,
    String? display,
  }) =>
      ServingSize(
        servingName: servingName ?? this.servingName,
        servingSize: servingSize ?? this.servingSize,
        display: display ?? this.display,
      );

  factory ServingSize.fromJson(Map<String, dynamic> json) => ServingSize(
        servingName: json["servingName"],
        servingSize: json["servingSize"],
      );
  static List<ServingSize> fromJsonList(List? list) {
    return list == null
        ? []
        : list.map((e) => ServingSize.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        "servingName": servingName,
        "servingSize": servingSize,
      };
}
