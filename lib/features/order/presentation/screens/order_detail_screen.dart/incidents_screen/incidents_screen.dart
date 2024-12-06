import 'dart:convert';
import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/resource.dart';
import 'package:movemate/features/order/data/models/request/incident_request.dart';
import 'package:movemate/features/order/data/models/request/user_report_request.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/utils/commons/widgets/cloudinary/cloudinary_camera_upload_widget.dart';
import 'package:movemate/utils/commons/widgets/text_input_format_price/text_input_format_price.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import '../../../../../../utils/commons/widgets/widgets_common_export.dart';

@RoutePage()
class IncidentsScreen extends HookConsumerWidget {
  final OrderEntity order;
  const IncidentsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportType = useState<String?>(null);
    final state = ref.watch(orderControllerProvider);
    final orderIdController =
        useTextEditingController(text: order.id.toString());
    final descriptionController = useTextEditingController();
    final reasonController = useTextEditingController();
    final estimatedAmountController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    // Track which tab is active (Request Support or Sent Request)
    final request = useState(IncidentRequest(resourceList: []));
    final reason = useState<String>('');
    final description = useState<String>('');
    final title = useState<String>('');
    final estimatedAmount = useState<double?>(0.0);
    final location = useState<String?>('');
    final point = useState<String?>('');

    final userReportRequest =
        useState(UserReportRequest(bookingId: order.id, resourceList: []));

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
      'Bảo hành',
      'Vỡ hàng',
    ];

//////////////////////

    // Hàm để lấy vị trí hiện tại
    Future<Position> getCurrentPosition() async {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Không có quyền truy cập vị trí");
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }

    // Hàm để gọi Reverse Geocoding API của VietMap
    Future<Map<String, dynamic>> getAddressFromLatLng(Position position) async {
      const apiKey = APIConstants.apiVietMapKey;
      final double latitude = position.latitude;
      final double longitude = position.longitude;

      final String url =
          'https://maps.vietmap.vn/api/reverse/v3?apikey=$apiKey&lat=$latitude&lng=$longitude';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            // Lấy thông tin từ boundaries
            String display = data[0]['display'];
            return {'display': display, 'position': position};
          } else {
            return {'display': "Không tìm thấy địa chỉ", 'position': position};
          }
        } else {
          return {
            'display': "Lỗi khi gọi API: ${response.statusCode}",
            'position': position
          };
        }
      } catch (e) {
        return {'display': "Không thể lấy địa chỉ: $e", 'position': position};
      }
    }

    void handleAmountInput(String value) {
      String cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      int parsedValue = int.tryParse(cleanedValue) ?? 0;

      if (parsedValue < 10000) {
        errorMessage.value = "Giá phải lớn hơn 10,000 đ";
      } else {
        errorMessage.value = null;
      }

      estimatedAmountController.text =
          NumberFormat("#,###", "vi_VN").format(parsedValue);
      estimatedAmountController.selection = TextSelection.collapsed(
          offset: estimatedAmountController.text.length);
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Common form fields (support type, order ID, description)
                  const Text('Loại hỗ trợ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: supportType.value,
                    onChanged: isRequestSent.value
                        ? null // Disable editing for "Yêu cầu đã gửi"
                        : (value) {
                            supportType.value = value;
                            title.value =
                                value ?? ''; // Lưu giá trị vào `title`
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
                    enabled: isRequestSent
                        .value, // Disable editing for "Yêu cầu đã gửi"
                    decoration: InputDecoration(
                      hintText: orderIdController.toString(),
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

                  const Text('Số tiền hỗ trợ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 10, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: estimatedAmountController,
                            textAlign: TextAlign.right,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true), // Allow decimal input
                            inputFormatters: [
                              CurrencyTextInputFormatter(),
                            ],
                            onChanged:
                                handleAmountInput, // Call this method to format and limit the input
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('đ', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  // Error Message (if any)
                  if (errorMessage.value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage.value!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  const Text('Mô tả',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    // enabled: isRequestSent
                    //     .value, // Disable editing for "Yêu cầu đã gửi"
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

                  const Text('Lý do ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: reasonController,
                    // enabled: isRequestSent
                    //     .value, // Disable editing for "Yêu cầu đã gửi"
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Nhập lý do ',
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

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity, // Chiều ngang toàn màn hình
                    child: ElevatedButton(
                      onPressed: () async {
                        description.value = descriptionController.text;
                        reason.value = reasonController.text;

                        // Convert the text from the controller to a double value
                        estimatedAmount.value = double.tryParse(
                                estimatedAmountController.text.replaceAll(
                                    RegExp(r'[^0-9.]'),
                                    '') // Remove non-numeric characters
                                ) ??
                            0;
                        final estimatedAmountText = estimatedAmountController
                            .text
                            .replaceAll(RegExp(r'[^0-9]'), '');

                        final amount =
                            double.tryParse(estimatedAmountText) ?? 0.0;
                        print('object tuan checking userReportRequest $amount');
                        // Get the current position first
                        Position currentPosition = await getCurrentPosition();

                        // Fetch the address and position info
                        var addressInfo =
                            await getAddressFromLatLng(currentPosition);

                        // Now we have both the display address and position
                        String? displayAddress = addressInfo['display'];
                        Position position = addressInfo['position'];

                        // Create the UserReportRequest using the display address and position
                        userReportRequest.value = UserReportRequest(
                          bookingId: order.id,
                          resourceList: request.value.resourceList,
                          location: displayAddress,
                          point: "${position.latitude}, ${position.longitude}",
                          description: description.value,
                          title: title.value,
                          reason: reason.value,
                          estimatedAmount: amount,
                          isInsurance: order.isInsurance,
                        );
                        print(
                            "tuan checking userReportRequest${userReportRequest.value.toString()}");
                        await ref
                            .read(orderControllerProvider.notifier)
                            .postUserReport(
                                userReportRequest.value, context, order.id);
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
