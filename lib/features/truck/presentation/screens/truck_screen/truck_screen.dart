import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/features/truck/domain/entities/truck_entity.dart';
import 'package:movemate/features/truck/presentation/screens/truck_screen/truck_controller.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';

@RoutePage()
class TruckScreen extends HookConsumerWidget {
  TruckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(truckControllerProvider);
    // Init
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();

    final fetchTrucks = useFetch<TruckEntity>(
      function: (model, context) =>
          ref.read(truckControllerProvider.notifier).getTrucks(model, context),
      initialPagingModel: PagingModel(
        searchContent: "2",
        // các loại filter khác sẽ viết trong screen => đẩy qua provider để truyền qua ở đây
        // coi example ở trong floder => feature/test/widgets/show_bottom_ui_filter
      ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchTrucks.loadMore);

      //  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   if (message.data['screen'] == OrderDetailScreenRoute.name) {
      //     fetchResult.refresh();
      //   }

      print('test data ${fetchTrucks.items.toString()}');
      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Screen'),
      ),
      body: const Center(
        child: Text('Truck!'),
      ),
    );
  }
}
