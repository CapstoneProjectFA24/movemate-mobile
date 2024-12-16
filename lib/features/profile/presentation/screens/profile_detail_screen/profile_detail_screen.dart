import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/presentation/widgets/details/profile_info.dart';
import 'package:movemate/features/profile/presentation/widgets/details/profile_status.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/utils/providers/common_provider.dart';

@RoutePage()
class ProfileDetailScreen extends HookConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);

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
    Future<String> getAddressFromLatLng(Position position) async {
      const apiKey = APIConstants.apiVietMapKey;
      final double latitude = position.latitude;
      final double longitude = position.longitude;

      final String url =
          'https://maps.vietmap.vn/api/reverse/v3?apikey=$apiKey&lat=$latitude&lng=$longitude';
      print("url vietma $url");
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            // Lấy thông tin từ boundaries
            List<dynamic> boundaries = data[0]['boundaries'];
            String district = "";
            String city = "";

            // print('get position lat ${position.latitude}');
            // print('get position long${position.longitude}');
            // print('1 check data  ${data.toString()}');
            for (var boundary in boundaries) {
              if (boundary['type'] == 1) {
                district = boundary['name']; // Lấy tên Quận/Huyện
              } else if (boundary['type'] == 0) {
                city = boundary['name']; // Lấy tên Thành Phố
              }
            }

            return "$district, $city";
          } else {
            return "Không tìm thấy địa chỉ";
          }
        } else {
          return "Lỗi khi gọi API: ${response.statusCode}";
        }
      } catch (e) {
        return "Không thể lấy địa chỉ: $e";
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        showBackButton: true,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Trang cá nhân của tôi",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            // Pop back to the TabViewScreen
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Picture
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.avatarUrl
                              .toString() ??
                          'https://storage.googleapis.com/a1aa/image/tYEQXye9fdnxoUhSmM0BNG3N43SB0eCaJKQ3wWsBBo12mmJnA.jpg'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const FaIcon(
                          FontAwesomeIcons.checkCircle,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    ),
                    // const FaIcon(
                    //   FontAwesomeIcons.edit,
                    //   color: Colors.grey,
                    // ),
                  ],
                ),
                // const SizedBox(height: 20),
                // Status
                // Center(
                //   child: Container(
                //     padding:
                //         const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFE0F7E0),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: const Text(
                //       'Đã xác thực',
                //       style: TextStyle(
                //         color: Color(0xFF4CAF50),
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Personal Info Section
                // Section(
                //   title: 'Thông tin cá nhân',
                //   onEditPressed: () {
                //     context.router.push(
                //         const InfoScreenRoute()); // Điều hướng đến trang Info
                //   },
                //   children: const [
                //     InfoRow(label: 'Tên thân mật', value: 'Vinh '),
                //     InfoRow(label: 'Tên thật', value: 'Vinh Nguyễn'),
                //     InfoRow(label: 'Giới tính', value: 'Nam'),
                //     InfoRow(label: 'CMND/CCCD', value: '077123456789'),
                //     InfoRow(label: 'Sống tại', value: 'TP. Hồ Chí Minh'),
                //   ],
                // ),
                const SizedBox(height: 20),

                // Contact Info Section
                Section(
                  title: 'Thông tin liên hệ',
                  onEditPressed: () {
                    // context.router.push(const ContactScreenRoute());
                  },
                  children: [
                    InfoRow(label: 'Số điện thoại', value: '${user.phone}'),
                    InfoRow(label: 'Gmail', value: user.email),

                    //  InfoRow(
                    //     label: 'Địa chỉ',
                    //     value: 'currentAddress'),

                    // Updated FutureBuilder with return statement
                    FutureBuilder<String>(
                      future: getCurrentPosition()
                          .then((position) => getAddressFromLatLng(position)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const InfoRow(
                            label: 'Địa chỉ',
                            value: 'Đang lấy vị trí...',
                          );
                        } else if (snapshot.hasError) {
                          return const InfoRow(
                            label: 'Địa chỉ',
                            value: 'Không thể lấy địa chỉ',
                          );
                        } else if (snapshot.hasData) {
                          return InfoRow(
                            label: 'Địa chỉ',
                            value: snapshot.data!,
                          );
                        } else {
                          return const InfoRow(
                            label: 'Địa chỉ',
                            value: 'Địa chỉ không xác định',
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Logout Button
                ElevatedButton(
                  onPressed: () {
                    // Handle logout action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: AssetsConstants.primaryMain,
                    minimumSize: const Size(double.infinity,
                        50), // Chiều ngang dài ra toàn màn hình, chiều cao 50
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
