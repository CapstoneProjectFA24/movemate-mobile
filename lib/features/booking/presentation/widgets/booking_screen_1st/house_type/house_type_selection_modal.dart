// house_type_selection_modal.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import HouseTypeController

import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/house_type/house_type_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/selection_modal.dart';
// Hooks
import 'package:movemate/hooks/use_fetch.dart';

// Import your entities and widgets
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

// Hooks

import 'package:flutter_hooks/flutter_hooks.dart';

//extension
import 'package:movemate/utils/extensions/scroll_controller.dart';

class HouseTypeSelectionModal extends HookConsumerWidget {
  const HouseTypeSelectionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider); // Watch the booking state
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final scrollController = useScrollController();
    final state = ref.watch(houseTypeControllerProvider);

    final fetchResult = useFetch<HouseTypeEntity>(
      function: (model, context) => ref
          .read(houseTypeControllerProvider.notifier)
          .getHouseTypes(model, context),
      initialPagingModel: PagingModel(),
      context: context,
    );
    // useEffect(() {
    //   scrollController.onScrollEndsListener(fetchResult.loadMore);
    //   return scrollController.dispose;
    // }, const []);
    useEffect(() {
      scrollController.onScrollEndsListener(fetchResult.loadMore);
      return null; 
    }, const []);

    if (state.isLoading && fetchResult.items.isEmpty) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (state.hasError) {
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
      final houseTypeEntities = fetchResult.items;
      final houseTypes = houseTypeEntities.map((e) => e.name).toList();

      return SelectionModal(
        title: 'Chọn loại nhà ở',
        items: houseTypes,
        onItemSelected: (selectedItem) {
          // Tìm đối tượng HouseTypeEntity được chọn
          final selectedHouseType = houseTypeEntities.firstWhere(
            (e) => e.name == selectedItem,
          );
          // Cập nhật trạng thái
          bookingNotifier.updateHouseType(selectedHouseType);
          Navigator.pop(context);
        },
      );
    }
  }
}
