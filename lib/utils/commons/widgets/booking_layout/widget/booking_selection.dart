//order_model.dart
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showRoomCountModal(context),
                child: _buildSelectionButton(
                  label: 'Số phòng ngủ: $numberOfRooms',
                  icon: Icons.arrow_drop_down,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _showFloorCountModal(context),
                child: _buildSelectionButton(
                  label: 'Số tầng: $numberOfFloors',
                  icon: Icons.arrow_drop_down,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper widget for selection buttons
  Widget _buildSelectionButton(
      {required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AssetsConstants.greyColor[400],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AssetsConstants.greyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AssetsConstants.blackColor)),
          Icon(icon, color: AssetsConstants.blue1),
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
              color: Colors.white,
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
                          style: TextStyle(color: AssetsConstants.blackColor),
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
              color: Colors.white,
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
                          style: TextStyle(color: AssetsConstants.blackColor),
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
              color: Colors.white,
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
                          style: TextStyle(color: AssetsConstants.blackColor),
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
