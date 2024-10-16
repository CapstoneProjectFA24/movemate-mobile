class ImageData {
  final String url;
  final String publicId;

  ImageData({required this.url, required this.publicId});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'],
      publicId: json['publicId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'publicId': publicId,
    };
  }
}
