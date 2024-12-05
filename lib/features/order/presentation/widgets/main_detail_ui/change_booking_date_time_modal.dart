import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:intl/intl.dart';
import 'package:movemate/features/order/data/models/request/change_booking_at_request.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangeBookingDateTimeModal extends HookConsumerWidget {
  final int bookingId;
  final DateTime initialDate;
  final Function(DateTime) onDateTimeChanged;

  const ChangeBookingDateTimeModal({
    super.key,
    required this.initialDate,
    required this.onDateTimeChanged,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng useState để quản lý trạng thái
    final selectedDateTime = useState(initialDate);
    final currentDateTime = DateTime.now();
    final errorText = useState<String?>(null);

    final chanegBookingAtRequest = useState<ChangeBookingAtRequest?>(null);

    // Kiểm tra tính hợp lệ của thời gian
    // void checkTimeValidity(DateTime dateTime) {
    //   if (dateTime.isBefore(DateTime.now())) {
    //     errorText.value = "Không được chọn thời gian quá khứ";
    //   } else {
    //     errorText.value = null;
    //   }
    // }

    void checkTimeValidity(DateTime dateTime) {
      if (dateTime.isBefore(DateTime.now())) {
        errorText.value = "Không được chọn thời gian quá khứ";
      } else if (dateTime.hour < 7 || dateTime.hour >= 17) {
        errorText.value = "Thời gian phải từ 7h đến 17h";
      } else {
        errorText.value = null;
      }
    }

    // Kiểm tra ngay khi build để đảm bảo trạng thái ban đầu hợp lệ
    useEffect(() {
      checkTimeValidity(selectedDateTime.value);
      return null;
    }, [selectedDateTime.value]);

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Thay đổi ngày dọn nhà',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.orangeAccent),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Hiển thị date picker và kiểm tra lại thời gian sau khi chọn ngày
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (pickedDate != null) {
                      selectedDateTime.value = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        selectedDateTime.value.hour,
                        selectedDateTime.value.minute,
                      );
                      checkTimeValidity(selectedDateTime.value);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ngày',
                      ),
                      controller: TextEditingController(
                        text: DateFormat('dd-MM-yyyy')
                            .format(selectedDateTime.value),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final currentHour = currentDateTime.hour;
                    final currentMinute = currentDateTime.minute;

                    final minTime =
                        (selectedDateTime.value.day == currentDateTime.day)
                            ? TimeOfDay(
                                hour: currentHour + 1, minute: currentMinute)
                            : const TimeOfDay(hour: 0, minute: 0);

                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(selectedDateTime.value),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            alwaysUse24HourFormat: true,
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime != null) {
                      selectedDateTime.value = DateTime(
                        selectedDateTime.value.year,
                        selectedDateTime.value.month,
                        selectedDateTime.value.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      checkTimeValidity(selectedDateTime.value);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Giờ',
                      ),
                      controller: TextEditingController(
                        text:
                            DateFormat('HH:mm').format(selectedDateTime.value),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Hiển thị thông báo lỗi dưới trường ngày/giờ
          if (errorText.value != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText.value!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                "Lưu ý:\n ",
                style: TextStyle(
                  color: Color.fromARGB(255, 77, 77, 77),
                  fontSize: 11,
                ),
              ),
              Text(
                " chỉ có thể thay đổi thời gian dọn nhà 1 lần. \n Hãy cân nhắc trước khi đổi.",
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const LabelText(
            content: 'Hủy',
            size: 14,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.orangeAccent),
          ),
          onPressed: (errorText.value ==
                  null) // Nút "Lưu" chỉ hoạt động khi không có lỗi
              ? () async {
                  onDateTimeChanged(selectedDateTime.value);

                  // Định dạng lại DateTime theo định dạng ISO8601 với 'Z'
                  chanegBookingAtRequest.value = ChangeBookingAtRequest(
                    bookingAt: selectedDateTime.value.toIso8601String(),
                  );

                  print("checking date time ${selectedDateTime.value} ");
                  print(
                      "checking date time 2 ${chanegBookingAtRequest.value?.bookingAt.toString()} ");

                  final res = await ref
                      .read(orderControllerProvider.notifier)
                      .changeBookingAt(
                        chanegBookingAtRequest.value as ChangeBookingAtRequest,
                        context,
                        bookingId,
                      );
                  Navigator.of(context).pop();
                }
              : null, // Nếu có lỗi thì vô hiệu hóa nút
          child: const LabelText(
            content: 'Lưu',
            size: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
