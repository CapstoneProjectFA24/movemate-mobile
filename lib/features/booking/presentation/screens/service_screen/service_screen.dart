// service_screen.dart

// Config
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Hooks
import 'package:movemate/hooks/use_fetch.dart';

// Widgets and Extensions
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';

// Data Entities
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';

@RoutePage()
class ServiceScreen extends HookConsumerWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();

    // Fetch services
    final fetchResult = useFetch<ServiceEntity>(
      function: (model, context) => ref
          .read(serviceControllerProvider.notifier)
          .getServices(model, context),
      initialPagingModel: PagingModel(
        searchContent: "1",
      ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchResult.loadMore);
      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Available Services',
        iconFirst: Icons.refresh_rounded,
        onCallBackFirst: fetchResult.refresh,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          (fetchResult.isFetchingData && fetchResult.items.isEmpty)
              ? const Center(
                  child: HomeShimmer(amount: 4),
                )
              : fetchResult.items.isEmpty
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: EmptyBox(
                          title: 'No data available or failed to load data'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: fetchResult.items.length + 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index == fetchResult.items.length) {
                            if (fetchResult.isFetchingData) {
                              return const CustomCircular();
                            }
                            return fetchResult.isLastPage
                                ? const NoMoreContent()
                                : Container();
                          }
                          final service = fetchResult.items[index];
                          return GestureDetector(
                            onTap: () {
                              // Handle service selection
                              // You can manage selected service using another provider if needed
                            },
                            child: buildServiceCard(
                              service,
                              false, // Pass true if the service is selected
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  Widget buildServiceCard(
    ServiceEntity service,
    bool isSelected,
  ) {
    final truckCategory = service.truckCategory;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AssetsConstants.primaryDark
              : AssetsConstants.greyColor.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 140,
      width: double.infinity,
      child: Row(
        children: [
          // Service Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AssetsConstants.greyColor.shade100,
            ),
            child: Image.network(
              service.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 50);
              },
            ),
          ),
          const SizedBox(width: 16),
          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AssetsConstants.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AssetsConstants.greyColor.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (truckCategory != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping,
                        size: 16,
                        color: AssetsConstants.blackColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        truckCategory.categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AssetsConstants.blackColor,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.straighten,
                        size: 16,
                        color: AssetsConstants.blackColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${truckCategory.estimatedLength} x ${truckCategory.estimatedWidth} x ${truckCategory.estimatedHeight} x ${truckCategory.maxLoad}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AssetsConstants.blackColor,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ] else
                  Text(
                    'No Truck Category',
                    style: TextStyle(
                      fontSize: 12,
                      color: AssetsConstants.greyColor.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
