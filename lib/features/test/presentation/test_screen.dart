import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/test/domain/entities/house_entities.dart';
import 'package:movemate/features/test/presentation/test_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class TestScreen extends HookConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init
    final testState = ref.watch(testControllerProvider);
    final houses = useState<List<HouseEntities>>([]);
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

      final newHouses =
          await ref.read(testControllerProvider.notifier).getHouses(context);

      isLastPage.value = newHouses.length < 10;
      if (getDataType == GetDataType.fetchdata) {
        isLoadMoreLoading.value = true;
        houses.value = newHouses;
        isFetchingData.value = false;
        return;
      }

      isFetchingData.value = false;
      houses.value = [...houses.value, ...newHouses];
    }

    // UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            testState.when(
              data: (data) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        fetchData(getDataType: GetDataType.fetchdata),
                    child: const Text("Fetch Data"),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        fetchData(getDataType: GetDataType.loadmore),
                    child: const Text("Load More Data"),
                  ),
                  if (houses.value.isNotEmpty)
                    Text("Number of houses fetched: ${houses.value.length}"),
                  ...houses.value.map((house) => ListTile(
                        title: Text(house.name),
                        subtitle: Text(house.description),
                      )),
                  if (isLoadMoreLoading.value)
                    const CircularProgressIndicator(), // Hiển thị khi đang load thêm
                  if (isLastPage.value)
                    const Text(
                        'No more content'), // Thông báo không còn dữ liệu
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: ${error.toString()}'),
            ),
          ],
        ),
      ),
    );
  }
}
