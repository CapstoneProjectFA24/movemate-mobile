import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:uni_links/uni_links.dart';
import 'package:movemate/configs/routes/app_router.dart';

final paymentResultProvider = StateProvider<bool?>((ref) => null);

Future<void> initUniLinks(BuildContext context, WidgetRef ref) async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(initialLink, ref);
    }
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri.toString(), ref);
      }
    }, onError: (err) {
      print('Error processing deep link: $err');

      showSnackBar(
        context: context,
        content: "Không truy cập được deep link",
        icon: AssetsConstants.iconError,
        backgroundColor: Colors.red,
        textColor: AssetsConstants.whiteColor,
      );
    });
  } on PlatformException {
    print('Failed to get initial link.');
    showSnackBar(
      context: context,
      content: "Không lấy được deep link",
      icon: AssetsConstants.iconError,
      backgroundColor: Colors.red,
      textColor: AssetsConstants.whiteColor,
    );
  }
}

void handleDeepLink(String link, WidgetRef ref) {
  print('Received deep link: $link');

  if (link.startsWith('movemate://payment-result')) {
    final uri = Uri.parse(link);
    final isSuccess = uri.queryParameters['isSuccess'] == 'true';

    ref.read(paymentResultProvider.notifier).state = isSuccess;
    ref
        .read(appRouterProvider)
        .push(TransactionResultScreenRoute(isSuccess: isSuccess));
  }
}

// void handleDeepLink(String link, WidgetRef ref) async {
//   print('Received deep link: $link');

//   if (link.startsWith('movemate://payment-result')) {
//     final uri = Uri.parse(link);
//     final isSuccess = uri.queryParameters['isSuccess'] == 'true';
//     final orderId = uri.queryParameters['orderId'];

//     if (orderId != null) {
//       // Giả sử bạn có một phương thức để lấy OrderEntity dựa trên orderId
//       final order = await fetchOrderById(orderId, ref);
      
//       if (order != null) {
//         ref.read(paymentResultProvider.notifier).state = isSuccess;
//         ref.read(appRouterProvider).push(TransactionResultScreenRoute(
//           isSuccess: isSuccess,
//           order: order,
//         ));
//       } else {
//         // Xử lý khi không tìm thấy đơn hàng
//         showSnackBar(
//           context: context,
//           content: "Đơn hàng không tồn tại",
//           icon: AssetsConstants.iconError,
//           backgroundColor: Colors.red,
//           textColor: AssetsConstants.whiteColor,
//         );
//       }
//     } else {
//       // Xử lý khi không có orderId trong deep link
//       showSnackBar(
//         context: context,
//         content: "Không tìm thấy ID đơn hàng trong deep link",
//         icon: AssetsConstants.iconError,
//         backgroundColor: Colors.red,
//         textColor: AssetsConstants.whiteColor,
//       );
//     }
//   }
// }

// // Ví dụ phương thức fetchOrderById
// Future<OrderEntity?> fetchOrderById(String orderId, WidgetRef ref) async {
//   // Thực hiện logic để lấy OrderEntity từ repository hoặc provider dựa trên orderId
//   // Ví dụ:
//   try {
//     final orderRepository = ref.read(orderRepositoryProvider);
//     final order = await orderRepository.getOrderById(orderId);
//     return order;
//   } catch (e) {
//     print('Error fetching order by id: $e');
//     return null;
//   }
// }
