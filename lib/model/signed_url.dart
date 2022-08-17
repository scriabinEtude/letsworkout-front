class SignedUrl {
  final String signedUrl;
  final String url;
  final String ext;

  SignedUrl({
    required this.signedUrl,
    required this.url,
    required this.ext,
  });

  factory SignedUrl.fromJson(Map json) => SignedUrl(
        signedUrl: json['signedUrl'],
        url: json['url'],
        ext: json['ext'],
      );

  static List<SignedUrl> fromJsonList(List list) =>
      list.map((json) => SignedUrl.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'signedUrl': signedUrl,
        'url': url,
        'ext': ext,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
