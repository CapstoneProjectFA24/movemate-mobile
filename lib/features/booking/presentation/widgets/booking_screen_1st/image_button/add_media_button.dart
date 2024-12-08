// lib/features/booking/presentation/widgets/booking_screen_1st/image_button/add_media_button.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:photo_manager/photo_manager.dart';

class AddMediaButton extends ConsumerStatefulWidget {
  final RoomType roomType;
  final bool hasMedia;

  const AddMediaButton({
    super.key,
    required this.roomType,
    required this.hasMedia,
  });

  @override
  _AddMediaButtonState createState() => _AddMediaButtonState();
}

class _AddMediaButtonState extends ConsumerState<AddMediaButton> {
  // Danh sách các media được chọn
  List<AssetEntity> selectedMedia = [];

  @override
  Widget build(BuildContext context) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    // Kiểm tra trạng thái upload
    final isUploading = widget.roomType == RoomType.livingRoom
        ? bookingState.isUploadingLivingRoomImage ||
            bookingState.isUploadingLivingRoomVideo
        : false;

    return SizedBox(
      width: 100,
      height: 50,
      child: isUploading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : GestureDetector(
              onTap: () {
                _showMediaSelectionModal(context, bookingNotifier);
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DottedBorder(
                  color: AssetsConstants.greyColor,
                  strokeWidth: 2,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [8, 4],
                  child: Center(
                    child: widget.hasMedia
                        ? const Icon(Icons.add,
                            color: AssetsConstants.greyColor)
                        : const Text(
                            'Thêm media',
                            style: TextStyle(color: AssetsConstants.greyColor),
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  void _showMediaSelectionModal(
      BuildContext context, BookingNotifier bookingNotifier) async {
    // Yêu cầu quyền truy cập media
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      // Nếu không cấp quyền, thông báo cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng cấp quyền truy cập thư viện media.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Lấy danh sách media từ thư viện
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image | RequestType.video,
      hasAll: true,
    );

    AssetPathEntity allAlbum = albums.firstWhere((album) => album.isAll);
    List<AssetEntity> mediaList =
        await allAlbum.getAssetListPaged(page: 0, size: 1000);

    // Loại bỏ các media trùng lặp
    mediaList = mediaList.toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Để kiểm soát chiều cao
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6, // Chiếm 60% chiều cao màn hình
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
              return Column(
                children: [
                  // Tiêu đề
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Chọn Media',
                      style: TextStyle(
                        fontSize: AssetsConstants.buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Danh sách media
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1,
                      ),
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        final asset = mediaList[index];
                        return GestureDetector(
                          onTap: () {
                            setStateModal(() {
                              if (selectedMedia.contains(asset)) {
                                selectedMedia.remove(asset);
                              } else {
                                selectedMedia.add(asset);
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: FutureBuilder<Uint8List?>(
                                  future: asset.thumbnailDataWithSize(
                                    const ThumbnailSize(200, 200),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: asset.type == AssetType.video
                                            ? const Center(
                                                child: Icon(Icons.videocam,
                                                    color: Colors.grey))
                                            : const Center(
                                                child: Icon(Icons.image,
                                                    color: Colors.grey)),
                                      );
                                    }
                                  },
                                ),
                              ),
                              if (asset.type == AssetType.video)
                                const Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Icon(
                                    Icons.videocam,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              if (selectedMedia.contains(asset))
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black45,
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.greenAccent,
                                      size: 30,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Nút xác nhận
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: selectedMedia.isNotEmpty
                          ? () async {
                              Navigator.pop(context);
                              await _uploadSelectedMedia(
                                  selectedMedia, bookingNotifier, context);
                              setStateModal(() {
                                selectedMedia.clear(); // Reset danh sách chọn
                              });
                            }
                          : null,
                      child: const Text('Thêm vào'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _uploadSelectedMedia(List<AssetEntity> media,
      BookingNotifier bookingNotifier, BuildContext context) async {
    for (var asset in media) {
      if (asset.type == AssetType.image) {
        await _handleImageUpload(asset, bookingNotifier, context);
      } else if (asset.type == AssetType.video) {
        await _handleVideoUpload(asset, bookingNotifier, context);
      }
    }
  }

  Future<void> _handleImageUpload(AssetEntity asset,
      BookingNotifier bookingNotifier, BuildContext context) async {
    if (widget.roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomImage(true);
    }

    try {
      final File? file = await asset.file;
      if (file == null) return;

      final cloudinary =
          CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false);
      final CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: 'movemate/images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      final imageData = ImageData(
        url: response.secureUrl,
        publicId: response.publicId,
      );
      await bookingNotifier.addImageToRoom(widget.roomType, imageData);
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải lên hình ảnh')),
      );
    } finally {
      if (widget.roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomImage(false);
      }
    }
  }

  Future<void> _handleVideoUpload(AssetEntity asset,
      BookingNotifier bookingNotifier, BuildContext context) async {
    if (widget.roomType == RoomType.livingRoom) {
      bookingNotifier.setUploadingLivingRoomVideo(true);
    }

    try {
      final File? file = await asset.file;
      if (file == null) return;

      // Kiểm tra kích thước video
      final int fileSize = await file.length();
      if (fileSize > BookingNotifier.maxVideoSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dung lượng video không được vượt quá 25 MB.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final cloudinary =
          CloudinaryPublic('dkpnkjnxs', 'movemate', cache: false);
      final CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: 'movemate/videos',
          resourceType: CloudinaryResourceType.Video,
        ),
      );
      final videoData = VideoData(
        url: response.secureUrl,
        publicId: response.publicId,
        size: fileSize,
      );
      await bookingNotifier.addVideoToRoom(widget.roomType, videoData);
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải lên video')),
      );
    } finally {
      if (widget.roomType == RoomType.livingRoom) {
        bookingNotifier.setUploadingLivingRoomVideo(false);
      }
    }
  }
}
