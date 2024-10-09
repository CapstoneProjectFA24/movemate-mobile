import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/presentation/widgets/custom_app_bar.dart';
import 'package:movemate/features/profile/presentation/widgets/details/profile_info.dart';
import 'package:movemate/features/profile/presentation/widgets/details/profile_status.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ProfileDetailScreen extends HookConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        iconFirst: Icons.chevron_left,
        onCallBackFirst: () {
          // Hành động khi nhấn vào icon
          Navigator.pop(context); // Quay lại trang trước
        },
        title: "Trang cá nhân của tôi",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          // Hành động khi nhấn vào icon
          Navigator.pushNamed(context, '/home'); // Điều hướng đến trang Home
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
                const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://storage.googleapis.com/a1aa/image/tYEQXye9fdnxoUhSmM0BNG3N43SB0eCaJKQ3wWsBBo12mmJnA.jpg'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lê An',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        FaIcon(
                          FontAwesomeIcons.checkCircle,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    ),
                    FaIcon(
                      FontAwesomeIcons.edit,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Status
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Đã xác thực',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Personal Info Section
                Section(
                  title: 'Thông tin cá nhân',
                  onEditPressed: () {
                    context.router.push(
                        const InfoScreenRoute()); // Điều hướng đến trang Info
                  },
                  children: const [
                    InfoRow(label: 'Tên thân mật', value: 'Lê An'),
                    InfoRow(label: 'Tên thật', value: 'Lê An'),
                    InfoRow(label: 'Giới tính', value: 'Nữ'),
                    InfoRow(label: 'CMND/CCCD', value: '077123456789'),
                    InfoRow(label: 'Sống tại', value: 'TP. Hồ Chí Minh'),
                  ],
                ),
                const SizedBox(height: 20),
                // Contact Info Section
                Section(
                  title: 'Thông tin liên hệ',
                  onEditPressed: () {
                    context.router.push(const ContactScreenRoute());
                  },
                  children: const [
                    InfoRow(label: 'Số điện thoại', value: '08999123456'),
                    InfoRow(label: 'Gmail', value: '19521234@gm.uit.edu.vn'),
                    InfoRow(
                        label: 'Địa chỉ',
                        value: 'Quận 9, Thành phố Hồ Chí Minh'),
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
