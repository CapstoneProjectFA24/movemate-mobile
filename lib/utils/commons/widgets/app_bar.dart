import 'package:flutter/material.dart';
import '../../constants/asset_constant.dart';
import 'widgets_common_export.dart';

/// must implement [PreferredSizeWidget]
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
  final Color? iconFirstColor; // Optional color for the first icon
  final Color?
      iconFirstBackgroundColor; // Optional background color for the first icon

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
    this.iconFirstColor, // Initialize optional color
    this.iconFirstBackgroundColor, // Initialize optional background color
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: backButtonColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCallBackFirst != null) {
                  onCallBackFirst!();
                }
              },
            )
          : null,
      iconTheme: IconThemeData(
        color: backButtonColor,
      ),
      title: LabelText(
        content: title ?? 'AppBar',
        size: AssetsConstants.defaultFontSize - 8.0,
        color: AssetsConstants.whiteColor,
        fontWeight: FontWeight.w600,
      ),
      actions: [
        if (iconFirst != null)
          IconButton(
            onPressed: onCallBackFirst,

            icon: Icon(
              iconFirst,
              color: iconFirstColor ??
                  AssetsConstants
                      .whiteColor, // Use provided color or default to white
            ),
            // Optional background color for the first icon
            splashColor: iconFirstBackgroundColor ?? Colors.transparent,
            highlightColor: iconFirstBackgroundColor ?? Colors.transparent,
          ),
        if (iconSecond != null)
          IconButton(
            onPressed: onCallBackSecond,
            icon: Icon(
              iconSecond,
              color: AssetsConstants.whiteColor,
            ),
          ),
      ],
      bottom: bottom,
    );
  }

  @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
