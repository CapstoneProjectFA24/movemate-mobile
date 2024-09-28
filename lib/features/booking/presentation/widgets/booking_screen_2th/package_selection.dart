import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/add_button_service.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_table.dart';

class PackageSelection extends ConsumerWidget {
  const PackageSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServiceTable(
          packageIndex: 0,
          package: bookingState.packages[0],
          isExpanded: bookingState.isHandlingExpanded,
          onToggleExpanded: (value) => bookingNotifier.toggleHandlingExpanded(),
        ),
        const SizedBox(height: 12),
        ServiceTable(
          packageIndex: 1,
          package: bookingState.packages[1],
          isExpanded: bookingState.isDisassemblyExpanded,
          onToggleExpanded: (value) =>
              bookingNotifier.toggleDisassemblyExpanded(),
        ),
        const SizedBox(height: 12),
        AddButtonService(
          title: 'Phí chờ',
          price: '60.000đ',
          icon: Icons.access_time,
          addService: true,
          quantity: bookingState.additionalServiceQuantities[0],
          onQuantityChanged: (newQuantity) {
            bookingNotifier.updateAdditionalServiceQuantity(0, newQuantity);
          },
          imagePath: "assets/images/booking/infor/homeiconsvg.png",
        ),
        AddButtonService(
          title: 'Hỗ trợ tài xế',
          price: '10.000đ',
          icon: Icons.local_shipping,
          addService: false,
          quantity: bookingState.additionalServiceQuantities[1],
          onQuantityChanged: (newQuantity) {
            bookingNotifier.updateAdditionalServiceQuantity(1, newQuantity);
          },
          imagePath: "assets/images/booking/infor/homeiconsvg.png",
        ),
        AddButtonService(
          title: 'Chứng từ điện tử',
          price: '5.000đ',
          icon: Icons.receipt_long,
          addService: false,
          quantity: bookingState.additionalServiceQuantities[2],
          onQuantityChanged: (newQuantity) {
            bookingNotifier.updateAdditionalServiceQuantity(2, newQuantity);
          },
          imagePath: "assets/images/booking/infor/homeiconsvg.png",
        ),
      ],
    );
  }
}
