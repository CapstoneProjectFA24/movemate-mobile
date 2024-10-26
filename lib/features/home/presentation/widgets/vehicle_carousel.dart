import 'package:flutter/material.dart';
import 'dart:async';

import 'package:movemate/features/booking/presentation/screens/vehicles_list_price/vehicle_price_list_screen.dart';

class VehicleCarousel extends StatefulWidget {
  const VehicleCarousel({super.key});

  @override
  State<VehicleCarousel> createState() => VehicleCarouselState();
}

class VehicleCarouselState extends State<VehicleCarousel> {
  final pageController = PageController();
  int activePage = 0;
  Timer? timer;

  final vehicleData = [
    const VehicleData(
      imagePath: "assets/images/home/Group18564.png",
      title: "Xe VAN 500KG",
      description: "Thích hợp cho hàng hóa to",
      grossTon: "500kg",
      size: "1.6 x 1.2 x 1.1 mét",
      tripCount: "120 chuyến",
    ),
    const VehicleData(
      imagePath: "assets/images/home/Group18564.png",
      title: "Xe TẢI 1000KG",
      description: "Phù hợp với mọi loại hàng hóa",
      grossTon: "1000kg",
      size: "2.0 x 1.5 x 1.5 mét",
      tripCount: "80 chuyến",
    ),
  ];

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        if (!pageController.hasClients) return;
        final nextPage = (activePage + 1) % vehicleData.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void navigateToTruckList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehiclePriceListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context),
        const SizedBox(height: 8),
        buildCarousel(),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Xe dành cho bạn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () => navigateToTruckList(context),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Xem tất cả',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 295,
          child: PageView.builder(
            controller: pageController,
            itemCount: vehicleData.length,
            onPageChanged: (index) => setState(() => activePage = index),
            itemBuilder: (_, index) => VehicleCard(vehicle: vehicleData[index]),
          ),
        ),
        const SizedBox(height: 8),
        buildPageIndicator(),
      ],
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        vehicleData.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: InkWell(
            onTap: () => pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            ),
            child: CircleAvatar(
              radius: 4,
              backgroundColor:
                  activePage == index ? Colors.orange : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleData {
  final String imagePath;
  final String title;
  final String description;
  final String grossTon;
  final String size;
  final String tripCount;

  const VehicleData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.grossTon,
    required this.size,
    required this.tripCount,
  });
}

class VehicleCard extends StatelessWidget {
  final VehicleData vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 253,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  vehicle.imagePath,
                  width: 244,
                  height: 207,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Text(
                vehicle.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                vehicle.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              buildVehicleInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVehicleInfo() {
    return Row(
      children: [
        buildInfoItem(Icons.fitness_center, vehicle.grossTon),
        const SizedBox(width: 13),
        buildInfoItem(Icons.aspect_ratio, vehicle.size),
        const SizedBox(width: 16),
        buildInfoItem(Icons.format_list_numbered, vehicle.tripCount),
      ],
    );
  }

  Widget buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
