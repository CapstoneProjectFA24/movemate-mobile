import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_entities.dart';
import 'package:movemate/features/booking/presentation/controller/booking_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/booking/presentation/widget_controller/booking_item_widget.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class BookingScreenV2 extends HookConsumerWidget {
  const BookingScreenV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init
    final testState = ref.watch(bookingControllerProvider);
    final bookings = useState<List<BookingEntities>>([]);
    final isFetchingData = useState(true);
    final pageNumber = useState(0);
    final isLastPage = useState(false);
    final isLoadMoreLoading = useState(false);

    // Fetch data function
    Future<void> fetchData({
      required GetDataType getDataType,
    }) async {
      if (getDataType == GetDataType.loadmore && isFetchingData.value) {
        return;
      }

      if (getDataType == GetDataType.fetchdata) {
        pageNumber.value = 0;
        isLastPage.value = false;
        isLoadMoreLoading.value = false;
      }

      if (isLastPage.value) {
        return;
      }

      isFetchingData.value = true;
      pageNumber.value = pageNumber.value + 1;

      final newBookings = await ref
          .read(bookingControllerProvider.notifier)
          .getBookings(context);

      isLastPage.value = newBookings.length < 10;
      if (getDataType == GetDataType.fetchdata) {
        isLoadMoreLoading.value = true;
        bookings.value = newBookings;
        isFetchingData.value = false;
        return;
      }

      isFetchingData.value = false;
      bookings.value = [...bookings.value, ...newBookings];
    }

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
        child: testState.when(
          data: (data) => Column(
            children: [
              ElevatedButton(
                onPressed: () => fetchData(getDataType: GetDataType.fetchdata),
                child: const Text("Fetch Data"),
              ),
              ElevatedButton(
                onPressed: () => fetchData(getDataType: GetDataType.loadmore),
                child: const Text("Load More Data"),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text("Test map"),
              ),
              if (bookings.value.isNotEmpty)
                Text("Number of bookings fetched: ${bookings.value.length}"),
              Expanded(
                child: ListView.builder(
                  itemCount: bookings.value.length,
                  itemBuilder: (context, index) {
                    final booking = bookings.value[index];
                    return BookingItemWidget(booking: booking);
                  },
                ),
              ),
              if (!isLoadMoreLoading.value)
                const CircularProgressIndicator(), // Display when loading more
              // if (isLastPage.value)
              // const Text('No more content'), // Indicate no more data
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}
