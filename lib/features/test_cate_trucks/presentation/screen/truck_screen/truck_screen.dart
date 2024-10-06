// truck_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/test_cate_trucks/domain/entities/truck_entities.dart';
import 'package:movemate/features/test_cate_trucks/presentation/screen/truck_screen/truck_controller.dart';
import 'package:movemate/features/test_cate_trucks/presentation/widget/truck_item.dart';

import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';

@RoutePage()
class TruckScreen extends HookConsumerWidget {
  const TruckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();
    final state = ref.watch(truckControllerProvider);

    // Fetch trucks
    final fetchResult = useFetch<TruckEntities>(
      function: (model, context) =>
          ref.read(truckControllerProvider.notifier).getTrucks(model, context),
      initialPagingModel: PagingModel(
        searchContent: "1",
      ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchResult.loadMore);
      print(" check items ${fetchResult.items}");
      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trucks',
        iconFirst: Icons.refresh_rounded,
        // iconSecond: Icons.filter_list_alt,
        onCallBackFirst: fetchResult.refresh,
        // Implement filter callback if needed
        // onCallBackSecond: () => showFilterBottomSheet(context),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          (state.isLoading && fetchResult.items.isEmpty)
              ? const Center(
                  child: HomeShimmer(amount: 4),
                )
              : fetchResult.items.isEmpty
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: EmptyBox(title: 'No data available'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: fetchResult.items.length + 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AssetsConstants.defaultPadding - 10.0,
                        ),
                        itemBuilder: (_, index) {
                          if (index == fetchResult.items.length) {
                            if (fetchResult.isFetchingData) {
                              return const CustomCircular();
                            }
                            return fetchResult.isLastPage
                                ? const NoMoreContent()
                                : Container();
                          }
                          return TruckItem(
                            truck: fetchResult.items[index],
                            onCallback: fetchResult.refresh,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
