class CustomerQuestion {
  CustomerQuestion({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.device,
    this.os,
    this.appVersion,
    this.buildNumber,
  });

  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final String? device;
  final String? os;
  final String? appVersion;
  final String? buildNumber;

  CustomerQuestion copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? device,
    String? os,
    String? appVersion,
    String? buildNumber,
  }) =>
      CustomerQuestion(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        device: device ?? this.device,
        os: os ?? this.os,
        appVersion: appVersion ?? this.appVersion,
        buildNumber: buildNumber ?? this.buildNumber,
      );

  factory CustomerQuestion.fromJson(Map<String, dynamic> json) =>
      CustomerQuestion(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        body: json["body"],
        device: json["device"],
        os: json["os"],
        appVersion: json["app_version"],
        buildNumber: json["build_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "body": body,
        "device": device,
        "os": os,
        "app_version": appVersion,
        "build_number": buildNumber,
      };
}
