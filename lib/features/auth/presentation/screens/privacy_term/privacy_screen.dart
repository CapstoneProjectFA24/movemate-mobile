import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../../utils/constants/asset_constant.dart';
import '../../../../../utils/resources/validations.dart';

@RoutePage()
class PrivacyPolicyScreen extends HookConsumerWidget with Validations {
  PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
          color: Colors.white,
        ),
        title: const Text('Chính Sách Bảo Mật',
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
                '1. Thu Thập Thông Tin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Chúng tôi thu thập thông tin cá nhân của bạn khi bạn đăng ký tài khoản, sử dụng dịch vụ, hoặc liên hệ với chúng tôi. Thông tin bao gồm tên, địa chỉ, số điện thoại, email và các chi tiết liên quan đến dịch vụ.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Sử Dụng Thông Tin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Thông tin thu thập được sử dụng để cung cấp và cải thiện dịch vụ, xử lý thanh toán, và liên lạc với bạn về các cập nhật hoặc khuyến mãi.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Bảo Vệ Thông Tin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn bằng cách sử dụng các biện pháp bảo mật tiên tiến. Thông tin thanh toán được mã hóa và xử lý qua các cổng thanh toán bảo mật.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Chia Sẻ Thông Tin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate không chia sẻ thông tin cá nhân của bạn với bên thứ ba trừ khi cần thiết để cung cấp dịch vụ hoặc tuân theo yêu cầu pháp lý.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Quyền Của Người Dùng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Bạn có quyền truy cập, chỉnh sửa hoặc yêu cầu xóa thông tin cá nhân của mình bất kỳ lúc nào bằng cách liên hệ với chúng tôi qua email: support@movemate.com.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Cookie',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Chúng tôi sử dụng cookie để cải thiện trải nghiệm người dùng và theo dõi các hoạt động trên ứng dụng. Bạn có thể tắt cookie trong cài đặt trình duyệt của mình, nhưng điều này có thể ảnh hưởng đến trải nghiệm sử dụng.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Thay Đổi Chính Sách',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'MoveMate có quyền thay đổi chính sách bảo mật bất kỳ lúc nào. Các thay đổi sẽ được cập nhật trên ứng dụng và có hiệu lực ngay lập tức.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Liên Hệ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Nếu bạn có bất kỳ câu hỏi nào về chính sách bảo mật, vui lòng liên hệ chúng tôi qua email: support@movemate.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
