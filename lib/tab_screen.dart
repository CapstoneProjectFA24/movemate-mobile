import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'configs/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/widgets/bottom_bar.dart';
import 'utils/commons/widgets/loading_overlay.dart';
import 'utils/providers/common_provider.dart';

final GlobalKey<ScaffoldState> autoTabsScaffoldKey = GlobalKey<ScaffoldState>();

@RoutePage()
class TabViewScreen extends ConsumerWidget {
  const TabViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // init
    final state = ref.watch(modifyProfiver);

    return LoadingOverlay(
      isLoading: state,
      child: AutoTabsScaffold(
        scaffoldKey: autoTabsScaffoldKey,
        routes: const [
          HomeScreenRoute(),
          OrderScreenRoute(),
          PromotionScreenRoute(),
          ProfileScreenRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) =>
            CustomBottomBar(tabsRouter: tabsRouter),
      ),
    );
  }
}
