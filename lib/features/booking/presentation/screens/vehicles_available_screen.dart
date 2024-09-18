import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/providers/vehicle_provider.dart';

@RoutePage()
class AvailableVehiclesScreen extends HookConsumerWidget {
  const AvailableVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final availableVehicles = ref.watch(availableVehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương tiện có sẵn'),
        backgroundColor: AssetsConstants.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: availableVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = availableVehicles[index];
                  final isSelected = bookingState.selectedVehicleIndex == index;

                  return GestureDetector(
                    onTap: () {
                      bookingNotifier.updateSelectedVehicle(
                        index,
                        calculatePrice(index),
                      );
                    },
                    child: _buildVehicleCard(
                      vehicle['title']!,
                      vehicle['description']!,
                      vehicle['size']!,
                      vehicle['imagePath']!,
                      isSelected,
                    ),
                  );
                },
              ),
            ),
            _buildTotalPriceSection(
              bookingState.totalPrice,
              bookingState.selectedVehicleIndex != null,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    String title,
    String description,
    String size,
    String imagePath,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
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
      height: 124,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AssetsConstants.greyColor.shade100,
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
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
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AssetsConstants.greyColor.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  size,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AssetsConstants.blackColor,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPriceSection(
      double totalPrice, bool isButtonEnabled, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade300,
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng', style: TextStyle(fontSize: 16)),
              Text(
                '₫${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      context.router.push(const BookingSelectPackageScreenRoute());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AssetsConstants.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Bước tiếp theo',
                style: TextStyle(fontSize: 16, color: AssetsConstants.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculatePrice(int index) {
    return 300000 + (index * 50000);
  }
}
