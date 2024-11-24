import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../../utils/constants/asset_constant.dart';
import '../../../../../utils/resources/validations.dart';

@RoutePage()
class TermOfUseScreen extends HookConsumerWidget with Validations {
  TermOfUseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
          color: Colors.white,
        ),
        title: const Text('Điều Khoản Sử Dụng',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AssetsConstants.mainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Chấp Nhận Điều Khoản',
                'Khi sử dụng ứng dụng MoveMate, bạn đồng ý tuân thủ các điều khoản và điều kiện dưới đây. Nếu không đồng ý với bất kỳ điều khoản nào, vui lòng không sử dụng dịch vụ.'),
            _buildSection(
                '2. Dịch Vụ',
                'MoveMate cung cấp dịch vụ thuê xe tải và hỗ trợ dọn nhà.\n'
                    'Các dịch vụ bổ sung, nếu có, sẽ được thông báo rõ trong ứng dụng trước khi khách hàng sử dụng.\n'
                    '- Hành vi vi phạm: MoveMate có lý do hợp lý để nghi ngờ Khách Hàng có hành vi sử dụng dịch vụ trái phép, bất hợp pháp, gian lận, hoặc vi phạm pháp luật.\n'
                    '- Thanh toán không đầy đủ: Dịch vụ chưa được thanh toán đầy đủ hoặc đúng hạn theo quy định.\n'
                    '- Rủi ro vận hành: Vì bất kỳ lý do nào liên quan đến rủi ro an toàn hoặc vận hành, theo đánh giá hợp lý của MoveMate.'),
            _buildSection(
                '3. Trách Nhiệm của Người Dùng',
                '- Người dùng cam kết cung cấp thông tin chính xác, đầy đủ và chịu trách nhiệm về hoạt động diễn ra dưới tài khoản của mình.\n'
                    '- Người dùng có quyền chỉnh sửa hoặc đổi ngày đặt dịch vụ trước khi xác nhận đặt dịch vụ.\n'
                    '- Việc đổi ngày đặt dịch vụ sau xác nhận chỉ được thực hiện miễn phí một lần. Các thay đổi tiếp theo sẽ áp dụng phí theo quy định.'),
            _buildSection(
                '4. Đặt Dịch Vụ và Chỉnh Sửa',
                'Đặt dịch vụ bằng cách nhập thông tin về loại nhà, loại xe, và các dịch vụ bổ sung trên ứng dụng.\n'
                    '- Trước khi được gán cho nhân viên đánh giá, người dùng có thể chỉnh sửa hoặc hủy đơn đặt.\n'
                    '- Sau khi thanh toán tiền cọc, người dùng không được hủy dịch vụ nếu đã gán tài xế hoặc nhân viên bốc vác.'),
            _buildSection(
                '5. Thanh Toán',
                '- Người dùng thanh toán qua các phương thức: thẻ tín dụng, thẻ ghi nợ, ví điện tử hoặc tiền mặt.\n'
                    '- Đối với hợp đồng khảo sát trực tuyến, khách hàng đặt cọc trước 30% giá trị hợp đồng.\n'
                    '- Đối với hợp đồng khảo sát trực tiếp, khoản đặt cọc là 100.000 VNĐ.\n'
                    '- Phí dịch vụ bổ sung nếu áp dụng.\n'
                    '- Số tiền còn lại sẽ được thanh toán sau khi khách hàng nghiệm thu và xác nhận hoàn thành công việc trên nền tảng MoveMate.'),
            _buildSection(
                '6. Chính Sách Hủy Dịch Vụ',
                '- Việc hủy dịch vụ phải được thực hiện trước giờ dự kiến.\n'
                    '- Nếu hệ thống đã gán tài xế hoặc nhân viên bốc vác, việc hủy sẽ không được hoàn cọc.\n'
                    '- Trong trường hợp lỗi từ phía MoveMate, khách hàng sẽ được hoàn trả toàn bộ số tiền đã thanh toán.'),
            _buildSection(
                '7. Xử Lý Sự Cố và Bồi Thường',
                '- Trong quá trình vận chuyển, nếu xảy ra sự cố, tài xế hoặc nhân viên bốc vác phải thông báo ngay cho hệ thống và khách hàng.\n'
                    '- Bồi thường dựa trên giá trị thực tế của đồ vật trên thị trường tại thời điểm vận chuyển.\n'
                    '- Các tranh chấp sẽ được giải quyết sau khi hoàn tất dịch vụ.'),
            _buildSection(
                '8. Theo Dõi Trực Tiếp và Liên Lạc',
                '- Người dùng có thể theo dõi hành trình của tài xế qua GPS.\n'
                    '- Tính năng chat hoặc gọi điện trong ứng dụng cho phép liên lạc trực tiếp với tài xế và nhân viên bốc vác.'),
            _buildSection(
                '9. Tháo Dỡ và Kiểm Kê Đồ Đạc',
                '- Tài xế và nhân viên bốc vác sẽ phối hợp với khách hàng để kiểm kê số lượng và tình trạng đồ đạc trước và sau khi vận chuyển.\n'
                    '- Hệ thống sẽ ghi lại và lưu trữ thông tin để đảm bảo quyền lợi cho cả hai bên.'),
            _buildSection('10. Quyền Sở Hữu',
                '- Tất cả nội dung, bao gồm văn bản, hình ảnh, và tài nguyên trên ứng dụng MoveMate, thuộc quyền sở hữu của MoveMate và được bảo vệ bởi luật pháp.'),
            _buildSection(
                '11. Sửa Đổi Điều Khoản',
                '- MoveMate có quyền sửa đổi điều khoản và sẽ thông báo qua ứng dụng trước khi áp dụng.\n'
                    '- Người dùng cần kiểm tra điều khoản mới trước khi sử dụng dịch vụ.'),
            _buildSection('12. Liên Hệ',
                'Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi qua email: support@movemate.com hoặc hotline: 0382703625.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
