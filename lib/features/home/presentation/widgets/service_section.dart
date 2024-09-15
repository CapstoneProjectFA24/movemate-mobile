import 'package:flutter/material.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Gói dịch vụ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 224,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildServiceOption(
                'Vận Chuyển\nBốc Vác\nĐóng Gói',
                'assets/images/home/vanchuyen1.png',
              ),
              _buildServiceOption(
                'Vận\nChuyển\nBốc Vác',
                'assets/images/home/vanchuyen2.png',
              ),
              _buildServiceOption(
                'Vận\nChuyển',
                'assets/images/home/vanchuyen3.png',
              ),
              _buildServiceOption(
                'Định Giá\nTại Nhà',
                'assets/images/home/vanchuyen4.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceOption(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Container(
              width: 100,
              height: 185,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle "Chi tiết" link tap
                      //chuyển hướng
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            'Chi tiết',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.grey, size: 12),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
