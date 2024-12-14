// File: driver_confirm_upload.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/configs/routes/app_router.dart';

import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_camera_upload_widget.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class DriverUploadedImageScreen extends HookConsumerWidget {
  final OrderEntity job;

  const DriverUploadedImageScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Color constants
    const primaryOrange = Color(0xFFFF6B00);
    const secondaryOrange = Color(0xFFFFE5D6);
    const darkGrey = Color(0xFF4A4A4A);
    const disabledGrey = Color(0xFFE0E0E0);

    // Image states
    final images1 = useState<List<String>>([]);
    final imagePublicIds1 = useState<List<String>>([]);

    final images3 = useState<List<String>>([]);
    final imagePublicIds3 = useState<List<String>>([]);

    final fullScreenImage = useState<String?>(null);
    // final request = useState(UpdateResourseRequest(resourceList: []));
    // final uploadedImages = ref.watch(uploadedImagesProvider);
    final bookingAsync = ref.watch(bookingStreamProvider(job.id.toString()));
    final status = useBookingStatus(bookingAsync.value, job.isReviewOnline);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final bookingData = useState<Map<String, dynamic>?>(null);

    Future<void> getBookingData() async {
      try {
        final data = await firestore
            .collection('bookings')
            .doc(job.id.toString())
            .get()
            .then((doc) => doc.data());
        bookingData.value = data;
      } catch (e) {
        print("Error getting Firestore data: $e");
      }
    }

    useEffect(() {
      getBookingData();
      return null;
    }, []);

    if (bookingData.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<dynamic> getTrackerSources(
        Map<String, dynamic> bookingData, String trackerType) {
      try {
        final trackers = bookingData["BookingTrackers"]
            ?.firstWhere((e) => e["Type"] == trackerType);

        return trackers['TrackerSources'];
      } catch (e) {
        return [];
      }
    }

    final imagesSourceArrived =
        getTrackerSources(bookingData.value!, "DRIVER_ARRIVED");
    final imagesSourceCompleted =
        getTrackerSources(bookingData.value!, "DRIVER_COMPLETED");

    useEffect(() {
      if (imagesSourceArrived.isNotEmpty) {
        images1.value = imagesSourceArrived
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds1.value = imagesSourceArrived
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      if (imagesSourceCompleted.isNotEmpty) {
        images3.value = imagesSourceCompleted
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds3.value = imagesSourceCompleted
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      return null;
    }, [imagesSourceArrived, imagesSourceCompleted]);

    Widget buildConfirmationSection({
      required String title,
      required List<String> imagePublicIds,
      required Function(String, String) onImageUploaded,
      required Function(String) onImageRemoved,
      required Function(String) onImageTapped,
      required String actionButtonLabel,
      required IconData actionIcon,
      required bool isEnabled,

      // required UpdateResourseRequest request,
    }) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: primaryOrange,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGrey,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: secondaryOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${imagePublicIds.length} ảnh',
                    style: const TextStyle(
                      color: primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 16),
            CloudinaryCameraUploadWidget(
              disabled: true,
              disabledDelete: true,
              imagePublicIds: imagePublicIds,
              onImageUploaded: (_, __) {},
              onImageRemoved: (_) {},
              onImageTapped: onImageTapped,
              showCameraButton: false,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        backgroundColor: primaryOrange,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Xem hình ảnh tài xế gửi lên",
        showBackButton: true,
      ),
      body: Stack(
        children: [
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: primaryOrange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  //case 1:
                  buildConfirmationSection(
                    title: imagesSourceArrived.isNotEmpty
                        ? 'Đã xác nhận'
                        : 'Xác nhận đã đến',
                    imagePublicIds: imagePublicIds1.value,
                    onImageUploaded: (url, publicId) {
                      images1.value = [...images1.value, url];
                      imagePublicIds1.value = [
                        ...imagePublicIds1.value,
                        publicId
                      ];
                      print(
                          'onUplaoded success ${imagePublicIds1.value..length}');
                    },
                    onImageRemoved: (publicId) {
                      // print("onImageRemoved called for publicId: $publicId");
                      // Cập nhật danh sách hình ảnh
                      images1.value = images1.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds1.value = imagePublicIds1.value
                          .where((id) => id != publicId)
                          .toList();

                      // Kiểm tra sau khi xóa
                      // print(
                      //     "checking resource list after removal: ${request.value.resourceList.length}");
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    actionButtonLabel: 'Xác nhận đến',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                  ),
                  const SizedBox(height: 16),
                  //case 3
                  buildConfirmationSection(
                    title: imagesSourceCompleted.isNotEmpty
                        ? 'Đã hoàn tất giao hàng'
                        : 'Xác nhận giao hàng',
                    imagePublicIds: imagePublicIds3.value,
                    onImageUploaded: (url, publicId) {
                      images3.value = [...images3.value, url];
                      imagePublicIds3.value = [
                        ...imagePublicIds3.value,
                        publicId
                      ];
                    },
                    onImageRemoved: (publicId) {
                      images3.value = images3.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds3.value = imagePublicIds3.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    actionButtonLabel: 'Xác nhận giao hàng',
                    actionIcon: Icons.check_circle,
                    isEnabled: true,
                  ),
                ],
              ),
            ),
          ),
          // Full screen image viewer
          // if (fullScreenImage.value != null)
          //   Positioned.fill(
          //     child: GestureDetector(
          //       onTap: () => fullScreenImage.value = null,
          //       child: Container(
          //         color: Colors.black.withOpacity(0.9),
          //         child: Stack(
          //           children: [
          //             Center(
          //               child: Image.network(
          //                 fullScreenImage.value!,
          //                 fit: BoxFit.contain,
          //               ),
          //             ),
          //             Positioned(
          //               top: 40,
          //               right: 16,
          //               child: IconButton(
          //                 icon: const Icon(
          //                   Icons.close,
          //                   color: Colors.white,
          //                   size: 30,
          //                 ),
          //                 onPressed: () => fullScreenImage.value = null,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
  
}


