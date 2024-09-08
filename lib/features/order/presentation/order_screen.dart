import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedHouseType;
  int numberOfRooms = 1;
  int numberOfFloors = 1;

  final List<String> houseTypes = ['Nhà riêng', 'Nhà trọ', 'Căn hộ', 'Công ty'];

  // Room images
  final List<String> livingRoomImages = [];
  final List<String> bedroomImages = [
    // "assets/images/bedroom1.png",
    // "assets/images/bedroom2.png",
    // "assets/images/bedroom3.png"
  ];
  final List<String> diningRoomImages = [];
  final List<String> officeRoomImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        // Enables vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHouseTypeDropdown(),
              const SizedBox(height: 16),
              _buildRoomAndFloorCount(),
              const SizedBox(height: 16),

              // Room Image Sections
              _buildRoomImageSection('Phòng khách', livingRoomImages),
              const SizedBox(height: 16),
              _buildRoomImageSection('Phòng ngủ', bedroomImages),
              const SizedBox(height: 16),
              _buildRoomImageSection('Phòng ăn', diningRoomImages),
              const SizedBox(height: 16),
              _buildRoomImageSection('Phòng làm việc', officeRoomImages),
              const SizedBox(height: 16),

              // Submit Button
              _buildSubmitButton(), // Moves the button below all content
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Thông tin đặt hàng'),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      // leading: IconButton(
      //   // icon: const Icon(Icons.arrow_back, color: Colors.black),
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
    );
  }

  // Modal for House Type Dropdown Selection
  Widget _buildHouseTypeDropdown() {
    return GestureDetector(
      onTap: () => _showHouseTypeModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedHouseType ?? 'Chọn loại nhà ở',
              style: const TextStyle(color: Colors.black54),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  // Modal for Room and Floor Count Dropdowns
  Widget _buildRoomAndFloorCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showRoomCountModal(context),
            child: _buildModalButton('Số phòng ngủ', numberOfRooms.toString()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _showFloorCountModal(context),
            child: _buildModalButton('Số tầng', numberOfFloors.toString()),
          ),
        ),
      ],
    );
  }

  // Room Image Section with images and "Thêm ảnh" (Add Image) button
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
            itemCount: images.length + 1, // Extra item for Add Image button
            itemBuilder: (context, index) {
              return (index == images.length)
                  ? _buildAddImageButton() // "Thêm ảnh" button
                  : _buildRoomImage(images[index]); // Display image
            },
          ),
        ),
      ],
    );
  }

  // Widget for displaying room images
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

  // "Thêm ảnh" (Add Image) button
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // Handle add image action
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

  // Helper method for creating modal buttons
  Widget _buildModalButton(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  // Submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle continue button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Tiếp tục', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  // Method to show modal for house type selection
  void _showHouseTypeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: houseTypes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(houseTypes[index]),
              onTap: () {
                setState(() {
                  selectedHouseType = houseTypes[index];
                });
                Navigator.pop(context); // Close modal
              },
            );
          },
        );
      },
    );
  }

  // Method to show modal for room count selection
  void _showRoomCountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 10, // Max room count is 10
          itemBuilder: (context, index) {
            return ListTile(
              title: Text((index + 1).toString()),
              onTap: () {
                setState(() {
                  numberOfRooms = index + 1;
                });
                Navigator.pop(context); // Close modal
              },
            );
          },
        );
      },
    );
  }

  // Method to show modal for floor count selection
  void _showFloorCountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 10, // Max floor count is 10
          itemBuilder: (context, index) {
            return ListTile(
              title: Text((index + 1).toString()),
              onTap: () {
                setState(() {
                  numberOfFloors = index + 1;
                });
                Navigator.pop(context); // Close modal
              },
            );
          },
        );
      },
    );
  }
}
