//order_layout.dart
import 'package:flutter/material.dart';
import 'package:movemate/features/order/presentation/order_details.dart';
import 'package:movemate/utils/commons/widgets/order_layout/widget/order_model.dart';
import 'package:movemate/utils/commons/widgets/order_layout/widget/order_nav.dart';

class OrderLayout extends StatefulWidget {
  const OrderLayout({super.key});

  @override
  State<OrderLayout> createState() => _OrderLayoutState();
}

class _OrderLayoutState extends State<OrderLayout> {
  String selectedHouseType = '';
  int roomCount = 0;
  int floorCount = 0;

  String? houseType;
  int numberOfRooms = 1;
  int numberOfFloors = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Model (House type selection, Room and Floor count)
              // OrderModel handles the modal interactions
              OrderModel(
                onHouseTypeSelected: (selectedType) {
                  setState(() {
                    houseType = selectedType;
                  });
                },
                onRoomCountSelected: (count) {
                  setState(() {
                    numberOfRooms = count;
                  });
                },
                onFloorCountSelected: (count) {
                  setState(() {
                    numberOfFloors = count;
                  });
                },
              ),
              const SizedBox(height: 16),
// OrderDetail renders the actual details
              OrderDetail(
                houseType: houseType,
                numberOfRooms: numberOfRooms,
                numberOfFloors: numberOfFloors,
              ),
              const SizedBox(height: 16),

              // Navigation button (Submit/Continue button)
              const OrderNav(),
            ],
          ),
        ),
      ),
    );
  }
}
