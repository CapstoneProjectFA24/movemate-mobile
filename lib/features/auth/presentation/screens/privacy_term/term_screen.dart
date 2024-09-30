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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Chấp Nhận Điều Khoản',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Bằng việc sử dụng ứng dụng MoveMate, bạn đồng ý với các điều khoản và điều kiện dưới đây. Nếu bạn không đồng ý với bất kỳ điều khoản nào, vui lòng không sử dụng ứng dụng.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Dịch Vụ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate cung cấp dịch vụ thuê xe tải và hỗ trợ dọn nhà. Chúng tôi có quyền thay đổi hoặc ngừng cung cấp dịch vụ bất kỳ lúc nào mà không cần thông báo trước.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Trách Nhiệm của Người Dùng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Người dùng cam kết cung cấp thông tin chính xác và đầy đủ khi sử dụng dịch vụ. Bạn chịu trách nhiệm về mọi hoạt động diễn ra dưới tài khoản của mình. Khi đổi ngày đặt dịch vụ người dùng được quyền đổi trước',
              ),
              SizedBox(height: 16),
              Text(
                '4. Đặt Dịch Vụ và Chỉnh Sửa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Người dùng có thể đặt dịch vụ bằng cách nhập các thông tin liên quan như loại nhà, loại xe, và các dịch vụ bổ sung.\n'
                '• Sau khi gửi đơn đặt dịch vụ và trước khi được gán cho nhân viên đánh giá, người dùng có thể chỉnh sửa hoặc hủy đơn đặt dịch vụ.\n'
                '• Sau khi được gán, người dùng chỉ có thể chỉnh sửa ngày đặt dịch vụ.\n'
                '• Để cập nhật thêm, người dùng có thể liên lạc với nhân viên đánh giá qua ứng dụng thông qua chat hoặc gọi điện.\n'
                '• Nhân viên đánh giá có thể cập nhật đơn đặt và gửi cho người dùng để xác nhận.\n'
                '• Khi đơn đặt được xác nhận, người dùng sẽ tiến hành thanh toán tiền cọc.\n'
                '• Người dùng có quyền thay đổi ngày đặt dịch vụ một lần miễn phí sau khi xác nhận đơn đặt.\n'
                '• Việc hủy dịch vụ sau quá trình xác nhận có thể phải chịu các khoản phí theo quy định của MoveMate.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Thanh Toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Người dùng đồng ý thanh toán đầy đủ cho các dịch vụ đã sử dụng theo bảng giá được công bố trên ứng dụng. Các phương thức thanh toán bao gồm thẻ tín dụng, thẻ ghi nợ và ví điện tử.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Chính Sách Hủy Dịch Vụ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Việc hủy dịch vụ phải được thực hiện ít nhất 24 giờ trước thời gian dự kiến dọn nhà.\n'
                '• Sau khi hệ thống đã gán tài xế hoặc nhân viên bốc vác (và họ đã xác nhận đến), việc hủy sẽ không được chấp nhận, và khoản tiền cọc đã thanh toán sẽ không được hoàn lại.\n'
                '• Trong trường hợp có sự cố (ví dụ: không có xe hoặc nhân viên bốc vác), MoveMate sẽ gán lại xe hoặc nhân viên trong thời gian sớm nhất có thể.\n'
                '• Nếu không tìm được giải pháp ngay, nhân viên đánh giá sẽ liên hệ với khách hàng để thảo luận về các tùy chọn, bao gồm việc dời lịch hoặc hủy dịch vụ, có thể hoàn trả cọc.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Xử Lý Sự Cố và Thay Đổi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Trong quá trình di chuyển, nếu có sự cố (ví dụ: làm hư hại đồ đạc hoặc cần bổ sung dịch vụ), tài xế hoặc nhân viên bốc vác sẽ thông báo cho hệ thống và khách hàng để giải quyết.\n'
                '• Khách hàng có thể cung cấp giá trị ước tính của hàng hóa bị hư hại, hệ thống sẽ gửi thông báo để nhân viên xem xét.\n'
                '• Các tranh chấp sẽ được xử lý sau khi quá trình chuyển nhà đã hoàn tất, nhân viên giải quyết bồi thường sẽ đến tận nhà giám định và xác nhận bồi thường thiệt hại lên đến 70% giá trị hàng hóa cho khách hàng.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Theo Dõi Trực Tiếp và Liên Lạc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Người dùng có thể theo dõi tình trạng di chuyển của tài xế và nhân viên bốc vác qua GPS trên ứng dụng.\n'
                '• Tài xế và nhân viên bốc vác sẽ thông báo cho khách hàng nếu có chậm trễ do giao thông hoặc các vấn đề khác.\n'
                '• Cả hai bên có thể giao tiếp qua tính năng chat hoặc gọi điện trong ứng dụng.',
              ),
              SizedBox(height: 16),
              Text(
                '9. Tháo Dỡ và Kiểm Kê Đồ Đạc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Sau khi đến nơi, tài xế và nhân viên bốc vác sẽ tiến hành tháo dỡ và kiểm kê đồ đạc cùng với khách hàng.\n'
                '• Hệ thống sẽ ghi lại số lượng và tình trạng hàng hóa, và khách hàng có thể xác nhận hoặc báo cáo hư hỏng.',
              ),
              SizedBox(height: 16),
              Text(
                '10. Quyền Sở Hữu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Tất cả nội dung trên ứng dụng, bao gồm văn bản, hình ảnh, logo và các tài nguyên khác, đều thuộc quyền sở hữu của MoveMate và được bảo vệ bởi luật sở hữu trí tuệ.',
              ),
              SizedBox(height: 16),
              Text(
                '10. Sửa Đổi Điều Khoản',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate có quyền sửa đổi các điều khoản sử dụng bất kỳ lúc nào. Các thay đổi sẽ được cập nhật trên ứng dụng và có hiệu lực ngay lập tức.',
              ),
              SizedBox(height: 16),
              Text(
                '10. Liên Hệ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Nếu bạn có bất kỳ câu hỏi nào về các điều khoản sử dụng, vui lòng liên hệ với chúng tôi qua email: support@movemate.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
