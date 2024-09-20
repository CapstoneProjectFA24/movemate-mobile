// service_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'people_dropdown.dart';
import 'air_conditioners_dropdown.dart';

class ServiceTable extends ConsumerWidget {
  final List<String> options;
  final List<String> prices;
  final int? selectedService;
  final int selectedPeopleOrAirConditionersCount;
  final bool isThaoLapService;
  final ValueChanged<int?>? onPeopleCountChanged;
  final ValueChanged<int?>? onAirConditionersCountChanged;

  const ServiceTable({
    super.key,
    required this.options,
    required this.prices,
    required this.selectedService,
    required this.selectedPeopleOrAirConditionersCount,
    required this.isThaoLapService,
    this.onPeopleCountChanged,
    this.onAirConditionersCountChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AssetsConstants.greyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: TableBorder.all(color: AssetsConstants.blackColor, width: 0.5),
        children: [
          for (int i = 0; i < options.length; i++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(options[i], style: const TextStyle(fontSize: 14)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(prices[i], style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(isThaoLapService ? 'Số máy lạnh' : 'Số người',
                    style: const TextStyle(fontSize: 14)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isThaoLapService
                    ? AirConditionersDropdown(
                        selectedValue: selectedPeopleOrAirConditionersCount,
                        onChanged: onAirConditionersCountChanged!,
                      )
                    : PeopleDropdown(
                        selectedValue: selectedPeopleOrAirConditionersCount,
                        onChanged: onPeopleCountChanged!,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
