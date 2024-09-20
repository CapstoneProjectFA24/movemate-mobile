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
        title: const Text('Điều Khoản Sử Dụng'),
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
                'Người dùng cam kết cung cấp thông tin chính xác và đầy đủ khi sử dụng dịch vụ. Bạn chịu trách nhiệm về mọi hoạt động diễn ra dưới tài khoản của mình.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Thanh Toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Người dùng đồng ý thanh toán đầy đủ cho các dịch vụ đã sử dụng theo bảng giá được công bố trên ứng dụng. Các phương thức thanh toán bao gồm thẻ tín dụng, thẻ ghi nợ và ví điện tử.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Chính Sách Hủy Dịch Vụ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Việc hủy dịch vụ phải được thực hiện trước thời gian dự kiến chuyển nhà ít nhất 12 giờ. Nếu không, người dùng sẽ phải chịu một khoản phí hủy dịch vụ.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Trách Nhiệm Pháp Lý',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate không chịu trách nhiệm về bất kỳ thiệt hại, mất mát nào phát sinh từ việc sử dụng dịch vụ. Chúng tôi cam kết cung cấp dịch vụ tốt nhất nhưng không đảm bảo sẽ không có sai sót.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Quyền Sở Hữu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Tất cả nội dung, bao gồm văn bản, hình ảnh, logo và các tài nguyên khác trên ứng dụng đều thuộc quyền sở hữu của MoveMate và được bảo vệ bởi luật sở hữu trí tuệ.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Sửa Đổi Điều Khoản',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate có quyền sửa đổi các điều khoản sử dụng bất kỳ lúc nào. Các thay đổi sẽ được cập nhật trên ứng dụng và có hiệu lực ngay lập tức.',
              ),
              SizedBox(height: 16),
              Text(
                '9. Liên Hệ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Nếu bạn có bất kỳ câu hỏi nào về các điều khoản sử dụng, vui lòng liên hệ chúng tôi qua email: support@movemate.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
