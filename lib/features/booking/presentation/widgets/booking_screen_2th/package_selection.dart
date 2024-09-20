//package_selection.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package_provider.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_table.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class PackageSelection extends ConsumerWidget {
  final int? selectedPackageIndex; // Index của package đã chọn
  final ValueChanged<int> onChanged;
  final int selectedPeopleCount; // Giá trị số lượng người
  final ValueChanged<int>
      onPeopleCountChanged; // Hàm để thay đổi số lượng người

  const PackageSelection({
    super.key,
    required this.selectedPackageIndex,
    required this.onChanged,
    required this.selectedPeopleCount, // Truyền giá trị số lượng người từ bên ngoài
    required this.onPeopleCountChanged, // Truyền hàm callback để thay đổi số lượng người
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy dữ liệu từ packageDataProvider
    final packageData = ref.watch(packageDataProvider);
    final packageIcons = packageData['packageIcons'] as List<String>;
    final packageTitles = packageData['packageTitles'] as List<String>;
    final packagePrices = packageData['packagePrices'] as List<String>;

    // Lấy dữ liệu dịch vụ bốc xếp
    final bocXepServices = ref.watch(bocXepServicesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn gói dịch vụ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Hiển thị radio buttons cho mỗi gói dịch vụ
        for (int index = 0; index < packageTitles.length; index++)
          Column(
            children: [
              _buildPackageTile(
                context: context,
                icons: packageIcons[index],
                title: packageTitles[index],
                price: packagePrices[index],
                index: index,
              ),
              // Chỉ hiển thị bảng dịch vụ cho package đã được chọn
              if (selectedPackageIndex == index)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ServiceTable(
                    options: bocXepServices
                        .map((e) => e['service'] as String)
                        .toList(),
                    prices: bocXepServices
                        .map((e) => e['price'] as String)
                        .toList(),
                    selectedService: selectedPackageIndex, // Dịch vụ đã chọn
                    selectedPeopleOrAirConditionersCount:
                        selectedPeopleCount, // Truyền giá trị số lượng người
                    isThaoLapService: false,
                    onPeopleCountChanged: (value) {
                      onPeopleCountChanged(
                          value ?? 1); // Gọi hàm thay đổi số lượng người
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }

  // Widget để xây dựng một dòng package với radio button
  Widget _buildPackageTile({
    required BuildContext context,
    required String icons,
    required String title,
    required String price,
    required int index,
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
              icons,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '₫$price',
            style: const TextStyle(
              color: AssetsConstants.greyColor,
              fontSize: 14,
            ),
          ),
          trailing: Radio<int>(
            value: index,
            groupValue: selectedPackageIndex, // Kiểm tra package nào được chọn
            onChanged: (value) {
              onChanged(index); // Gọi callback khi chọn package
            },
            activeColor: AssetsConstants.primaryLight,
          ),
        ),
      ),
    );
  }
}
