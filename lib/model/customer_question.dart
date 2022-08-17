class CustomerQuestion {
  CustomerQuestion({
    this.customerQuestionId,
    this.userId,
    this.title,
    this.body,
    this.device,
    this.os,
    this.appVersion,
  });

  final String? customerQuestionId;
  final String? userId;
  final String? title;
  final String? body;
  final String? device;
  final String? os;
  final String? appVersion;

  CustomerQuestion copyWith({
    String? customerQuestionId,
    String? userId,
    String? title,
    String? body,
    String? device,
    String? os,
    String? appVersion,
  }) =>
      CustomerQuestion(
        customerQuestionId: customerQuestionId ?? this.customerQuestionId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        device: device ?? this.device,
        os: os ?? this.os,
        appVersion: appVersion ?? this.appVersion,
      );

  factory CustomerQuestion.fromJson(Map<String, dynamic> json) =>
      CustomerQuestion(
        customerQuestionId: json["_id"],
        userId: json["userId"],
        title: json["title"],
        body: json["body"],
        device: json["device"],
        os: json["os"],
        appVersion: json["appVersion"],
      );

  Map<String, dynamic> toJson() => {
        "_id": customerQuestionId,
        "userId": userId,
        "title": title,
        "body": body,
        "device": device,
        "os": os,
        "appVersion": appVersion,
      };

  static List<CustomerQuestion> fromJsonList(List list) =>
      list.map((e) => CustomerQuestion.fromJson(e)).toList();
}
