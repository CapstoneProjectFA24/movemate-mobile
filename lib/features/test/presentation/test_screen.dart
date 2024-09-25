import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/test/data/models/house_model.dart';
import 'package:movemate/features/test/presentation/test_controller.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class TestScreen extends HookConsumerWidget {
  const TestScreen({super.key});

  Future<void> fetchData({
    required GetDataType getDatatype,
    required WidgetRef ref,
    required BuildContext context,
    required ValueNotifier<bool> isLoadMoreLoading,
    required ValueNotifier<List<HouseModel>> orders,
    required ValueNotifier<bool> isFetchingData,
    required String? filterSystemContent,
    required String? filterPartnerContent,
    required String? orderDateFrom,
    required String? orderDateTo,
  }) async {
    if (getDatatype == GetDataType.loadmore && isFetchingData.value) {
      return;
    }

    if (getDatatype == GetDataType.fetchdata) {
      isLoadMoreLoading.value = false;
    }

    isFetchingData.value = true;
    final ordersData =
        await ref.read(testControllerProvider.notifier).getHouses(
              context,
            );

    if (getDatatype == GetDataType.fetchdata) {
      isLoadMoreLoading.value = true;
      orders.value = ordersData;
      isFetchingData.value = false;
      print("Fetched orders (fetchData): ${orders.value}"); // Log data here
      return;
    }

    isFetchingData.value = false;
    orders.value = orders.value + ordersData;
    print("Loaded more orders (loadmore): ${orders.value}"); // Log data here
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ValueNotifiers for handling state
    final isLoadMoreLoading = useState(false);
    final isFetchingData = useState(false);
    final orders = useState<List<HouseModel>>([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Fetch data and log
                await fetchData(
                  getDatatype: GetDataType.fetchdata,
                  ref: ref,
                  context: context,
                  isLoadMoreLoading: isLoadMoreLoading,
                  orders: orders,
                  isFetchingData: isFetchingData,
                  filterSystemContent: null,
                  filterPartnerContent: null,
                  orderDateFrom: null,
                  orderDateTo: null,
                );
              },
              child: const Text("Fetch Data"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Load more data and log
                await fetchData(
                  getDatatype: GetDataType.loadmore,
                  ref: ref,
                  context: context,
                  isLoadMoreLoading: isLoadMoreLoading,
                  orders: orders,
                  isFetchingData: isFetchingData,
                  filterSystemContent: null,
                  filterPartnerContent: null,
                  orderDateFrom: null,
                  orderDateTo: null,
                );
              },
              child: const Text("Load More Data"),
            ),
            // Display orders count
            if (orders.value.isNotEmpty)
              Text("Number of houses fetched: ${orders.value.length}"),
          ],
        ),
      ),
    );
  }
}
