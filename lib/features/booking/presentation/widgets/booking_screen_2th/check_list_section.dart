// checklist_section.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ChecklistSection extends HookConsumerWidget {
  const ChecklistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final List<String> checklistOptions = [
      'Đóng gói đồ đạc cẩn thận',
      'Tháo rời các thiết bị điện tử',
      'Chuẩn bị giấy tờ cần thiết',
      'Liên hệ trước với dịch vụ chuyển nhà',
      'Dọn dẹp nhà cũ',
      'Kiểm tra lại đồ đạc trước khi chuyển',
      'Thông báo cho hàng xóm',
      'Sắp xếp lịch trình hợp lý',
      'Chuẩn bị đồ ăn nhẹ cho ngày chuyển nhà',
      'Kiểm tra thời tiết trước ngày chuyển',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FadeInUp(
            child: const LabelText(
              content: 'Hướng dẫn chuyển nhà',
              size: AssetsConstants.labelFontSize + 4.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: checklistOptions.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              activeColor: AssetsConstants.primaryMain,
              checkColor: AssetsConstants.whiteColor,
              value: bookingState.checklistValues[index],
              title: FadeInLeft(
                child: Text(
                  checklistOptions[index],
                  style: const TextStyle(
                    color: AssetsConstants.blackColor,
                  ),
                ),
              ),
              onChanged: (value) {
                bookingNotifier.updateChecklistValue(index, value ?? false);
              },
            );
          },
        ),
      ],
    );
  }
}
