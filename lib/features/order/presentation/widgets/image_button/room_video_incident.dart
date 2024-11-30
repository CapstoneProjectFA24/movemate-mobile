// room_video.dart
import 'package:flutter/material.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/order_provider.dart';

class RoomVideoIncident extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  final VideoData videoData;
  final RoomType roomType;

  const RoomVideoIncident({
    super.key,
    required this.videoData,
    required this.roomType,
  });

  @override
  _RoomVideoState createState() => _RoomVideoState();
}

class _RoomVideoState extends ConsumerState<RoomVideoIncident> {
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
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return SizedBox(
      width: 80, // Fixed width
      height: 80, // Fixed height
      child: _isInitialized
          ? Stack(
              children: [
                Container(
                  width: 80, // Ensure size matches SizedBox
                  height: 80, // Ensure size matches SizedBox
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
                // Play/Pause button
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
                        size: 24, // Suitable size for 80x80
                      ),
                    ),
                  ),
                ),
                // Delete video button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      bookingNotifier.removeVideoFromRoom(
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
                          size: 12), // Smaller size
                    ),
                  ),
                ),
              ],
            )
          : Container(
              width: 80, // Ensure size matches SizedBox
              height: 80, // Ensure size matches SizedBox
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
