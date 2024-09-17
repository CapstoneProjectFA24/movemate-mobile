import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class BookingSelection extends StatefulWidget {
  final Function(String)? onHouseTypeSelected;
  final Function(int)? onRoomCountSelected;
  final Function(int)? onFloorCountSelected;

  const BookingSelection({
    super.key,
    this.onHouseTypeSelected,
    this.onRoomCountSelected,
    this.onFloorCountSelected,
  });

  @override
  _BookingSelectionState createState() => _BookingSelectionState();
}

class _BookingSelectionState extends State<BookingSelection> {
  String? selectedHouseType;
  int numberOfRooms = 1;
  int numberOfFloors = 1;

  final List<String> houseTypes = ['Nhà riêng', 'Nhà trọ', 'Căn hộ', 'Công ty'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // House Type Selection Button
        GestureDetector(
          onTap: () => _showHouseTypeModal(context),
          child: _buildSelectionButton(
            label: selectedHouseType ?? 'Chọn loại nhà ở',
            icon: Icons.arrow_drop_down,
          ),
        ),
        const SizedBox(height: 16),

        // Room and Floor Count Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildRoomFloorCountButton(
                label: 'Số phòng ngủ',
                value: numberOfRooms,
                onTap: () => _showRoomCountModal(context),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('-',
                  style: TextStyle(
                      fontSize: 24, color: AssetsConstants.greyColor)),
            ),
            Expanded(
              child: _buildRoomFloorCountButton(
                label: 'Số tầng',
                value: numberOfFloors,
                onTap: () => _showFloorCountModal(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Room/Floor count button with customized style
  Widget _buildRoomFloorCountButton({
    required String label,
    required int value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AssetsConstants.greyColor.withOpacity(0.2), // Nền xám mờ
          borderRadius: BorderRadius.circular(16), // Bo góc tròn
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AssetsConstants.greyColor, // Màu xám cho nhãn
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: AssetsConstants.whiteColor, // Nền trắng cho số lượng
                    shape: BoxShape.circle, // Hình tròn
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AssetsConstants.blackColor, // Màu đen cho số
                    ),
                  ),
                ),
                const SizedBox(width: 4), // Khoảng cách giữa số và icon
                const Icon(Icons.arrow_drop_down,
                    color: AssetsConstants.primaryDark), // Màu xanh cho icon
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for selection buttons
  Widget _buildSelectionButton(
      {required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AssetsConstants.greyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AssetsConstants.blackColor,
            ),
          ),
          Icon(icon, color: AssetsConstants.primaryDark),
        ],
      ),
    );
  }

  // House Type Modal
  void _showHouseTypeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn loại nhà ở',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: houseTypes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          houseTypes[index],
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                        ),
                        onTap: () {
                          setState(() {
                            selectedHouseType = houseTypes[index];
                          });
                          widget.onHouseTypeSelected?.call(houseTypes[index]);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Room Count Modal
  void _showRoomCountModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số lượng phòng ngủ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            numberOfRooms = index + 1;
                          });
                          widget.onRoomCountSelected?.call(index + 1);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Floor Count Modal
  void _showFloorCountModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AssetsConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số lượng tầng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              color: AssetsConstants.blackColor),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            numberOfFloors = index + 1;
                          });
                          widget.onFloorCountSelected?.call(index + 1);
                          Navigator.pop(context); // Close modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
