// CustomTimePickerDialog widget
import 'package:flutter/material.dart';

class CustomTimePickerDialog extends StatelessWidget {
  final TimeOfDay initialTime;
  final TimeOfDay currentTime;
  final bool isToday;

  const CustomTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.currentTime,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       timePickerTheme: TimePickerThemeData(
      //         hourMinuteColor: WidgetStateColor.resolveWith((states) {
      //           final time = TimeOfDay(
      //             hour: int.tryParse(states.first.toString()) ?? initialTime.hour,
      //             minute: initialTime.minute,
      //           );
      //           if (isToday) {
      //             if (time.hour < currentTime.hour ||
      //                 (time.hour == currentTime.hour && time.minute <= currentTime.minute)) {
      //               return Colors.grey.withOpacity(0.3);
      //             }
      //           }
      //           return Theme.of(context).colorScheme.primary.withOpacity(0.2);
      //         }),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );
  }
}
