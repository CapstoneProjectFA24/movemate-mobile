//order_details.dart
import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget {
  final String? houseType;
  final int numberOfRooms;
  final int numberOfFloors;

  OrderDetail({
    super.key,
    this.houseType,
    this.numberOfRooms = 1,
    this.numberOfFloors = 1,
  });

  // Room images
  final List<String> livingRoomImages = [];
  final List<String> bedroomImages = [];
  final List<String> diningRoomImages = [];
  final List<String> officeRoomImages = [];
  final List<String> bathroomImages = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection('Loại nhà:', houseType ?? 'Chưa chọn'),
          _buildDetailSection('Số phòng ngủ:', numberOfRooms.toString()),
          _buildDetailSection('Số tầng:', numberOfFloors.toString()),
          const SizedBox(height: 16),
          _buildRoomImageSection('Phòng khách', livingRoomImages),
          const SizedBox(height: 16),
          _buildRoomImageSection('Phòng ngủ', bedroomImages),
          const SizedBox(height: 16),
          _buildRoomImageSection('Phòng ăn/ bếp', diningRoomImages),
          const SizedBox(height: 16),
          _buildRoomImageSection('Phòng làm việc', officeRoomImages),
          const SizedBox(height: 16),
          _buildRoomImageSection('Phòng vệ sinh', bathroomImages),
        ],
      ),
    );
  }

  // Helper method to display room images
  Widget _buildRoomImageSection(String roomTitle, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              return (index == images.length)
                  ? _buildAddImageButton()
                  : _buildRoomImage(images[index]);
            },
          ),
        ),
      ],
    );
  }

  // Widget for room image
  Widget _buildRoomImage(String imagePath) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent,
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for "Thêm ảnh" (Add Image) button
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // Handle add image
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Thêm ảnh', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  // Helper method for detail section
  Widget _buildDetailSection(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
