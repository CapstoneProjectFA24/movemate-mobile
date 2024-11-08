import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class DateTimeSection extends StatefulWidget {
  final TextEditingController controller;
  final bool showErrors;
  final bool isDateTimeInvalid;
  final VoidCallback onTap;
  final VoidCallback onClear; // Thêm callback onClear
  final FocusNode focusNode;

  const DateTimeSection({
    required this.controller,
    required this.showErrors,
    required this.isDateTimeInvalid,
    required this.onTap,
    required this.onClear, // Thêm vào constructor
    required this.focusNode,
    super.key,
  });

  @override
  State<DateTimeSection> createState() => _DateTimeSectionState();
}

class _DateTimeSectionState extends State<DateTimeSection> {
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
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: true, // Ngăn người dùng nhập liệu trực tiếp
          onTap: widget.onTap, // Gọi hàm chọn ngày giờ khi nhấn vào trường
          decoration: InputDecoration(
            filled: true,
            fillColor: AssetsConstants.whiteColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.showErrors &&
                        (widget.controller.text == 'Chọn ngày - giờ' ||
                            widget.isDateTimeInvalid)
                    ? Colors.red
                    : AssetsConstants.primaryMain,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.showErrors &&
                        (widget.controller.text == 'Chọn ngày - giờ' ||
                            widget.isDateTimeInvalid)
                    ? Colors.red
                    : AssetsConstants.primaryMain,
              ),
            ),
            suffixIcon: widget.controller.text != 'Chọn ngày - giờ'
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: AssetsConstants.greyColor,
                    ),
                    onPressed: () {
                      widget.onClear(); // Gọi callback onClear
                    },
                  )
                : const Icon(
                    Icons.calendar_today,
                    color: AssetsConstants.greyColor,
                  ),
          ),
          style: const TextStyle(color: AssetsConstants.blackColor),
        ),
        if (widget.showErrors &&
            (widget.controller.text == 'Chọn ngày - giờ' ||
                widget.isDateTimeInvalid))
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: LabelText(
              content: widget.isDateTimeInvalid
                  ? 'Không được là thời gian trong quá khứ'
                  : 'Vui lòng chọn thời gian thích hợp',
              size: 12,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
