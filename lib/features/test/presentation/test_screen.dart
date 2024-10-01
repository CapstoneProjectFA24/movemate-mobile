import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/test/domain/entities/house_entities.dart';
import 'package:movemate/features/test/presentation/test_controller.dart';
import 'package:movemate/hooks/use_list_pagination.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class TestScreen extends HookConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    Future<List<HouseEntities>> fetchHouses(int page) async {
      return await ref.read(testControllerProvider.notifier).getHouses(
            context,
          );
    }

    final paginationState = usePagination<HouseEntities>(
      fetchFunction: fetchHouses,
      onRefresh: () {
        // Nếu bạn cần refresh một provider nào đó
        // ref.refresh(someProvider);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Column(
        children: [
          if (paginationState.isLoading && paginationState.items.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (paginationState.items.isEmpty)
            const Center(child: Text('No houses found'))
          else
            Expanded(
              child: ListView.builder(
                controller: paginationState.scrollController,
                itemCount: paginationState.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == paginationState.items.length) {
                    if (paginationState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return paginationState.isLastPage
                        ? const Center(child: Text('No more houses'))
                        : const SizedBox();
                  }

                  final house = paginationState.items[index];
                  return ListTile(
                    title: Text('House ${index + 1}'),
                    subtitle:
                        Text(house.toString()), // Hiển thị thông tin house
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => {},
                  child: const Text("Refresh Data"),
                ),
                const SizedBox(height: 8),
                Text(
                  "Number of houses fetched: ${paginationState.items.length}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (paginationState.isLoading)
                  const Text("Loading more houses...")
                else if (paginationState.isLastPage)
                  const Text("No more houses to load"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
