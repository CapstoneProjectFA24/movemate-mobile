import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';

class IncidentsContentModal extends HookConsumerWidget {
  const IncidentsContentModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: screenHeight * 0.8, // Chiều cao 90% màn hình
      child: Stack(
        children: [
          // Nội dung của modal
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with icons and title
                const Row(
                  mainAxisAlignment: MainAxisAlignment
                      .start, // Giữ phần tử đầu tiên ở bên trái
                  children: [
                    Expanded(
                      child: Text(
                        'Báo cáo sự cố hư hỏng/mất cắp',
                        textAlign:
                            TextAlign.center, // Đảm bảo văn bản nằm ở giữa
                        style: TextStyle(
                          fontSize: 18, // Thu nhỏ một chút
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Important notification section
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          shape: BoxShape.circle,
                        ),
                        width: 50, // Thu nhỏ kích thước vòng tròn
                        height: 50,
                        child: Icon(
                          Icons.error,
                          color: Colors.red[500],
                          size: 32, // Thu nhỏ icon
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lưu ý quan trọng',
                        style: TextStyle(
                          fontSize: 24, // Thu nhỏ kích thước chữ
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chúng tôi cần biết sự cố vỡ bể đồ của bạn trước khi xử lý - bao gồm các sự cố đã được báo cáo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14, // Thu nhỏ kích thước chữ
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Declaration section
                Text(
                  'Vui lòng xác nhận sự cố bạn báo cáo đảm bảo:',
                  style: TextStyle(
                    fontSize: 16, // Thu nhỏ kích thước chữ
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckListItem(
                        'Khai báo tất cả thông tin về đồ vật có giá trị'),
                    _buildCheckListItem('Các sự cố do nhân viên gây ra'),
                    _buildCheckListItem(
                        'Các sự cố liên quan đến đổ vỡ, mất cắp hoặc phá hoại'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nếu bạn bỏ qua bất kỳ sự cố nào, chúng tôi có thể không xử lý được yêu cầu của bạn.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14, // Thu nhỏ kích thước chữ
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Action buttons, cố định ở cuối màn hình
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Đảm bảo nút không kéo dài không gian
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.router.push(const IncidentsScreenRoute());
                    // Add logic for when the user selects this option
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                    foregroundColor:
                        Colors.white, // Use foregroundColor for text color
                    textStyle: const TextStyle(
                        color:
                            Colors.white), // Optional: additional text styling
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đi đến báo cáo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Thu nhỏ kích thước chữ
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Add logic for when the user selects this option
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    foregroundColor: Colors.orange[700], // Orange text color
                    side: BorderSide(
                        color: Colors.orange[700]!, // Orange border
                        width: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: const FittedBox(
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 14, // Thu nhỏ kích thước chữ
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A reusable checklist item widget
  Widget _buildCheckListItem(String text) {
    return Row(
      children: [
        Icon(Icons.help_outline,
            color: Colors.blue[500], size: 24), // Thu nhỏ icon
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16, // Thu nhỏ kích thước chữ
            ),
          ),
        ),
      ],
    );
  }
}
