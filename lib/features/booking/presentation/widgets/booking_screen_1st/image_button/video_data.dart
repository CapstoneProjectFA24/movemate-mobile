// video_data.dart
class VideoData {
  final String url;
  final String publicId;
  final int size; // Dung lượng video tính bằng bytes

  VideoData({
    required this.url,
    required this.publicId,
    required this.size,
  });

  // Thêm phương thức copyWith nếu cần
  VideoData copyWith({
    String? url,
    String? publicId,
    int? size,
  }) {
    return VideoData(
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
      size: size ?? this.size,
    );
  }
}
