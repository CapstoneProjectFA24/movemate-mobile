//service_table.dart
import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'people_dropdown.dart';
import 'air_conditioners_dropdown.dart';

class ServiceTable extends StatelessWidget {
  final List<String> options;
  final List<String> prices;
  final int? selectedService;
  final int? selectedPeopleOrAirConditionersCount;
  final bool isThaoLapService;
  final ValueChanged<int?>? onServiceChanged;
  final ValueChanged<int?>? onPeopleCountChanged;
  final ValueChanged<int?>? onAirConditionersCountChanged;

  const ServiceTable({
    super.key,
    required this.options,
    required this.prices,
    this.selectedService,
    this.selectedPeopleOrAirConditionersCount,
    required this.isThaoLapService,
    this.onServiceChanged,
    this.onPeopleCountChanged,
    this.onAirConditionersCountChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          if (!isThaoLapService)
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Số người'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PeopleDropdown(
                    selectedValue: selectedPeopleOrAirConditionersCount ?? 1,
                    onChanged: onPeopleCountChanged!,
                  ),
                ),
              ],
            ),
          if (isThaoLapService)
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Số máy lạnh'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AirConditionersDropdown(
                    selectedValue: selectedPeopleOrAirConditionersCount ?? 1,
                    onChanged: onAirConditionersCountChanged!,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
