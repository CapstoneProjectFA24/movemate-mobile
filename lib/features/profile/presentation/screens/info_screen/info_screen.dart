import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/presentation/widgets/input/custom_text.dart';
import 'package:movemate/features/profile/presentation/widgets/input/input_item.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class InfoScreen extends HookConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> formData = [
      {
        'label': 'Tên thân mật',
        'value': 'Dang Hung',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'Bạn đang sống tại',
        'value': 'TP.Hồ Chí Minh',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'Sinh nhật',
        'value': '20/08/2001',
        'icon': FontAwesomeIcons.users,
      },
      {
        'label': 'Giới tính',
        'value': 'Nam',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'CMND/CCCD',
        'value': '077123456789',
        'icon': FontAwesomeIcons.users,
      },
      {
        'label': 'Nghề nghiệp',
        'value': 'Chọn nghề nghiệp của bạn',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'Sở thích',
        'value': 'Chọn sở thích của bạn',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'Học vấn',
        'value': 'Chọn học vấn của bạn',
        'icon': FontAwesomeIcons.globe,
      },
      {
        'label': 'Quê quán',
        'value': 'Chọn quê quán của bạn',
        'icon': FontAwesomeIcons.globe,
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        showBackButton: true,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Thông tin cá nhân",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: formData.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: FormGroup(
                    label: field['label'],
                    icon: field['icon'],
                    child: CustomTextField(
                      value: field['value'],
                      onChanged: (newValue) {
                        // Xử lý khi giá trị thay đổi
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
