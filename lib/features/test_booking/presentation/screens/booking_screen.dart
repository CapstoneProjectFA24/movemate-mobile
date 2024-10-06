import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/features/test_booking/domain/entities/booking_entities.dart';
import 'package:movemate/features/test_booking/presentation/screens/booking_controller.dart';
import 'package:movemate/features/test_booking/presentation/widget_controller/booking_item_widget.dart';

@RoutePage()
class BookingScreenV2 extends HookConsumerWidget {
  const BookingScreenV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize scroll controller
    final scrollController = useScrollController();
    final state = ref.watch(bookingControllerProvider);

    // Fetch bookings using useFetch hook
    final fetchResultBooking = useFetch<BookingEntities>(
      function: (pagingModel, context) =>
          ref.read(bookingControllerProvider.notifier).getBookings(context),
      initialPagingModel: PagingModel(pageNumber: 1),
      context: context,
    );

    // Set up infinite scrolling
    useEffect(() {
      scrollController.onScrollEndsListener(fetchResultBooking.loadMore);
      return scrollController.dispose; // No clean-up function needed
    }, const []);

    // UI
    return Scaffold(
      appBar: AppBar(
        title: const LabelText(
          content: 'Bookings',
          size: 20,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: (state.isLoading && fetchResultBooking.items.isEmpty)
            ? const CircularProgressIndicator()
            : fetchResultBooking.items.isEmpty
                ? Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                      onPressed: fetchResultBooking.refresh,
                      child: const Text("Fetch Data"),
                    ),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: fetchResultBooking.refresh,
                        child: const Text("Fetch Data"),
                      ),
                      ElevatedButton(
                        onPressed: fetchResultBooking.loadMore,
                        child: const Text("Load More Data"),
                      ),
                      if (fetchResultBooking.items.isNotEmpty)
                        Text(
                            "Number of bookings fetched: ${fetchResultBooking.items.length}"),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: fetchResultBooking.items.length + 1,
                          // (fetchResultBooking.loadMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < fetchResultBooking.items.length) {
                              final booking = fetchResultBooking.items[index];
                              return BookingItemWidget(booking: booking);
                            } else if (fetchResultBooking.isFetchingData) {
                              // Show loading indicator at the bottom
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
