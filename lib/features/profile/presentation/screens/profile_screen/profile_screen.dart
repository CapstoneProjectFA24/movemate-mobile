import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/presentation/widgets/profile/profile_header.dart';
import 'package:movemate/features/profile/presentation/widgets/profile/profile_menu.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);

    final profile = {
      'name': 'Lê An',
      'phoneNumber': '0972266784',
      'security': 'Mật khẩu và bảo mật',
      'wallet': 'Số dư',
      'imagePath': 'assets/images/profile/Image.png',
      'bgcolor': Colors.deepOrangeAccent,
      'present': 'quà tặng',
      'bill': 'Hóa Đơn',
      'center': 'Trung tâm bảo mật',
    };

    final menuItems = [
      ProfileMenu(
        icon: Icons.security,
        title: profile['security'].toString(),
        onTap: () {},
      ),
      ProfileMenu(
        icon: Icons.account_balance_wallet,
        title: profile['wallet'].toString(),
        onTap: () {
          context.router.push(const WalletScreenRoute());
        },
      ),
      ProfileMenu(
        icon: Icons.present_to_all,
        title: profile['present'].toString(),
        onTap: () {},
      ),
      ProfileMenu(
        icon: Icons.receipt_long,
        title: profile['bill'].toString(),
        onTap: () {},
      ),
      ProfileMenu(
        icon: Icons.location_on,
        title: profile['center'].toString(),
        onTap: () {},
      ),
      ProfileMenu(
        icon: Icons.logout_outlined,
        title: "Đăng xuất",
        onTap: () async {
          await ref.read(signInControllerProvider.notifier).signOut(context);
          print("oke");
        },
        color: Colors.red,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        title: "Hồ sơ",
        iconSecond: Icons.home_outlined,
        centerTitle: true,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          }
        },
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(profile: user),
            // const SizedBox(height: 24.0),
            // const PromoSection(),
            // const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Column(
                    children: [
                      ProfileMenu(
                        icon: item.icon,
                        title: item.title,
                        onTap: item.onTap,
                        color: item.color,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
