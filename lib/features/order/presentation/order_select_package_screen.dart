import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class OrderSelectPackageScreen extends StatefulWidget {
  const OrderSelectPackageScreen({super.key});

  @override
  State<OrderSelectPackageScreen> createState() =>
      _OrderSelectPackageScreenState();
}

class _OrderSelectPackageScreenState extends State<OrderSelectPackageScreen> {
  // Track if each dropdown is expanded or not
  bool isBocXepExpanded = false;
  bool isThaoLapExpanded = false;

  int selectedService = 0; // Initially select the first service option
  int selectedPeopleCount = 1; // Default people count
  int selectedAirConditionersCount = 1; // Default air conditioner count

  // Service options for each dropdown
  List<String> bocXepServices = [
    'Bốc xếp (Bởi tài xế)',
    'Bốc xếp (Có người hỗ trợ)'
  ];
  List<String> bocXepServicePrices = ['120.000đ', '400.000đ'];

  List<String> thaoLapServices = [
    'Tháo lắp (loại 1)',
    'Tháo lắp (loại 2)',
    'Tháo lắp (loại 3)'
  ];
  List<String> thaoLapServicePrices = ['300.000đ', '500.000đ', '700.000đ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đặt hàng'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for "Dịch vụ bốc xếp"
              _buildDropdownButton(
                'Dịch vụ bốc xếp',
                isBocXepExpanded,
                () {
                  setState(() {
                    isBocXepExpanded = !isBocXepExpanded;
                    isThaoLapExpanded = false; // Collapse the other dropdown
                  });
                },
              ),
              if (isBocXepExpanded)
                _buildServiceTable(
                  bocXepServices,
                  bocXepServicePrices,
                  selectedService,
                  selectedPeopleCount,
                  onServiceChanged: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedService = newValue;
                      }
                    });
                  },
                  onPeopleCountChanged: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedPeopleCount = newValue;
                      }
                    });
                  },
                  isThaoLapService: false, // This is "Dịch vụ bốc xếp"
                ),
              const SizedBox(height: 16),

              // Dropdown for "Dịch vụ tháo lắp máy lạnh"
              _buildDropdownButton(
                'Dịch vụ tháo lắp máy lạnh',
                isThaoLapExpanded,
                () {
                  setState(() {
                    isThaoLapExpanded = !isThaoLapExpanded;
                    isBocXepExpanded = false; // Collapse the other dropdown
                  });
                },
              ),
              if (isThaoLapExpanded)
                _buildServiceTable(
                  thaoLapServices,
                  thaoLapServicePrices,
                  null, // No people count for this service
                  selectedAirConditionersCount, // This is where we handle air conditioner count
                  isThaoLapService: true, // This is "Dịch vụ tháo lắp máy lạnh"
                  onAirConditionersCountChanged: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedAirConditionersCount = newValue;
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create the dropdown button
  Widget _buildDropdownButton(
      String title, bool isExpanded, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isExpanded ? Colors.blue : Colors.grey,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ],
      ),
    );
  }

  // Method to build the service table (for both services)
  Widget _buildServiceTable(
    List<String> options,
    List<String> prices,
    int? selectedService,
    int? selectedPeopleOrAirConditionersCount, {
    required bool
        isThaoLapService, // Required to differentiate between the two services
    ValueChanged<int?>? onServiceChanged,
    ValueChanged<int?>? onPeopleCountChanged,
    ValueChanged<int?>? onAirConditionersCountChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 0.5),
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
          if (!isThaoLapService) // Show dropdown for "Bốc xếp (Có người hỗ trợ)"
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
                  child: _buildPeopleDropdown(
                      selectedPeopleOrAirConditionersCount ?? 1,
                      onPeopleCountChanged!),
                ),
              ],
            ),
          if (isThaoLapService) // Show dropdown for "Số máy lạnh"
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
                  child: _buildAirConditionersDropdown(
                      selectedPeopleOrAirConditionersCount ?? 1,
                      onAirConditionersCountChanged!),
                ),
              ],
            ),
        ],
      ),
    );
  }

// People count dropdown for 'Bốc xếp (Có người hỗ trợ)'
  Widget _buildPeopleDropdown(int selectedValue, ValueChanged<int?> onChanged) {
    return Container(
      width: 120, // Fixed width for the dropdown
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.grey.shade300), // Border around the dropdown
        color: Colors.white, // Background color for dropdown button
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Padding inside the dropdown
      child: DropdownButton<int>(
        isDense: false, // Makes the dropdown dense and consistent in size
        isExpanded:
            false, // Prevents the dropdown from expanding with the value
        style: const TextStyle(color: Colors.black), // Text style for dropdown
        dropdownColor: Colors.white, // Background color for dropdown items
        value: selectedValue,
        items: List.generate(
          10,
          (index) => DropdownMenuItem(
            value: index + 1,
            child: Text('${index + 1} người'),
          ),
        ),
        onChanged: onChanged,
        underline: const SizedBox(), // Removes the default dropdown underline
      ),
    );
  }

  // Air conditioners count dropdown for 'Dịch vụ tháo lắp máy lạnh'
  Widget _buildAirConditionersDropdown(
      int selectedValue, ValueChanged<int?> onChanged) {
    return Container(
      width: 150, // Fixed width for the dropdown to prevent jumping
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.grey.shade300), // Border around the dropdown
        color: Colors.white, // Background color for dropdown button
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Padding inside the dropdown
      child: DropdownButton<int>(
        isDense: false, // Makes the dropdown dense and prevents resizing
        isExpanded: false, // Ensures the dropdown doesn't expand with the value
        style: const TextStyle(color: Colors.black), // Text style for dropdown
        dropdownColor: Colors.white, // Background color for dropdown items
        value: selectedValue,
        items: List.generate(
          10,
          (index) => DropdownMenuItem(
            value: index + 1,
            child: Text('${index + 1} máy lạnh'),
          ),
        ),
        onChanged: onChanged,
        underline: const SizedBox(), // Removes the default dropdown underline
      ),
    );
  }
}
