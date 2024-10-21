import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/home/presentation/widgets/map_widget/button_custom.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

final pickupAutocompleteResultsProvider =
    StateProvider<List<dynamic>>((ref) => []);
final dropoffAutocompleteResultsProvider =
    StateProvider<List<dynamic>>((ref) => []);

final pickupSelectedLocationProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
final dropoffSelectedLocationProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

class LocationBottomSheet extends HookConsumerWidget {
  const LocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chọn địa chỉ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => context.router.pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(text: 'Điểm đi'),
                        Tab(text: 'Điểm đến'),
                      ],
                      onTap: (index) {
                        // Clear autocomplete results when switching tabs
                        if (index == 0) {
                          ref
                              .read(pickupAutocompleteResultsProvider.notifier)
                              .state = [];
                        } else {
                          ref
                              .read(dropoffAutocompleteResultsProvider.notifier)
                              .state = [];
                        }
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          LocationTab(context, ref, true),
                          LocationTab(context, ref, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LocationTab(BuildContext context, WidgetRef ref, bool isPickUp) {
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    print(bookingState.pickUpLocation?.toJson());
    final autocompleteResults = ref.watch(isPickUp
        ? pickupAutocompleteResultsProvider
        : dropoffAutocompleteResultsProvider);
    final selectedLocation = ref.watch(isPickUp
        ? pickupSelectedLocationProvider
        : dropoffSelectedLocationProvider);

    const apiKey = '38db2f3d058b34e0f52f067fe66a902830fac1a044e8d444';

    void fetchAutocompleteResults(
        String query, WidgetRef ref, bool isPickUp) async {
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/autocomplete/v3?apikey=$apiKey&text=$query');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final results = json.decode(response.body);
          if (isPickUp) {
            ref.read(pickupAutocompleteResultsProvider.notifier).state =
                results;
          } else {
            ref.read(dropoffAutocompleteResultsProvider.notifier).state =
                results;
          }
        }
      } catch (e) {
        print('Error fetching autocomplete results: $e');
      }
    }

    void fetchLocationDetails(
        String refId, WidgetRef ref, bool isPickUp) async {
      final url = Uri.parse(
          'https://maps.vietmap.vn/api/place/v3?apikey=$apiKey&refid=$refId');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final details = json.decode(response.body);
          if (isPickUp) {
            ref.read(pickupSelectedLocationProvider.notifier).state = details;
          } else {
            ref.read(dropoffSelectedLocationProvider.notifier).state = details;
          }
        }
      } catch (e) {
        print('Error fetching location details: $e');
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: isPickUp ? 'Tìm điểm đi' : 'Tìm điểm đến',
                      ),
                      onChanged: (value) {
                        if (value.length > 2) {
                          fetchAutocompleteResults(value, ref, isPickUp);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Autocomplete results
            ...autocompleteResults.map((result) => ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.grey),
                  title: Text(result['display']),
                  onTap: () =>
                      fetchLocationDetails(result['ref_id'], ref, isPickUp),
                )),

            const SizedBox(height: 20),

            // Selected location details
            if (selectedLocation != null) ...[
              Text('Selected Location: ${selectedLocation['display']}'),
              Text('Latitude: ${selectedLocation['lat']}'),
              Text('Longitude: ${selectedLocation['lng']}'),
            ],

            const SizedBox(height: 20),

            // Confirm button
            if (selectedLocation != null)
              ButtonCustom(
                buttonText: 'Xác nhận',
                buttonColor: AssetsConstants.primaryDark,
                isButtonEnabled: true,
                onButtonPressed: () {
                  final location = LocationModel(
                    label: selectedLocation['name'],
                    address: selectedLocation['display'],
                    latitude: selectedLocation['lat'],
                    longitude: selectedLocation['lng'],
                    distance: '',
                  );
                  if (isPickUp) {
                    bookingNotifier.updatePickUpLocation(location);
                  } else {
                    bookingNotifier.updateDropOffLocation(location);
                  }

                  final pickupLocation =
                      ref.read(pickupSelectedLocationProvider);
                  final dropoffLocation =
                      ref.read(dropoffSelectedLocationProvider);

                  if (pickupLocation != null && dropoffLocation != null) {
                    final tabsRouter = context.router.root
                        .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
                    if (tabsRouter != null) {
                      tabsRouter.setActiveIndex(0);
                      context.router
                          .popUntilRouteWithName(TabViewScreenRoute.name);
                    }
                  } else {
                    final tabController = DefaultTabController.of(context);
                    tabController.animateTo(isPickUp ? 1 : 0);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
