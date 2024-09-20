// package_selection.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'service_table.dart';

class PackageSelection extends ConsumerWidget {
  final int? selectedPackageIndex;
  final int selectedPeopleCount;
  final Function(int?) onPeopleCountChanged;
  final Function(int) onChanged;

  const PackageSelection({
    super.key,
    required this.selectedPackageIndex,
    required this.selectedPeopleCount,
    required this.onPeopleCountChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final packages = bookingState.packages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn gói dịch vụ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (int index = 0; index < packages.length; index++)
          Column(
            children: [
              _buildPackageTile(
                context: context,
                package: packages[index],
                index: index,
                selectedPackageIndex: selectedPackageIndex,
                onChanged: onChanged,
              ),
              if (selectedPackageIndex == index)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ServiceTable(
                    options:
                        packages[index].services.map((e) => e.title).toList(),
                    prices:
                        packages[index].services.map((e) => e.price).toList(),
                    selectedService: null,
                    selectedPeopleOrAirConditionersCount: selectedPeopleCount,
                    isThaoLapService: false,
                    onPeopleCountChanged: (value) {
                      onPeopleCountChanged(value);
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildPackageTile({
    required BuildContext context,
    required Package package,
    required int index,
    required int? selectedPackageIndex,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Card(
        color: AssetsConstants.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AssetsConstants.greyColor),
        ),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              package.packageIcon,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            package.packageTitle,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            package.packagePrice,
            style: const TextStyle(
              color: AssetsConstants.greyColor,
              fontSize: 14,
            ),
          ),
          trailing: Radio<int>(
            value: index,
            groupValue: selectedPackageIndex,
            onChanged: (value) {
              onChanged(index);
            },
            activeColor: AssetsConstants.primaryLight,
          ),
        ),
      ),
    );
  }
}
