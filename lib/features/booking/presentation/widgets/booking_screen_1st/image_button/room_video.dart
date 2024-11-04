// room_video.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:video_player/video_player.dart';

class RoomVideo extends StatefulWidget {
  final VideoData videoData;
  final RoomType roomType;
  final BookingNotifier bookingNotifier;

  const RoomVideo({
    super.key,
    required this.videoData,
    required this.roomType,
    required this.bookingNotifier,
  });

  @override
  _RoomVideoState createState() => _RoomVideoState();
}

class _RoomVideoState extends State<RoomVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoData.url)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Chiều rộng cố định
      height: 80, // Chiều cao cố định
      child: _isInitialized
          ? Stack(
              children: [
                Container(
                  width: 80, // Đảm bảo kích thước khớp với SizedBox
                  height: 80, // Đảm bảo kích thước khớp với SizedBox
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                // Nút play/pause
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Center(
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        color: Colors.white,
                        size: 24, // Kích thước nhỏ hơn phù hợp với 80x80
                      ),
                    ),
                  ),
                ),
                // Nút xóa video
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      widget.bookingNotifier.removeVideoFromRoom(
                          widget.roomType, widget.videoData);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AssetsConstants.pinkColor,
                      ),
                      child: const Icon(Icons.delete,
                          color: AssetsConstants.whiteColor,
                          size: 12), // Kích thước nhỏ hơn
                    ),
                  ),
                ),
              ],
            )
          : Container(
              width: 80, // Đảm bảo kích thước khớp với SizedBox
              height: 80, // Đảm bảo kích thước khớp với SizedBox
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
