// import 'package:flutter/material.dart';
// import 'package:movemate/features/order/data/models/order_models.dart';
// import 'package:movemate/utils/constants/asset_constant.dart';

// class PaymentInfo extends StatelessWidget {
//   final PaymentInfoModel paymentInfo;

//   const PaymentInfo({
//     super.key,
//     required this.paymentInfo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AssetsConstants.whiteColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Chi tiết đơn hàng',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: AssetsConstants.blackColor,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//               decoration: BoxDecoration(
//                 color: AssetsConstants.transparentColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title "Chi tiết đơn hàng"
//                   const SizedBox(height: 16),

//                   // Header for Payment section with expand icon
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Thanh toán',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: AssetsConstants.blackColor,
//                         ),
//                       ),
//                       Icon(
//                         Icons.expand_more,
//                         color: AssetsConstants.greyColor,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           // Money icon with background
//                           Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: AssetsConstants.greenish,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Icon(
//                               Icons.attach_money,
//                               color: AssetsConstants.green1,
//                               size: 18,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           // Payment method text
//                           Text(
//                             paymentInfo.paymentMethod,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: AssetsConstants.blackColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Payment amount
//                       Text(
//                         paymentInfo.paymentAmount,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: AssetsConstants.blackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 8),
//                   // Order ID and time
//                   Text(
//                     'Mã đơn hàng: ${paymentInfo.orderId}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: AssetsConstants.blackColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     paymentInfo.orderTime,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AssetsConstants.greyColor,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Distance and vehicle type in a decorated container
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: AssetsConstants.greyColor.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Distance
//                         Column(
//                           children: [
//                             const Text(
//                               '10,2 km',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Quãng đường',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: AssetsConstants.greyColor.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Vehicle type wrapped in a container with BoxDecoration
//                         Text(
//                           paymentInfo.vehicleType,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: AssetsConstants.blackColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
