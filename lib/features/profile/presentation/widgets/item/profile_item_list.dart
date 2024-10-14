import 'package:flutter/material.dart';
import 'package:movemate/features/profile/presentation/widgets/item/profile_items.dart'; // Import ProfileItem từ file profile_item.dart

// Hàm để xây dựng các hàng profile
Widget buildProfileRow(ProfileItem item) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(item.icon, color: item.color),
              const SizedBox(width: 8.0),
              Text(
                item.title,
                style: TextStyle(fontSize: 16, color: item.color),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: item.color),
        ],
      ),
      Divider(color: Colors.grey[300]),
      const SizedBox(height: 8.0),
    ],
  );
}

class ProfileItemList extends StatelessWidget {
  final List<ProfileItem> profileItems = [
    ProfileItem(icon: Icons.security, title: "Bảo mật"),
    ProfileItem(icon: Icons.account_balance_wallet, title: "Ví tiền"),
    ProfileItem(icon: Icons.present_to_all, title: "Quà tặng"),
    ProfileItem(icon: Icons.receipt_long, title: "Hóa đơn"),
    ProfileItem(icon: Icons.location_on, title: "Trung tâm bảo mật"),
    ProfileItem(
        icon: Icons.logout_outlined, title: "Đăng xuất", color: Colors.red),
  ];

  ProfileItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                profileItems.map((item) => buildProfileRow(item)).toList(),
          ),
        ),
      ],
    );
  }
}
