// house_type_selection_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import HouseTypeController

import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/house_type/house_type_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/selection_modal.dart';

// Import your entities and widgets
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

class HouseTypeSelectionModal extends HookConsumerWidget {
  final BookingNotifier bookingNotifier;

  const HouseTypeSelectionModal({super.key, required this.bookingNotifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houseTypeFuture = useMemoized(() => ref
        .read(houseTypeControllerProvider.notifier)
        .getHouseTypes(PagingModel(), context));
    final snapshot = useFuture(houseTypeFuture);

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (snapshot.hasError) {
      return AlertDialog(
        title: const Text('Lỗi'),
        content: const Text('Không thể tải loại nhà ở'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          )
        ],
      );
    } else {
      final houseTypeEntities = snapshot.data ?? [];
      final houseTypes = houseTypeEntities.map((e) => e.name).toList();

      return SelectionModal(
        title: 'Chọn loại nhà ở',
        items: houseTypes,
        onItemSelected: (selectedItem) {
          bookingNotifier.updateHouseType(selectedItem);
          Navigator.pop(context);
        },
      );
    }
  }
}
