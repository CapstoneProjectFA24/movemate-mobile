import 'package:flutter/material.dart';
import 'dart:async';

class VehicleCarousel extends StatefulWidget {
  const VehicleCarousel({super.key});

  @override
  State<VehicleCarousel> createState() => _VehicleCarouselState();
}

class _VehicleCarouselState extends State<VehicleCarousel> {
  late List<Widget> _page;
  int _activePage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> vehicleData = [
    {
      "imagePath": "assets/images/home/Group18564.png",
      "title": "Xe VAN 500KG",
      "description": "thích hợp cho hàng hóa to",
      "grossTon": "500kg",
      "size": "1.6 x 1.2 x 1.1 mét",
      "tripCount": "120 chuyến"
    },
    {
      "imagePath": "assets/images/home/Group18564.png",
      "title": "Xe TẢI 1000KG",
      "description": "phù hợp với mọi loại hàng hóa",
      "grossTon": "1000kg",
      "size": "2.0 x 1.5 x 1.5 mét",
      "tripCount": "80 chuyến"
    },
    // Add more vehicle data as needed...
  ];

  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 3000),
      (timer) {
        if (_pageController.page == vehicleData.length - 1) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        } else {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _page = List.generate(
      vehicleData.length,
      (index) => _buildVehicleOption(
        imagePath: vehicleData[index]["imagePath"]!,
        title: vehicleData[index]["title"]!,
        description: vehicleData[index]["description"]!,
        grossTon: vehicleData[index]["grossTon"]!,
        size: vehicleData[index]["size"]!,
        tripCount: vehicleData[index]["tripCount"]!,
      ),
    );
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVehicleSection();
  }

  Widget _buildVehicleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Xe dành cho bạn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildVehicleOptions(),
      ],
    );
  }

  Widget _buildVehicleOptions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 295, // Adjust height to fit vehicle options
          child: PageView.builder(
            controller: _pageController,
            itemCount: vehicleData.length,
            onPageChanged: (value) {
              setState(() {
                _activePage = value;
              });
            },
            itemBuilder: (context, index) {
              return _page[index];
            },
          ),
        ),
        const SizedBox(height: 8), // Add spacing between card and indicator
        Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              vehicleData.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  onTap: () {
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor:
                        _activePage == index ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleOption({
    required String imagePath,
    required String title,
    required String description,
    required String grossTon,
    required String size,
    required String tripCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Card(
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 253,
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      width: 244,
                      height: 207,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.fitness_center,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      grossTon,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 13),
                    const Icon(Icons.aspect_ratio,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      size,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.format_list_numbered,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      tripCount,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
