import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ButtonCustom extends StatelessWidget {
  final bool isButtonEnabled; // Trạng thái button (enable/disable)

  final VoidCallback onButtonPressed; // Hành động khi button được nhấn
  final String buttonText; // Nội dung của button
  final Color buttonColor; // Màu sắc của button khi enabled
  final Color disabledButtonColor; // Màu sắc của button khi disabled
  final double buttonFontSize; // Kích thước font chữ của button
  final double buttonHeight; // Chiều cao của button

  const ButtonCustom({
    super.key,
    required this.isButtonEnabled,
    required this.onButtonPressed,
    this.buttonText = 'Tiếp tục', // Nội dung mặc định của button
    this.buttonColor =
        AssetsConstants.primaryMain, // Màu sắc mặc định của button
    this.disabledButtonColor =
        AssetsConstants.greyColor, // Màu sắc mặc định khi disabled
    this.buttonFontSize = 16.0, // Kích thước font chữ mặc định của button
    this.buttonHeight = 55.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts height to fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: buttonHeight, // Chiều cao của button
              child: ElevatedButton(
                onPressed: isButtonEnabled ? onButtonPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled ? buttonColor : disabledButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: LabelText(
                  content: buttonText,
                  size: buttonFontSize, // Kích thước font chữ của button
                  color: Colors.white, // Màu chữ của button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
