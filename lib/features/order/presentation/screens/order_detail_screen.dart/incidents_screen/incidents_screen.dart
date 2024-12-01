import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/resource.dart';
import 'package:movemate/features/order/data/models/request/incident_request.dart';
import 'package:movemate/features/order/presentation/provider/order_provider.dart';
import 'package:movemate/features/order/presentation/widgets/image_button/room_media_section_incident.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_camera_upload_widget.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_upload_widget.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import '../../../../../../utils/commons/widgets/widgets_common_export.dart';
@RoutePage()

class IncidentsScreen extends HookConsumerWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportType = useState<String?>(null);
    final orderIdController = useTextEditingController();
    final descriptionController = useTextEditingController();
    // Track which tab is active (Request Support or Sent Request)
    final request = useState(IncidentRequest(resourceList: []));

    final isRequestSent = useState<bool>(false);
    final images = useState<List<String>>([]);
    final fullScreenImage = useState<String?>(null);

    print("tuan checking 1 ${images.toString()}");

    final imagePublicIds = useState<List<String>>(
      images.value.map((url) {
        final uri = Uri.parse(url);
        final pathSegments = uri.pathSegments;
        return pathSegments.length > 1
            ? '${pathSegments[pathSegments.length - 2]}/${pathSegments.last.split('.').first}'
            : '';
      }).toList(),
    );

    List<String> supportTypes = [
      'Vấn đề về tài khoản',
      'Kỹ thuật',
      'Đặt hàng',
      'Giao hàng',
      'Thanh toán',
      'Bảo hành',
      'Hủy đơn hàng',
      'Khác'
    ];

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Báo cáo sự cố",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          } else {
            context.router.pushAndPopUntil(
              const TabViewScreenRoute(children: [
                HomeScreenRoute(),
              ]),
              predicate: (route) => false,
            );
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab selection
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRequestSent.value
                              ? Colors.grey[200]
                              : AssetsConstants.primaryLight,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          isRequestSent.value =
                              false; // Switch to "Yêu cầu hỗ trợ"
                        },
                        child: LabelText(
                          content: 'Yêu cầu hỗ trợ',
                          size: 14,
                          color: isRequestSent.value
                              ? AssetsConstants.greyColor.shade600
                              : AssetsConstants.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRequestSent.value
                              ? AssetsConstants.primaryLight
                              : Colors.grey[200],
                          iconColor: Colors.grey[700],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          isRequestSent.value =
                              true; // Switch to "Yêu cầu đã gửi"
                        },
                        child: LabelText(
                          content: 'Yêu cầu đã gửi',
                          size: 14,
                          color: isRequestSent.value
                              ? AssetsConstants.whiteColor
                              : AssetsConstants.greyColor.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Common form fields (support type, order ID, description)
                const Text('Loại hỗ trợ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: supportType.value,
                  onChanged: isRequestSent.value
                      ? null // Disable editing for "Yêu cầu đã gửi"
                      : (value) {
                          supportType.value = value;
                        },
                  items: supportTypes
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    hintText: "Chọn loại hỗ trợ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Mã đơn hàng',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: orderIdController,
                  enabled: !isRequestSent
                      .value, // Disable editing for "Yêu cầu đã gửi"
                  decoration: InputDecoration(
                    hintText: 'Ví dụ: 9485376960606',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng nhập mã đơn hàng đối với những yêu cầu liên quan đến đơn hàng của bạn',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),

                const Text('Mô tả',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: descriptionController,
                  enabled: !isRequestSent
                      .value, // Disable editing for "Yêu cầu đã gửi"
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Nhập mô tả',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Add image/video (read-only in "Yêu cầu đã gửi" tab)
                const Text('Thêm hình ảnh',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),

                buildConfirmationSection(
                    // title: 'Thêm hình ảnh',
                    imagePublicIds: imagePublicIds.value,
                    onImageUploaded: (url, publicId) {
                      images.value = [...images.value, url];
                      imagePublicIds.value = [
                        ...imagePublicIds.value,
                        publicId
                      ];
                    },
                    onImageRemoved: (publicId) {
                      // Xóa URL ảnh và publicId từ danh sách images và imagePublicIds
                      images.value = images.value
                          .where((url) => !url.contains(publicId))
                          .toList();
                      imagePublicIds.value = imagePublicIds.value
                          .where((id) => id != publicId)
                          .toList();

                      // Cập nhật lại resourceList trong IncidentRequest
                      request.value.resourceList =
                          request.value.resourceList.where((resource) {
                        // Loại bỏ resource có publicId tương ứng
                        return resource.resourceCode != publicId;
                      }).toList();
                    },
                    onImageTapped: (url) => fullScreenImage.value = url,
                    actionIcon: Icons.location_on,
                    isEnabled: !isRequestSent.value,
                    showCameraButton: true,
                    request: request.value),
                const SizedBox(height: 16),

                const Text('Dung lượng không vượt quá 5Mb',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                // GestureDetector(
                //   onTap: isRequestSent.value
                //       ? null // Disable tap in "Yêu cầu đã gửi" tab
                //       : () {},
                //   child: Container(
                //     height: 120,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey[300]!, width: 1.5),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Center(
                //       child: FaIcon(FontAwesomeIcons.plus,
                //           color: Colors.grey[400], size: 30),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                // const Text('Thêm video',
                //     style: TextStyle(
                //         color: Colors.black, fontWeight: FontWeight.bold)),
                // const Text('Dung lượng không vượt quá 5Mb',
                //     style: TextStyle(color: Colors.grey, fontSize: 12)),
                // GestureDetector(
                //   onTap: isRequestSent.value
                //       ? null // Disable tap in "Yêu cầu đã gửi" tab
                //       : () {},
                //   child: Container(
                //     height: 120,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey[300]!, width: 1.5),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Center(
                //       child: FaIcon(FontAwesomeIcons.plus,
                //           color: Colors.grey[400], size: 30),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),

                // Show "Send Request" button only for "Yêu cầu hỗ trợ"
                if (!isRequestSent.value)
                  SizedBox(
                    width: double.infinity, // Chiều ngang toàn màn hình
                    child: ElevatedButton(
                      onPressed: () {
                        print(
                            "tuan checking ${request.value.resourceList.toString()}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: AssetsConstants.defaultBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Bo góc
                        ),
                      ),
                      child: const LabelText(
                        content: 'Gửi yêu cầu',
                        size: 16,
                        fontWeight: FontWeight.bold,
                        color: AssetsConstants.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConfirmationSection({
    // required String title,
    required List<String> imagePublicIds,
    required Function(String, String) onImageUploaded,
    required Function(String) onImageRemoved,
    required Function(String) onImageTapped,
    required IconData actionIcon,
    required bool isEnabled,
    required bool showCameraButton,
    required IncidentRequest request,
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
          // Row(
          //   children: [
          //     Container(
          //       width: 4,
          //       height: 24,
          //       decoration: const BoxDecoration(
          //         color: Colors.orange,
          //         borderRadius: BorderRadius.all(Radius.circular(2)),
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     Expanded(
          //       child: Text(
          //         title,
          //         style: const TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //       decoration: BoxDecoration(
          //         color: Colors.orangeAccent,
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Text(
          //         '${imagePublicIds.length} ảnh',
          //         style: const TextStyle(
          //           color: Colors.orangeAccent,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 14,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          CloudinaryCameraUploadWidget(
              disabled: !isEnabled,
              imagePublicIds: imagePublicIds,
              onImageUploaded: isEnabled
                  ? (url, publicId) {
                      // Add the uploaded image URL and public ID to the lists
                      onImageUploaded(url, publicId);
                      // Create Resource for the uploaded image
                      final newResource = Resource(
                        type: 'image', // Or dynamically determine the type
                        resourceUrl: url,
                        resourceCode: publicId, // Or generate unique code
                      );
                      // Add the Resource to the request's resourceList
                      request.resourceList.add(newResource);
                    }
                  : (_, __) {},
              onImageRemoved: isEnabled ? onImageRemoved : (_) {},
              onImageTapped: onImageTapped,
              showCameraButton: showCameraButton,
              onUploadComplete: (resource) {
                request.resourceList.add(resource);
              }),
        ],
      ),
    );
  }
}
