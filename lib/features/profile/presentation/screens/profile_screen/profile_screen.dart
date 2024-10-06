import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/profile/presentation/widgets/section.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1463E5),
        elevation: 0,
        title: const Text(
          'Tài khoản',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const ProfileSection(),
          // const VerificationSection(),
          Container(
            margin: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Expanded(
                  child: Section(
                    icon: Icons.qr_code_scanner,
                    title: 'Quản lý mã',
                    subtitle: 'Quản lý các mã QR quan trọng',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Section(
                    icon: Icons.card_membership,
                    title: 'Zalopay Priority',
                    subtitle: 'Thành viên',
                    iconColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          _buildSection('Ưu đãi', [
            MenuItem(
                icon: Icons.card_giftcard,
                title: 'Quà của tôi',
                subtitle: '0 ưu đãi'),
            MenuItem(icon: Icons.star, title: 'Xu tích lũy', subtitle: '0 xu'),
          ]),
          _buildSection('Quản lý tài chính', [
            const MenuItem(
                icon: Icons.account_balance_wallet, title: 'Nguồn tiền'),
            const BalanceItem(
              icon: 'assets/zalopay_icon.png',
              title: 'Ví Zalopay',
              balance: '318đ',
            ),
            const MenuItem(
              icon: Icons.payments,
              title: 'Cài đặt thanh toán tự động',
              subtitle: 'Sắp xếp nguồn tiền, cài đặt dịch vụ',
            ),
            const MenuItem(
                icon: Icons.verified_user, title: 'Điểm tin cậy ZaloPay'),
          ]),
          _buildSection('Tiện ích', [
            const MenuItem(icon: Icons.receipt_long, title: 'Quản lý hóa đơn'),
            const MenuItem(icon: Icons.description, title: 'Quản lý hợp đồng'),
            const MenuItem(
                icon: Icons.confirmation_number, title: 'Quản lý vé'),
          ]),
          _buildSection('Hỗ trợ và Cài đặt', [
            const MenuItem(icon: Icons.headset_mic, title: 'Trung tâm hỗ trợ'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/profile/Image.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Vinh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '038 2703625',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class VerificationSection extends StatelessWidget {
  const VerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: Colors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Thêm hồ sơ mở ví',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Theo quy định, bạn cần cung cấp thông tin cá nhân để tiếp...',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Xác thực ngay'),
          ),
        ],
      ),
    );
  }
}

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAccessItem(
              icon: Icons.qr_code_scanner,
              title: 'Quản lý mã',
              subtitle: 'Quản lý các mã QR quan trọng',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickAccessItem(
              icon: Icons.card_membership,
              title: 'Zalopay Priority',
              subtitle: 'Thành viên',
              iconColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = Colors.blue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class BalanceItem extends StatelessWidget {
  final String icon;
  final String title;
  final String balance;

  const BalanceItem({
    super.key,
    required this.icon,
    required this.title,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(icon, width: 24, height: 24),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            balance,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.visibility),
        ],
      ),
    );
  }
}
