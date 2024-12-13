import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_camera_upload_widget.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class PorterUploadedImageScreen extends HookConsumerWidget {
  final OrderEntity job;
  const PorterUploadedImageScreen({
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
    final images2 = useState<List<String>>([]);
    final imagePublicIds2 = useState<List<String>>([]);
    final images3 = useState<List<String>>([]);
    final imagePublicIds3 = useState<List<String>>([]);
    final images4 = useState<List<String>>([]);
    final imagePublicIds4 = useState<List<String>>([]);
    final images5 = useState<List<String>>([]);
    final imagePublicIds5 = useState<List<String>>([]);
    final fullScreenImage = useState<String?>(null);

    // final request = useState(PorterUpdateResourseRequest(resourceList: []));
    // final uploadedImages = ref.watch(uploadedImagesProvider);
    final bookingAsync = ref.watch(bookingStreamProvider(job.id.toString()));
    final status = useBookingStatus(bookingAsync.value, job.isReviewOnline);
    final currentJob = useState<OrderEntity>(job);

    // final jobEntity = useFetchObject<BookingResponseEntity>(
    //     function: (context) async {
    //       return ref
    //           .read(bookingControllerProvider.notifier)
    //           .getBookingById(job.id, context);
    //     },
    //     context: context);

    final currentListStaff = ref
        .watch(bookingStreamProvider(job.id.toString()))
        .value
        ?.assignments
        .toList();

    // useEffect(() {
    //   // Call refresh when component mounts
    //   jobEntity.refresh();
    //   return null; // cleanup function
    // }, []);

    // useEffect(() {
    //   JobStreamManager().updateJob(job);
    //   return null;
    // }, [bookingAsync.value]);

    // useEffect(() {
    //   final subscription = JobStreamManager().jobStream.listen((updateJob) {
    //     if (updateJob.id == job.id) {
    //       // print(
    //       //     'tuan Received updated order in PorterUploadedImage: ${updateJob.id}');
    //       currentJob.value = updateJob;
    //     }
    //   });
    //   return subscription.cancel;
    // }, [job]);

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

    // List<dynamic> getTrackerSources(
    //     BookingResponseEntity job, String trackerType) {
    //   try {
    //     final trackers =
    //         job.bookingTrackers.firstWhere((e) => e.type == trackerType);

    //     return trackers.trackerSources;
    //   } catch (e) {
    //     return [];
    //   }
    // }

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

    // final imagesSourceArrivedTesst =
    //     getTrackerSources(_bookingData.value!, "PORTER_ARRIVED");
    // print("checking lisst resource ${imagesSourceArrivedTesst.length}");
    // final imagesSourcePacking =
    //     getTrackerSourcesPorter(_bookingData.value!, "PORTER_PACKING");
    final imagesSourceArrived =
        getTrackerSources(bookingData.value!, "PORTER_ARRIVED");
    final imagesSourcePacking =
        getTrackerSources(bookingData.value!, "PORTER_PACKING");
    final imagesSourceDelivered =
        getTrackerSources(bookingData.value!, "PORTER_DELIVERED");
    final imagesSourceUnloaded =
        getTrackerSources(bookingData.value!, "PORTER_UNLOADED");
    final imagesSourceCompleted =
        getTrackerSources(bookingData.value!, "PORTER_COMPLETED");

    useEffect(() {
      if (imagesSourceArrived.isNotEmpty) {
        images1.value = imagesSourceArrived
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds1.value = imagesSourceArrived
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      if (imagesSourcePacking.isNotEmpty) {
        images2.value = imagesSourcePacking
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds2.value = imagesSourcePacking
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      if (imagesSourceDelivered.isNotEmpty) {
        images3.value = imagesSourceDelivered
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds3.value = imagesSourceDelivered
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      if (imagesSourceUnloaded.isNotEmpty) {
        images4.value = imagesSourceUnloaded
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds4.value = imagesSourceUnloaded
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      if (imagesSourceCompleted.isNotEmpty) {
        images5.value = imagesSourceCompleted
            .map((source) => source['ResourceUrl'] as String)
            .toList();

        imagePublicIds5.value = imagesSourceCompleted
            .map((source) => source['ResourceCode'] as String)
            .toList();
      }
      return null;
    }, [
      imagesSourceCompleted,
      imagesSourceUnloaded,
      imagesSourceDelivered,
      imagesSourcePacking,
      imagesSourceArrived
    ]);

    Widget buildConfirmationSection({
      required String title,
      required List<String> imagePublicIds,
      required Function(String, String) onImageUploaded,
      required Function(String) onImageRemoved,
      required Function(String) onImageTapped,
      required VoidCallback onActionPressed,
      required String actionButtonLabel,
      required IconData actionIcon,
      required bool isEnabled,
      required bool showCameraButton,
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
            const SizedBox(height: 16),
            CloudinaryCameraUploadWidget(
              disabledDelete: true,
              disabled: !isEnabled,
              imagePublicIds: imagePublicIds,
              onImageUploaded: isEnabled ? onImageUploaded : (_, __) {},
              onImageRemoved: isEnabled ? onImageRemoved : (_) {},
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
        title: "Xem hình ảnh bốc vác gửi lên",
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Orange curved background
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

          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  //case 1
                  buildConfirmationSection(
                    title: 'Xác nhận đã đến',
                    imagePublicIds: imagePublicIds1.value,
                    onImageUploaded: (url, publicId) {
                      images1.value = [...images1.value, url];
                      imagePublicIds1.value = [
                        ...imagePublicIds1.value,
                        publicId
                      ];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tải ảnh lên thành công'),
                          backgroundColor: primaryOrange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onImageRemoved: (publicId) {
                      images1.value = images1.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds1.value = imagePublicIds1.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      // request.value = PorterUpdateResourseRequest(
                      //   resourceList: request.value.resourceList
                      //       .where(
                      //           (resource) => resource.resourceCode != publicId)
                      //       .toList(),
                      // );
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    onActionPressed: () async {
                      // Xử lý khi tài xế xác nhận đã đến
                      // final List<Resource> resources1 = convertToResourceList(
                      //     images1.value, imagePublicIds1.value);

                      // final request = PorterUpdateResourseRequest(
                      //   resourceList: resources1,
                      // );

                      // await ref
                      //     .read(porterControllerProvider.notifier)
                      //     .updateStatusPorterResourse(
                      //       id: job.id,
                      //       request: request,
                      //       context: context,
                      //     );
                      // print(
                      //     "objects checking lisst 1 resource ${request.resourceList.length}");
                      bookingAsync.isRefreshing;
                    },
                    actionButtonLabel: 'Xác nhận đến',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                    // isEnabled: status.canPorterConfirmIncoming,
                    showCameraButton: true,
                    // request: request.value,
                  ),
                  const SizedBox(height: 16),
                  //-----------------------------------------------------------------
                  //case 2
                  buildConfirmationSection(
                    title: 'Xác nhận đã dọn',
                    imagePublicIds: imagePublicIds2.value,
                    onImageUploaded: (url, publicId) {
                      images2.value = [...images2.value, url];
                      imagePublicIds2.value = [
                        ...imagePublicIds2.value,
                        publicId
                      ];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tải ảnh lên thành công'),
                          backgroundColor: primaryOrange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onImageRemoved: (publicId) {
                      images2.value = images2.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds2.value = imagePublicIds2.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      // request.value = PorterUpdateResourseRequest(
                      //   resourceList: request.value.resourceList
                      //       .where(
                      //           (resource) => resource.resourceCode != publicId)
                      //       .toList(),
                      // );
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    onActionPressed: () async {
                      // Xử lý khi tài xế xác nhận đã đến
                      // final List<Resource> resources2 = convertToResourceList(
                      //     images2.value, imagePublicIds2.value);

                      // final request = PorterUpdateResourseRequest(
                      //   resourceList: resources2,
                      // );

                      // await ref
                      //     .read(porterControllerProvider.notifier)
                      //     .updateStatusPorterResourse(
                      //       id: job.id,
                      //       request: request,
                      //       context: context,
                      //     );
                      bookingAsync.isRefreshing;
                    },
                    actionButtonLabel: 'Xác nhận đóng gói',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                    // isEnabled: status.canPorterConfirmIncoming,
                    showCameraButton: true,
                    // request: request.value,
                  ),
                  const SizedBox(height: 16),
                  //-----------------------------------------------------------------
                  //case 3
                  buildConfirmationSection(
                    title: 'Xác nhận đã giao',
                    imagePublicIds: imagePublicIds3.value,
                    onImageUploaded: (url, publicId) {
                      images3.value = [...images3.value, url];
                      imagePublicIds3.value = [
                        ...imagePublicIds3.value,
                        publicId
                      ];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tải ảnh lên thành công'),
                          backgroundColor: primaryOrange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onImageRemoved: (publicId) {
                      images3.value = images3.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds3.value = imagePublicIds3.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      // request.value = PorterUpdateResourseRequest(
                      //   resourceList: request.value.resourceList
                      //       .where(
                      //           (resource) => resource.resourceCode != publicId)
                      //       .toList(),
                      // );
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    onActionPressed: () async {
                      // Xử lý khi tài xế xác nhận đã đến
                      // final List<Resource> resources3 = convertToResourceList(
                      //     images3.value, imagePublicIds3.value);
                      // final request = PorterUpdateResourseRequest(
                      //   resourceList: resources3,
                      // );

                      // await ref
                      //     .read(porterControllerProvider.notifier)
                      //     .updateStatusPorterResourse(
                      //       id: job.id,
                      //       request: request,
                      //       context: context,
                      //     );
                      bookingAsync.isRefreshing;
                    },
                    actionButtonLabel: 'Xác nhận giao hàng',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                    // isEnabled: status.canPorterConfirmIncoming,
                    showCameraButton: true,
                    // request: request.value,
                  ),
                  const SizedBox(height: 16),
                  //-----------------------------------------------------------------
                  //case 4
                  buildConfirmationSection(
                    title: 'Xác nhận dỡ hàng',
                    imagePublicIds: imagePublicIds4.value,
                    onImageUploaded: (url, publicId) {
                      images4.value = [...images4.value, url];
                      imagePublicIds4.value = [
                        ...imagePublicIds4.value,
                        publicId
                      ];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tải ảnh lên thành công'),
                          backgroundColor: primaryOrange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onImageRemoved: (publicId) {
                      images4.value = images4.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds4.value = imagePublicIds4.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      // request.value = PorterUpdateResourseRequest(
                      //   resourceList: request.value.resourceList
                      //       .where(
                      //           (resource) => resource.resourceCode != publicId)
                      //       .toList(),
                      // );
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    onActionPressed: () async {
                      // Xử lý khi tài xế xác nhận đã đến
                      // final List<Resource> resources4 = convertToResourceList(
                      //     images4.value, imagePublicIds4.value);
                      // final request = PorterUpdateResourseRequest(
                      //   resourceList: resources4,
                      // );

                      // await ref
                      //     .read(porterControllerProvider.notifier)
                      //     .updateStatusPorterResourse(
                      //       id: job.id,
                      //       request: request,
                      //       context: context,
                      //     );
                      bookingAsync.isRefreshing;
                    },
                    actionButtonLabel: 'Xác nhận dỡ hàng',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                    // isEnabled: status.canPorterConfirmIncoming,
                    showCameraButton: true,
                    // request: request.value,
                  ),
                  const SizedBox(height: 16),
                  //-----------------------------------------------------------------
                  //case 5
                  buildConfirmationSection(
                    title: 'Xác nhận hoàn thành',
                    imagePublicIds: imagePublicIds5.value,
                    onImageUploaded: (url, publicId) {
                      images5.value = [...images5.value, url];
                      imagePublicIds5.value = [
                        ...imagePublicIds5.value,
                        publicId
                      ];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tải ảnh lên thành công'),
                          backgroundColor: primaryOrange,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    onImageRemoved: (publicId) {
                      images5.value = images5.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds5.value = imagePublicIds5.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      // request.value = PorterUpdateResourseRequest(
                      //   resourceList: request.value.resourceList
                      //       .where(
                      //           (resource) => resource.resourceCode != publicId)
                      //       .toList(),
                      // );
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    onActionPressed: () async {
                      // Xử lý khi tài xế xác nhận đã đến
                      // final List<Resource> resources5 = convertToResourceList(
                      //     images5.value, imagePublicIds5.value);
                      // final request = PorterUpdateResourseRequest(
                      //   resourceList: resources5,
                      // );

                      // await ref
                      //     .read(porterControllerProvider.notifier)
                      //     .updateStatusPorterResourse(
                      //       id: job.id,
                      //       request: request,
                      //       context: context,
                      //     );
                      bookingAsync.isRefreshing;
                    },
                    actionButtonLabel: 'Xác nhận hoàn thành',
                    actionIcon: Icons.location_on,
                    isEnabled: true,
                    showCameraButton: true,
                    // request: request.value,
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       saveImagesAndNavigate();
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: primaryOrange,
                  //       foregroundColor: Colors.white,
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 24, vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Xác nhận',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),

          // Full screen image viewer
          if (fullScreenImage.value != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => fullScreenImage.value = null,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          fullScreenImage.value!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => fullScreenImage.value = null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
