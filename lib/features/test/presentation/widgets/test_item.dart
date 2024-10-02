import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/test/domain/entities/house_entities.dart';
import '../../../../../configs/routes/app_router.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/constants/asset_constant.dart';


// gpt nhá generate UI =))
class TestItem extends HookConsumerWidget {
  const TestItem({
    Key? key,
    required this.test,
    required this.onCallback,
  }) : super(key: key);

  final HouseEntities test;
  final VoidCallback onCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(AssetsConstants.defaultPadding - 12.0),
      margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        border: Border.all(color: AssetsConstants.subtitleColor),
        borderRadius: BorderRadius.circular(AssetsConstants.defaultBorder),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Điều hướng đến màn hình chi tiết nếu cần
              // context.router.push(TestDetailScreenRoute(testId: test.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelText(
                            content: test.name,
                            size: AssetsConstants.defaultFontSize - 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          LabelText(
                            content: test.description,
                            size: AssetsConstants.defaultFontSize - 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    // CustomLabelStatus(
                    //   width: size.width * 0.22,
                    //   height: size.height * 0.035,
                    //   content: test.status, // Giả sử có trường status
                    //   size: AssetsConstants.defaultFontSize - 18.0,
                    //   backgroundColor: Colors.blue, // Màu mặc định
                    //   contentColor: Colors.white,
                    // ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  width: size.width * 1,
                  height: 1,
                  color: AssetsConstants.subtitleColor,
                ),
                SizedBox(height: size.height * 0.01),
                // Thêm các thông tin chi tiết khác của test item ở đây
              ],
            ),
          ),
          // Thêm các nút hoặc hành động khác nếu cần
          CustomButton(
            isOutline: true,
            size: AssetsConstants.defaultFontSize - 14.0,
            content: 'Chi tiết'.toUpperCase(),
            onCallback: onCallback,
            isActive: true,
            width: size.width * 1,
            height: size.height * 0.04,
            backgroundColor: AssetsConstants.whiteColor,
            contentColor: AssetsConstants.mainColor,
          ),
          SizedBox(height: size.height * 0.005),
        ],
      ),
    );
  }
}