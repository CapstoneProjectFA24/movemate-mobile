import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/models/booking_models.dart';
import 'package:movemate/features/booking/presentation/booking_select_package_screen.dart';

import 'package:movemate/utils/providers/vehicle_provider.dart';

@RoutePage()
class AvailableVehiclesScreen extends HookConsumerWidget {
  final AvailableVehicles? avalble; // Nullable

  const AvailableVehiclesScreen({
    super.key,
    this.avalble,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableVehicles = ref.watch(availableVehiclesProvider);

    // Use initial values if provided, otherwise start with defaults
    final selectedVehicleIndex =
        useState<int?>(avalble?.initialSelectedVehicleIndex);
    final totalPrice = useState<double>(avalble?.initialTotalPrice ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương tiện có sẵn'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: availableVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = availableVehicles[index];
                  return GestureDetector(
                    onTap: () {
                      // Update selected vehicle and total price
                      selectedVehicleIndex.value = index;
                      totalPrice.value = calculatePrice(
                          index); // Update total price based on the selected vehicle
                    },
                    child: _buildVehicleCard(
                      vehicle['title']!,
                      vehicle['description']!,
                      vehicle['size']!,
                      vehicle['imagePath']!,
                      selectedVehicleIndex.value == index, // Check if selected
                    ),
                  );
                },
              ),
            ),
            // Total Price and Continue Button
            _buildTotalPriceSection(300.0, true, context),
          ],
        ),
      ),
    );
  }

  // Helper function to build each vehicle card with fixed dimensions
  Widget _buildVehicleCard(
    String title,
    String description,
    String size,
    String imagePath,
    bool isSelected, // Whether the card is selected
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.orange
              : Colors.grey.shade300, // Active border for selected card
          width: 2, // Wider border for the selected card
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200, // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      height: 124, // Fixed card height
      width: double.infinity, // Card width to fill the parent
      child: Row(
        children: [
          // Image with fixed width and height
          Container(
            width: 60, // Fixed image width
            height: 60, // Fixed image height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100, // Background color for image
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, // Ensure image fits within the container
            ),
          ),
          const SizedBox(width: 16), // Space between image and text

          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title with fixed color and bold font
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  maxLines: 1, // Limit to 1 line
                  overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                ),
                const SizedBox(
                    height: 6), // Spacing between title and description

                // Description with fixed color and font size, and limited lines
                SizedBox(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Show ellipsis for overflow
                  ),
                ),

                const SizedBox(
                    height: 6), // Spacing between description and size

                // Size information

                Text(
                  size,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  maxLines: 1, // Limit to 1 line
                  overflow: TextOverflow.visible, // Show ellips
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build the total price section and button

  Widget _buildTotalPriceSection(
      double totalPrice, bool isButtonEnabled, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tổng cộng và nút Tiếp theo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng', style: TextStyle(fontSize: 16)),
              Text(
                '₫${totalPrice.toStringAsFixed(3)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nút Tiếp tục
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      // Điều hướng sang màn hình OrderSelectPackageScreen
                      context.router
                          .push(const BookingSelectPackageScreenRoute());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? Colors.orange : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  const Text('Bước tiếp theo', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // Calculate the price based on the selected vehicle index
  double calculatePrice(int index) {
    // Sample price calculation based on the selected vehicle index
    return 300000 + (index * 50000);
  }

  // Continue button action
  void _onContinue(BuildContext context) {
    // Điều hướng đến OrderSelectPackageScreen
    context.router.push(const BookingSelectPackageScreenRoute());
  }
}
