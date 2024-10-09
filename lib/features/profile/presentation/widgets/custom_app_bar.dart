import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

/// Must implement [PreferredSizeWidget]
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? backButtonColor;
  final Color? backgroundColor;
  final bool? centerTitle;
  final VoidCallback? onCallBackFirst;
  final VoidCallback? onCallBackSecond;
  final IconData? iconFirst;
  final IconData? iconSecond;
  final bool showBackButton;
  final PreferredSize? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.backButtonColor = AssetsConstants.blackColor,
    this.centerTitle = false,
    this.backgroundColor = AssetsConstants.mainColor,
    this.onCallBackFirst,
    this.onCallBackSecond,
    this.iconFirst,
    this.iconSecond,
    this.showBackButton = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: backButtonColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều các icon
        children: [
          // Icon đầu tiên (bên trái)
          if (iconFirst != null)
            IconButton(
              onPressed: onCallBackFirst,
              icon: Icon(
                iconFirst,
                color: AssetsConstants.whiteColor,
              ),
            ),
          // Tiêu đề (ở giữa)
          Expanded(
            child: Center(
              child: LabelText(
                content: title ?? 'AppBar',
                size: AssetsConstants.defaultFontSize - 8.0,
                color: AssetsConstants.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Icon thứ hai (bên phải)
          if (iconSecond != null)
            IconButton(
              onPressed: onCallBackSecond,
              icon: Icon(
                iconSecond,
                color: AssetsConstants.whiteColor,
              ),
            ),
        ],
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
