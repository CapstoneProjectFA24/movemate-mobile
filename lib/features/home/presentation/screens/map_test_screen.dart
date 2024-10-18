import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

final vietmapControllerProvider =
    StateProvider<VietmapController?>((ref) => null);

@RoutePage()
class MapScreenTest extends HookConsumerWidget {
  const MapScreenTest({super.key});

  static const String apiKey =
      '38db2f3d058b34e0f52f067fe66a902830fac1a044e8d444';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(vietmapControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Map View
          VietmapGL(
            styleString:
                "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$apiKey",
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.762317, 106.654551),
              zoom: 15,
            ),
            onMapCreated: (VietmapController controller) {
              ref.read(vietmapControllerProvider.notifier).state = controller;
            },
          ),

          // Back button
          const Positioned(
            top: 20,
            left: 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),

          // Speed indicator
          // Positioned(
          //   bottom: 80,
          //   left: 20,
          //   child: Container(
          //     width: 60,
          //     height: 60,
          //     decoration: BoxDecoration(
          //       color: Colors.deepPurple,
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     child: const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text('7',
          //             style: TextStyle(color: Colors.white, fontSize: 16)),
          //         Text('km/h',
          //             style: TextStyle(color: Colors.white, fontSize: 12)),
          //       ],
          //     ),
          //   ),
          // ),

          // Search bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const LocationSelectionModal(),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.search, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Where do you want to go?',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                    const Icon(Icons.mic, color: Colors.deepPurple),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSelectionModal extends StatelessWidget {
  const LocationSelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Chọn địa chỉ, điểm đến',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tìm điểm đến',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),

          // Your address
          const ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('địa chỉ của bạn'),
          ),

          // Recent searches
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tìm kiếm gần đây',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
                _buildRecentSearchItem('Hà Nội, Việt Nam'),
                _buildRecentSearchItem('Cty- apas - hà nội'),
                _buildRecentSearchItem('Khách sạn Pullman Vũng Tàu'),
              ],
            ),
          ),

          // Popular destinations
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Điểm đến phổ biến',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildPopularDestination('Hà Nội, Việt Nam'),
                _buildPopularDestination('Đà Nẵng, Việt Nam'),
                _buildPopularDestination('Vũng Tàu, Việt Nam'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
          const Icon(Icons.close, size: 18),
        ],
      ),
    );
  }

  Widget _buildPopularDestination(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
