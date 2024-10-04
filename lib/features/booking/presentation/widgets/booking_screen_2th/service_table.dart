import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:movemate/features/booking/domain/entities/package_entities.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceTable extends HookConsumerWidget {
  final int packageIndex;
  final Package package;
  final bool isExpanded;
  final ValueChanged<bool> onToggleExpanded;

  const ServiceTable({
    super.key,
    required this.packageIndex,
    required this.package,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Column(
      children: [
        GestureDetector(
          onTap: () => onToggleExpanded(!isExpanded),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelText(
                  content: package.title,
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: AssetsConstants.blackColor,
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: package.services.asMap().entries.map((entry) {
                final serviceIndex = entry.key;
                final service = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.name,
                                style: const TextStyle(fontSize: 14)),
                            Text('${service.price}đ',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      ServiceTrailingWidget(
                        quantity: service.quantity,
                        addService: false,
                        onQuantityChanged: (newQuantity) {
                          bookingNotifier.updateQuantity(
                            packageIndex,
                            serviceIndex,
                            newQuantity,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
