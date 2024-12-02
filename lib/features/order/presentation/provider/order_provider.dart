// booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import '/features/booking/domain/entities/booking_enities.dart';

class OrderNotifier extends StateNotifier<Booking> {
  static const int maxImages = 5; // Giới hạn hình ảnh tối đa
  static const int maxVideos = 2; // Giới hạn video tối đa
  static const int maxVideoSize = 25 * 1024 * 1024; // 25 MB tính bằng bytes

  OrderNotifier()
      : super(Booking(
          totalPrice: 0.0,
          additionalServiceQuantities: [],
          livingRoomImages: [],
          livingRoomVideos: [],
        ));

  /// xử lý ảnh và video

  // Method to set the loading state for uploading living room images
  void setUploadingLivingRoomImage(bool isUploading) {
    state = state.copyWith(isUploadingLivingRoomImage: isUploading);
  }

  // Method to set the loading state for uploading living room videos
  void setUploadingLivingRoomVideo(bool isUploading) {
    state = state.copyWith(isUploadingLivingRoomVideo: isUploading);
  }

// Phương thức lấy danh sách hình ảnh cho một loại phòng
  List<ImageData> getImages(RoomType roomType) {
    switch (roomType) {
      case RoomType.livingRoom:
        return state.livingRoomImages;
      case RoomType.bedroom:
        return state.bedroomImages;
      case RoomType.diningRoom:
        return state.diningRoomImages;
      case RoomType.officeRoom:
        return state.officeRoomImages;
      case RoomType.bathroom:
        return state.bathroomImages;
    }
  }

  // Phương thức lấy danh sách video cho phòng khách
  List<VideoData> getVideos(RoomType roomType) {
    switch (roomType) {
      case RoomType.livingRoom:
        return state.livingRoomVideos;
      default:
        return [];
    }
  }

  // Phương thức kiểm tra xem có thể thêm hình ảnh mới hay không
  bool canAddImage(RoomType roomType) {
    return getImages(roomType).length < maxImages;
  }

  // Phương thức kiểm tra xem có thể thêm video mới hay không
  bool canAddVideo(RoomType roomType) {
    return getVideos(roomType).length < maxVideos;
  }

// Modify addImageToRoom to handle loading state
  Future<void> addImageToRoom(RoomType roomType, ImageData imageData) async {
    if (!canAddImage(roomType)) {
      // Không thêm hình ảnh nếu đã đạt giới hạn
      return;
    }

    // Set loading state if roomType is livingRoom
    if (roomType == RoomType.livingRoom) {
      setUploadingLivingRoomImage(true);
    }

    try {
      switch (roomType) {
        case RoomType.livingRoom:
          state = state.copyWith(
            livingRoomImages: [...state.livingRoomImages, imageData],
          );
          break;
        case RoomType.bedroom:
          state = state.copyWith(
            bedroomImages: [...state.bedroomImages, imageData],
          );
          break;
        case RoomType.diningRoom:
          state = state.copyWith(
            diningRoomImages: [...state.diningRoomImages, imageData],
          );
          break;
        case RoomType.officeRoom:
          state = state.copyWith(
            officeRoomImages: [...state.officeRoomImages, imageData],
          );
          break;
        case RoomType.bathroom:
          state = state.copyWith(
            bathroomImages: [...state.bathroomImages, imageData],
          );
          break;
      }
    } finally {
      // Reset loading state
      if (roomType == RoomType.livingRoom) {
        setUploadingLivingRoomImage(false);
      }
    }
  }

// Xóa hình ảnh khỏi phòng
  void removeImageFromRoom(RoomType roomType, ImageData imageData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages: state.livingRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages: state.bedroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages: state.diningRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages: state.officeRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages: state.bathroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
    }
  }

  // Xóa video khỏi phòng
  void removeVideoFromRoom(RoomType roomType, VideoData videoData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomVideos: state.livingRoomVideos
              .where((vid) => vid.publicId != videoData.publicId)
              .toList(),
        );
        break;
      // Nếu muốn mở rộng cho các loại phòng khác, thêm vào đây
      default:
        break;
    }
  }

  // Thêm video vào phòng với kiểm tra giới hạn và kích thước
  Future<void> addVideoToRoom(RoomType roomType, VideoData videoData) async {
    if (!canAddVideo(roomType)) {
      // Do not add video if maximum limit is reached
      return;
    }

    // Set loading state if roomType is livingRoom
    if (roomType == RoomType.livingRoom) {
      setUploadingLivingRoomVideo(true);
    }

    try {
      switch (roomType) {
        case RoomType.livingRoom:
          state = state.copyWith(
            livingRoomVideos: [...state.livingRoomVideos, videoData],
          );
          break;
        // If you want to support other room types for videos, add cases here
        default:
          break;
      }
    } finally {
      // Reset loading state
      if (roomType == RoomType.livingRoom) {
        setUploadingLivingRoomVideo(false);
      }
    }
  }
}

// The global provider that can be accessed in all screens
final bookingProvider = StateNotifierProvider<OrderNotifier, Booking>(
  (ref) => OrderNotifier(),
);

enum RoomType { livingRoom, bedroom, diningRoom, officeRoom, bathroom }
