import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_list_price_provider.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_model_list_price.dart';

@RoutePage()
class VehiclePriceListScreen extends HookConsumerWidget {
  const VehiclePriceListScreen({super.key});

  // Define vehiclesList as a static variable inside the class
  static final List<VehicleModel> vehiclesList = [
    VehicleModel(
      title: 'Xe tải 500kg',
      size: '190cm x 140cm x 140cm',
      volume: '1.5 CBM',
      basePrice: '111,780đ',
      additionalPrice:
          '+10.800đ/km (4-10km)\n+7.560đ/km (10-15km)\n+5.940đ/km (15-45km)\n+4.860đ/km (>45km)',
      longDistancePrice:
          '362,880đ/40km đầu tiên\n+5.940đ/km (40-45km)\n+4.860đ/km (>45km)',
      imagePath: 'assets/images/booking/vehicles/truck4.png',
      bgColor: Colors.orangeAccent,
    ),
    VehicleModel(
      title: 'Xe van 1000kg',
      size: '210cm x 130cm x 130cm',
      volume: '4 CBM',
      basePrice: '148,500đ',
      additionalPrice:
          '+12.420đ/km (4-10km)\n+9.720đ/km (10-15km)\n+7.020đ/km (15-45km)\n+5.400đ/km (>45km)',
      longDistancePrice:
          '447,120đ/40km đầu tiên\n+7.020đ/km (40-45km)\n+5.400đ/km (>45km)',
      imagePath: 'assets/images/booking/vehicles/truck4.png',
      bgColor: Colors.tealAccent,
    ),
  ];

  // Define vehicleListPriceProvider as a static variable inside the class
  static final vehicleListPriceProvider =
      StateNotifierProvider<VehicleListPriceProvider, int>(
    (ref) => VehicleListPriceProvider(vehiclesList: vehiclesList),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(vehicleListPriceProvider);
    final vehicleProviderNotifier = ref.read(vehicleListPriceProvider.notifier);
    final currentVehicle = vehicleProviderNotifier.currentVehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng giá niêm yết'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Image and navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    vehicleProviderNotifier
                        .previousVehicle(); // Move to the previous vehicle
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Column(
                  children: [
                    // Image with fixed size
                    Container(
                      width: 120, // Fixed width of the image
                      height: 120, // Fixed height of the image
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          currentVehicle.imagePath,
                          width: 120, // Fixed width
                          height: 120, // Fixed height
                          fit: BoxFit.cover, // How the image fills the frame
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentVehicle.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    vehicleProviderNotifier
                        .nextVehicle(); // Move to the next vehicle
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Vehicle Details
            buildDetailRow('Kích thước', currentVehicle.size),
            buildDetailRow('Số khối', currentVehicle.volume),
            const SizedBox(height: 16),
            // Price Details
            buildPriceSection(
                'Cước ban đầu tối thiểu', currentVehicle.basePrice),
            const SizedBox(height: 16),
            buildPriceSection(
                'Cước phí km tiếp theo (~4km)', currentVehicle.additionalPrice),
            const SizedBox(height: 16),
            buildPriceSection('Giao Hàng Đường Dài (từ 40km)',
                currentVehicle.longDistancePrice),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildPriceSection(String title, String priceDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            priceDetails,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
