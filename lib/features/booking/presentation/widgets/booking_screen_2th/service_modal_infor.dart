import 'package:flutter/material.dart';

class ServiceInfoModal extends StatelessWidget {
  final String title;
  final String ? imagePath; // Image path

  const ServiceInfoModal({
    super.key,
    required this.title,
     this.imagePath, // Added property for image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full-screen width
      height: MediaQuery.of(context).size.height *
          (2 / 3), // 2/3 of the screen height
      color: Colors.white, // Set background color to white
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max, // Take up available space
            crossAxisAlignment: CrossAxisAlignment.center, // Center align items
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close modal
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Illustration image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Circular image
                  color: Colors.orange.shade100, // Background color for image
                ),
                child: Image.asset(
                  imagePath!, // Replace with image path
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange, // Title color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Detailed information text
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Package details

                      Text(
                        "Chi tiết gói chuyển nhà:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "- 1 nhân viên hỗ trợ bốc xếp: 300.000 đ\n"
                        "- Dịch vụ bốc xếp 2 chiều (1 trệt + 1 lầu): 240.000 đ\n"
                        "- Phí chờ (1 giờ): 60.000 đ",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Note section
                      Text(
                        "Lưu ý:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "- Phạm vi bốc xếp: Không quá 50m và tối đa 1 lầu (1 trệt + 1 lầu) & cả điểm lấy hàng và điểm giao hàng.\n"
                        "- Vui lòng đóng gói tất cả hàng hóa hoặc tháo dỡ các thiết bị điện lạnh, nội thất trước khi đặt dịch vụ.\n"
                        "- Trường hợp có phát sinh thêm nhu cầu bốc xếp ngoài dịch vụ, vui lòng liên hệ tổng đài 1900545411 để được tư vấn.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // Space before adding the button
              // Add Button
              Container(
                width: double.infinity, // Full modal width
                height: 48, // Button height
                margin: const EdgeInsets.symmetric(
                    horizontal: 16), // Horizontal margin
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Button corner radius
                    ),
                  ),
                  onPressed: () {
                    // Action when button is pressed
                    Navigator.pop(context); // Đóng modal
                  },
                  child: const Text(
                    'Thêm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
