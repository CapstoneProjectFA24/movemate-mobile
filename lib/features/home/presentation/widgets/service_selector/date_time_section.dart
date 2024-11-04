import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class DateTimeSection extends StatelessWidget {
  final TextEditingController controller;
  final bool showErrors;
  final bool isDateTimeInvalid;
  final VoidCallback onTap;

  const DateTimeSection({
    required this.controller,
    required this.showErrors,
    required this.isDateTimeInvalid,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FadeInUp(
            child: const LabelText(
              content: 'Ngày và giờ',
              size: 16,
              fontFamily: 'bold',
              color: AssetsConstants.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: AbsorbPointer(
                child: FadeInRight(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AssetsConstants.whiteColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showErrors &&
                                  (controller.text == 'Chọn ngày - giờ' ||
                                      isDateTimeInvalid)
                              ? Colors.red
                              : AssetsConstants.primaryMain,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: showErrors &&
                                  (controller.text == 'Chọn ngày - giờ' ||
                                      isDateTimeInvalid)
                              ? Colors.red
                              : AssetsConstants.primaryMain,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: AssetsConstants.blackColor),
                  ),
                ),
              ),
            ),
            if (showErrors &&
                (controller.text == 'Chọn ngày - giờ' || isDateTimeInvalid))
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: LabelText(
                  content: isDateTimeInvalid
                      ? 'Không được là thời gian trong quá khứ'
                      : 'Vui lòng chọn thời gian thích hợp',
                  size: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
