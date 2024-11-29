import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/fee_system/services_fee_system_controller.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/data/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

import 'ServiceFeeWidget.dart';

@RoutePage()
class SystemFeeScreen extends HookConsumerWidget {
  const SystemFeeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final state = ref.watch(servicesFeeSystemControllerProvider);

    final fetchResult = useFetch<ServicesFeeSystemEntity>(
      function: (model, context) => ref
          .read(servicesFeeSystemControllerProvider.notifier)
          .getFeeSystems(model, context),
      initialPagingModel: PagingModel(
          // per_page: 20,
          ),
      context: context,
    );

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          buildFeeList(
            context: context,
            state: state,
            fetchResult: fetchResult,
            bookingNotifier: bookingNotifier,
            bookingState: bookingState,
          ),
        ],
      ),
    );
  }

  Widget buildFeeList({
    required BuildContext context,
    required dynamic state,
    required dynamic fetchResult,
    required BookingNotifier bookingNotifier,
    required Booking bookingState,
  }) {
    if (state.isLoading && fetchResult.items.isEmpty) {
      return const Center(child: HomeShimmer(amount: 4));
    }
    if (fetchResult.items.isEmpty) {
      return const Align(
        alignment: Alignment.topCenter,
        child: EmptyBox(title: 'Không có dịch vụ nào'),
      );
    }
    // Trong phương thức buildFeeList
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fetchResult.items.length + 1,
      itemBuilder: (context, index) {
        if (index == fetchResult.items.length) {
          if (fetchResult.isFetchingData) {
            return const CustomCircular();
          }
          return fetchResult.isLastPage ? const SizedBox.shrink() : Container();
        }
        final fee = fetchResult.items[index] as ServicesFeeSystemEntity;

        // Lấy số lượng hiện tại từ bookingState
        final currentQuantity = bookingState.servicesFeeList
                .firstWhere(
                  (item) => item.id == fee.id,
                  orElse: () => fee.copyWith(quantity: 0),
                )
                .quantity ??
            0;

        return ServiceFeeWidget(
          serviceFee: fee,
          quantity: currentQuantity,
          onQuantityChanged: (newQuantity) {
            // Cập nhật số lượng trong bookingNotifier
            bookingNotifier.updateServicesFeeQuantity(fee, newQuantity);
          },
        );
      },
    );
  }
}
