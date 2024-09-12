import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/ChecklistSection.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/NotesSection.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/PackageSelection.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/RoundTripCheckbox.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/SummarySection.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/booking_dropdown_button.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/booking_package_provider.dart';
import 'package:movemate/utils/commons/widgets/booking_layout/widget/booking_screen_2th/service_table.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import 'package:auto_route/auto_route.dart';

@RoutePage()
class BookingSelectPackageScreen extends ConsumerStatefulWidget {
  const BookingSelectPackageScreen({super.key});

  @override
  ConsumerState<BookingSelectPackageScreen> createState() =>
      BookingSelectPackageScreenState();
}

class BookingSelectPackageScreenState
    extends ConsumerState<BookingSelectPackageScreen> {
  int selectedPeopleCount = 1; // Biến lưu trữ số người được chọn

  bool isBocXepExpanded = false;
  bool isThaoLapExpanded = false;

  int selectedAirConditionersCount = 1;
  bool isRoundTrip = false;
  double totalPrice = 0;
  TextEditingController noteController = TextEditingController();

  // Define the packageSelected state and selectedPackageIndex
  List<bool> packageSelected = [];
  int? selectedPackageIndex;

  @override
  void initState() {
    super.initState();

    // Initialize the packageSelected list with false values based on the number of package titles
    final packageData = ref.read(packageDataProvider);
    packageSelected =
        List<bool>.filled(packageData['packageTitles'].length, false);
  }

  @override
  Widget build(BuildContext context) {
    final thaoLapServices = ref.watch(thaoLapServicesProvider);

    // Fetch checklist options and values
    final checklistOptions = ref.watch(checklistOptionsProvider);
    final checklistValues = ref.watch(checklistDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đặt hàng'),
        backgroundColor: AssetsConstants.primaryMain,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for "Dịch vụ bốc xếp"
                  BookingDropdownButton(
                    title: 'Dịch vụ bốc xếp',
                    isExpanded: isBocXepExpanded,
                    onPressed: () {
                      setState(() {
                        isBocXepExpanded = !isBocXepExpanded;
                        isThaoLapExpanded = false;
                      });
                    },
                  ),

                  if (isBocXepExpanded)
                    Column(
                      children: [
                        // PackageSelection là radio button selection
                        PackageSelection(
                          selectedPackageIndex: selectedPackageIndex,
                          onChanged: (index) {
                            setState(() {
                              selectedPackageIndex = index;
                              _updateTotalPrice();
                            });
                          },
                          selectedPeopleCount:
                              selectedPeopleCount, // Truyền giá trị hiện tại của số lượng người
                          onPeopleCountChanged: (value) {
                            setState(() {
                              selectedPeopleCount =
                                  value; // Cập nhật số lượng người
                            });
                          },
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Dropdown for "Dịch vụ tháo lắp máy lạnh"
                  BookingDropdownButton(
                    title: 'Dịch vụ tháo lắp máy lạnh',
                    isExpanded: isThaoLapExpanded,
                    onPressed: () {
                      setState(() {
                        isThaoLapExpanded = !isThaoLapExpanded;
                        isBocXepExpanded = false;
                      });
                    },
                  ),
                  if (isThaoLapExpanded)
                    ServiceTable(
                      options: thaoLapServices
                          .map((e) => e['service'] as String)
                          .toList(),
                      prices: thaoLapServices
                          .map((e) => e['price'] as String)
                          .toList(),
                      selectedService: null,
                      selectedPeopleOrAirConditionersCount:
                          selectedAirConditionersCount,
                      isThaoLapService: true,
                      onAirConditionersCountChanged: (value) {
                        setState(() {
                          selectedAirConditionersCount = value ?? 1;
                        });
                      },
                    ),
                  const SizedBox(height: 16),

                  // Round trip checkbox
                  RoundTripCheckbox(
                    isRoundTrip: isRoundTrip,
                    onChanged: (value) {
                      setState(() {
                        isRoundTrip = value ?? false;
                        _updateTotalPrice();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Checklist
                  ChecklistSection(
                    checklistOptions: checklistOptions,
                    checklistValues: checklistValues,
                    onChanged: (index) {
                      ref
                          .read(checklistDataProvider.notifier)
                          .toggleValue(index);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes section
                  NotesSection(noteController: noteController),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Summary and place order section at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SummarySection(
              totalPrice: totalPrice,
              onPlaceOrder: _placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  void _updateTotalPrice() {
    // Example total price calculation logic
    double basePrice = 1794.000;
    if (isRoundTrip) {
      basePrice *= 1.7;
    }

    for (int i = 0; i < packageSelected.length; i++) {
      if (packageSelected[i]) {
        switch (i) {
          case 0:
            basePrice += 730.000;
            break;
          case 1:
            basePrice += 660.000;
            break;
          case 2:
            basePrice += 120.000;
            break;
        }
      }
    }

    setState(() {
      totalPrice = basePrice;
    });
  }

  void _placeOrder() {
    final notes = noteController.text;
    print('Placing order with notes: $notes');
    print('Total price: $totalPrice');
    // Add your API call here
  }
}
