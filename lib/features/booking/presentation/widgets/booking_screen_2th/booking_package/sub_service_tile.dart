import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class SubServiceTile extends ConsumerWidget {
  final SubServiceEntity subService;

  const SubServiceTile({super.key, required this.subService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    final currentSubService = bookingState.selectedSubServices.firstWhere(
      (s) => s.id == subService.id,
      orElse: () => subService.copyWith(quantity: 0),
    );

    final int quantity = currentSubService.quantity ?? 0;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: LabelText(
          content: subService.name,
          size: 16,
          fontWeight: FontWeight.w400,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            subService.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: ServiceTrailingWidget(
          quantity: quantity,
          addService: !subService.isQuantity,
          quantityMax: subService.quantityMax,
          onQuantityChanged: (newQuantity) {
            bookingNotifier.updateSubServiceQuantity(subService, newQuantity);
            bookingNotifier.calculateAndUpdateTotalPrice();
          },
        ),
      ),
    );
  }
}
