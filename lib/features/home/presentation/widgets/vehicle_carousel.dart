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
      imagePath: "assets/images/home/xe-van-500kg.jpg",
      title: "Xe Van 500 kg",
      description: "Hoạt động tất cả khung giờ",
      grossTon: "500kg",
      size: "1.7 x 1.2 x 1.2 Mét",
    ),
    const VehicleData(
      imagePath: "assets/images/home/xe-van-1000kg.png",
      title: "Xe Van 1000 kg",
      description: "Hoạt động tất cả khung giờ",
      grossTon: "1000kg",
      size: "2.0 x 1.5 x 1.5 Mét",
    ),
    const VehicleData(
      imagePath: "assets/images/home/xe-tai-500kg.jpg",
      title: "Xe Tải 500 kg",
      description: "Cấm tải 6-9H & 16-20H",
      grossTon: "500kg",
      size: "1.9 x 1.4 x 1.4 Mét",
    ),
    const VehicleData(
      imagePath: "assets/images/home/xe-tai-1000.jpg",
      title: "Xe Tải 1000 kg",
      description: "Cấm tải 6-9H & 16-20H",
      grossTon: "1000kg",
      size: "3.0 x 1.6 x 1.6 Mét",
    ),
    const VehicleData(
      imagePath: "assets/images/home/xe tai 2000kg.jpg",
      title: "Xe Tải 2000 kg",
      description: "Cấm tải 6-9H & 16-20H",
      grossTon: "2000kg",
      size: "4 x 1.7 x 1.7 mét",
    ),
    const VehicleData(
      imagePath: "assets/images/home/xe tai 2500kg.jpg",
      title: "Xe Tải 2500 kg",
      description: "Cấm tải 6-9H & 16-20H",
      grossTon: "2500kg",
      size: "4.2 x 1.8 x 1.7 mét",
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
          duration: const Duration(milliseconds: 1000),
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
                fontSize: 10,
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
          height: 300,
          child: PageView.builder(
            controller: pageController,
            itemCount: vehicleData.length,
            onPageChanged: (index) => setState(() => activePage = index),
            itemBuilder: (_, index) => VehicleCard(vehicle: vehicleData[index]),
          ),
        ),
        // const SizedBox(height: 8),
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

  const VehicleData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.grossTon,
    required this.size,
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
          padding: const EdgeInsets.only(left: 24),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                vehicle.description,
                style: const TextStyle(
                  fontSize: 12,
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
      ],
    );
  }

  Widget buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
