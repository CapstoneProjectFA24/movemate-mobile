import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class CancelDialog extends StatefulWidget {
  final void Function(String? reason) onReasonSelected;
  final void Function() onCancelPressed;

  const CancelDialog({
    super.key,
    required this.onReasonSelected,
    required this.onCancelPressed,
  });

  @override
  State<CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return
    
     AlertDialog(
      backgroundColor: Colors.white,
      title: const LabelText(
        size: 16,
        content: 'Vui lòng chọn lý do hủy đơn hàng',
        fontWeight: FontWeight.w500,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LabelText(
            size: 12,
            color: Colors.grey,
            content:
                'Lưu ý: Thao tác này sẽ hủy tất cả dịch vụ có trong đơn hàng và không thể hoàn tác.',
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 10),
          buildReasonOptions(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const LabelText(
            size: 14,
            content: 'Hủy',
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onReasonSelected(_selectedReason);
            widget.onCancelPressed();
          },
          child: const LabelText(
            size: 14,
            content: 'Xác nhận',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  
  
  }

  Widget buildReasonOptions() {
    return Column(
      children: [
        buildReasonOption(
          'Muốn thay đổi dịch vụ trong đơn hàng',
          'Muốn thay đổi dịch vụ trong đơn hàng',
        ),
        buildReasonOption(
          'Thủ tục thanh toán quá rắc rối',
          'Thủ tục thanh toán quá rắc rối',
        ),
        buildReasonOption(
          'Tìm thấy giá rẻ hơn ở chỗ khác',
          'Tìm thấy giá rẻ hơn ở chỗ khác',
        ),
        buildReasonOption(
          'Đổi ý không muốn đặt dịch vụ nữa',
          'Đổi ý không muốn đặt dịch vụ nữa',
        ),
        buildReasonOption(
          'Lý do khác',
          'Lý do khác',
        ),
      ],
    );
  }

  Widget buildReasonOption(String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      title: LabelText(
        size: 12,
        content: title,
        fontWeight: FontWeight.w400,
      ),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedReason,
        onChanged: (value) {
          setState(() {
            _selectedReason = value;
          });
          widget.onReasonSelected(value);
        },
        activeColor: Colors.orange,
      ),
    );
  }


}
