// // Flutter and external packages
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// // Routing
// import 'package:movemate/features/order/domain/entites/order_entity.dart';
// import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';

// // Data models and entities

// // Controllers

// // Widgets
// import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';

// // Hooks
// import 'package:movemate/hooks/use_booking_status.dart';
// import 'package:movemate/hooks/use_fetch.dart';

// // Services

// // Constants
// import 'package:movemate/utils/constants/asset_constant.dart';

// class BookingHeaderStatusSection extends HookConsumerWidget {
//   final bool isReviewOnline;
//   final OrderEntity order;
//   final FetchResult<OrderEntity> fetchResult;

//   const BookingHeaderStatusSection({
//     super.key,
//     required this.isReviewOnline,
//     required this.order,
//     required this.fetchResult,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
//     final bookingStatus = useBookingStatus(bookingAsync.value, isReviewOnline);
//     print('bookingStatus  statusMessage ${bookingStatus.statusMessage}');
//     print('bookingStatus  statusMessage ${bookingStatus.canConfirmArrival}');
//     print('bookingAsync.value  statusMessage ${bookingAsync.value}');
//     print(
//         'bookingAsync.value?.status  statusMessage ${bookingAsync.value?.status}');
//     return Container(
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildStatusMessage(bookingStatus.statusMessage),
//           const SizedBox(height: 12),
//           _buildTimeline(context, bookingStatus, ref),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusMessage(String statusMessage) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.orange.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         statusMessage,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.orange,
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeline(
//       BuildContext context, BookingStatusResult bookingStatus, WidgetRef ref) {
//     final steps = isReviewOnline
//         ? _buildOnlineReviewerSteps(bookingStatus, context, ref)
//         : _buildOfflineReviewerSteps(bookingStatus, context, ref);

//     return Wrap(
//       spacing: 8,
//       runSpacing: 16,
//       children: _buildTimelineRows(steps),
//     );
//   }

//   List<_TimelineStep> _buildOnlineReviewerSteps(
//       BookingStatusResult status, BuildContext context, WidgetRef ref) {
//     bool isStepCompleted(int currentStep, List<bool> conditions) {
//       for (int i = currentStep; i < conditions.length; i++) {
//         if (conditions[i]) return true;
//       }
//       return false;
//     }

//     final progressionStates = [
//       status.canConfirmReview,
//       status.canUpdateServices,
//       status.canConfirmSuggestion,
//       status.isReviewed,
//       status.isWaitingPayment,
//       status.isCompleted,
//     ];

//     return [
//       _TimelineStep(
//         title: 'Đã tạo',
//         icon: Icons.assignment_ind,
//         isActive: status.canConfirmReview,
//         isCompleted: isStepCompleted(1, progressionStates),
//         action: status.canConfirmReview ? 'Xác nhận' : null,
//         onPressed: status.canConfirmReview
//             ? () => _confirmReviewAssignment(context, ref)
//             : null,
//       ),
//       // _TimelineStep(
//       //   title: 'Cập nhật đơn',
//       //   icon: Icons.edit,
//       //   isActive: status.canUpdateServices,
//       //   isCompleted: isStepCompleted(2, progressionStates),
//       //   action: status.canUpdateServices ? 'Cập nhật' : null,
//       //   onPressed: status.canUpdateServices?() => _navigateToServiceUpdate(context, ref)
//       //       : null,
//       // ),
//       // _TimelineStep(
//       //   title: 'Đề xuất',
//       //   icon: Icons.description,
//       //   isActive: status.canConfirmSuggestion,
//       //   isCompleted: isStepCompleted(3, progressionStates),
//       //   action: status.canConfirmSuggestion ? 'Hoàn thành' : null,
//       //   onPressed: status.canConfirmSuggestion ? () => _completeProposal(context, ref)
//       //       : null,
//       // ),
//       _TimelineStep(
//         title: 'Đang đánh giá',
//         icon: Icons.rate_review,
//         isActive: status.isReviewed,
//         isCompleted: isStepCompleted(4, progressionStates),
//       ),
//       _TimelineStep(
//         title: 'Chờ thanh toán',
//         icon: Icons.payment,
//         isActive: status.isWaitingPayment,
//         isCompleted: isStepCompleted(5, progressionStates),
//       ),
//       _TimelineStep(
//         title: 'Hoàn tất',
//         icon: Icons.check_circle,
//         isActive: status.isCompleted,
//         isCompleted: false,
//       ),
//     ];
//   }

//   List<_TimelineStep> _buildOfflineReviewerSteps(
//       BookingStatusResult status, BuildContext context, WidgetRef ref) {
//     bool isStepCompleted(int currentStep, List<bool> conditions) {
//       for (int i = currentStep; i < conditions.length; i++) {
//         if (conditions[i]) return true;
//       }
//       return false;
//     }

//     final progressionStates = [
//       status.canCreateSchedule,
//       status.isWaitingCustomer || status.isWaitingPayment,
//       status.canConfirmMoving,
//       status.isStaffEnroute,
//       status.canUpdateServices,
//       status.canConfirmSuggestion,
//       status.isReviewed,
//     ];

//     return [
//       // _TimelineStep(
//       //   title: 'Xếp lịch',
//       //   icon: Icons.calendar_today,
//       //   isActive: status.canCreateSchedule,
//       //   isCompleted: isStepCompleted(1, progressionStates),
//       //   action: status.canCreateSchedule ? 'Hẹn' : null,
//       //   onPressed: status.canCreateSchedule? () => _showScheduleDialog(context, ref)
//       //       : null,
//       // ),
//       _TimelineStep(
//         title: 'Chờ thanh toán',
//         icon: Icons.people,
//         isActive: status.isWaitingCustomer || status.isWaitingPayment,
//         isCompleted: isStepCompleted(2, progressionStates),
//       ),
//       _TimelineStep(
//         title: 'Di chuyển',
//         icon: Icons.directions_car,
//         isActive: status.canConfirmMoving,
//         isCompleted: isStepCompleted(3, progressionStates),
//         action: status.canConfirmMoving ? 'Bắt đầu' : null,
//         onPressed:
//             status.canConfirmMoving ? () => _confirmMoving(context, ref) : null,
//       ),
//       _TimelineStep(
//         title: 'Đang đến',
//         icon: Icons.near_me,
//         isActive: status.isStaffEnroute,
//         isCompleted: isStepCompleted(4, progressionStates),
//         action: status.canConfirmArrival ? 'Đã tới' : null,
//         onPressed: status.canConfirmArrival
//             ? () => _confirmArrival(context, ref)
//             : null,
//       ),
//       // _TimelineStep(
//       //   title: 'Cập nhật dịch vụ',
//       //   icon: Icons.edit,
//       //   isActive: status.canUpdateServices,
//       //   isCompleted: isStepCompleted(5, progressionStates),
//       //   action: status.canUpdateServices ? 'Cập nhật' : null,
//       //   onPressed: status.canUpdateServices? () => _navigateToServiceUpdate(context, ref)
//       //       : null,
//       // ),
//       // _TimelineStep(
//       //   title: 'Đề xuất',
//       //   icon: Icons.description,
//       //   isActive: status.canConfirmSuggestion,
//       //   isCompleted: isStepCompleted(6, progressionStates),
//       //   action: status.canConfirmSuggestion ? 'Hoàn thành' : null,
//       //   onPressed: status.canConfirmSuggestion
//       //       ? () => _completeProposal(context, ref)
//       //       : null,
//       // ),
//       _TimelineStep(
//         title: 'Hoàn tất',
//         icon: Icons.check_circle,
//         isActive: status.isReviewed,
//         isCompleted: false,
//       ),
//     ];
//   }

//   List<Widget> _buildTimelineRows(List<_TimelineStep> steps) {
//     final rows = <Widget>[];
//     const itemsPerRow = 4;

//     for (var i = 0; i < steps.length; i += itemsPerRow) {
//       final rowItems = steps.skip(i).take(itemsPerRow).toList();
//       final isEvenRow = (i ~/ itemsPerRow) % 2 == 0;

//       rows.add(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ...rowItems
//                 .map((step) => Expanded(child: _buildTimelineItem(step))),
//             if (rowItems.length < itemsPerRow)
//               ...List.generate(
//                   itemsPerRow - rowItems.length, (_) => const Spacer()),
//           ],
//         ),
//       );

//       if (i + itemsPerRow < steps.length) {
//         rows.add(SizedBox(
//           height: 20,
//           child: CustomPaint(
//               size: const Size(double.infinity, 20),
//               painter: ZigzagConnectorPainter(isEvenRow: isEvenRow)),
//         ));
//       }
//     }

//     return rows;
//   }

//   Widget _buildTimelineItem(_TimelineStep step) {
//     final color = step.isActive
//         ? Colors.orange
//         : step.isCompleted
//             ? Colors.green
//             : Colors.grey;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//               shape: BoxShape.circle, color: color.withOpacity(0.1)),
//           child: Icon(step.isCompleted ? Icons.check : step.icon,
//               color: color, size: 16),
//         ),
//         const SizedBox(height: 4),
//         Text(step.title,
//             style: TextStyle(
//                 fontSize: 12, color: color, fontWeight: FontWeight.w500),
//             textAlign: TextAlign.center),
//         if (step.action != null) ...[
//           const SizedBox(height: 4),
//           TextButton(
//             onPressed: step.onPressed,
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               minimumSize: Size.zero,
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               backgroundColor: color.withOpacity(0.1),
//             ),
//             child: Text(step.action!,
//                 style: TextStyle(color: color, fontSize: 11)),
//           ),
//         ],
//       ],
//     );
//   }

//   // void _showScheduleDialog(BuildContext context, WidgetRef ref) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => ScheduleDialog(
//   //       orderId: order.id.toString(),
//   //       onDateTimeSelected: (DateTime selectedDateTime) async {
//   //         await ref
//   //             .read(reviewerUpdateControllerProvider.notifier)
//   //             .updateCreateScheduleReview(
//   //               request: ReviewerTimeRequest(reviewAt: selectedDateTime),
//   //               id: order.id,
//   //               context: context,
//   //             );
//   //         fetchResult.refresh();
//   //       },
//   //     ),
//   //   );
//   // }

//   void _confirmReviewAssignment(BuildContext context, WidgetRef ref) =>
//       _confirmAction(
//           context, ref, "Xác nhận đánh giá", "Xác nhận", order.id.toString());
//   void _confirmMoving(BuildContext context, WidgetRef ref) => _confirmAction(
//       context, ref, "Bắt đầu di chuyển", "Bắt đầu", order.id.toString());
//   void _confirmArrival(BuildContext context, WidgetRef ref) => _confirmAction(
//       context, ref, "Xác nhận đã tới", "Đã tới", order.id.toString());

//   void _confirmAction(BuildContext context, WidgetRef ref, String title,
//       String action, String orderId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         backgroundColor: AssetsConstants.whiteColor,
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const LabelText(
//                 content: "Đóng",
//                 size: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AssetsConstants.blackColor),
//           ),
//           // TextButton(
//           //   onPressed: () async {
//           //     await ref
//           //         .read(reviewerUpdateControllerProvider.notifier)
//           //         .updateReviewerStatus(id: order.id, context: context);
//           //     fetchResult.refresh();
//           //     Navigator.pop(context);
//           //   },
//           //   child: LabelText(
//           //       content: action,
//           //       size: 16,
//           //       fontWeight: FontWeight.bold,
//           //       color: AssetsConstants.primaryLight),
//           // ),
//         ],
//       ),
//     );
//   }

//   // void _navigateToServiceUpdate(BuildContext context, WidgetRef ref) {
//   //   context.router.push(GenerateNeworderScreenRoute(order: order));
//   // }

//   // void _completeProposal(BuildContext context, WidgetRef ref) {
//   //   final timeController = TextEditingController();
//   //   final timeTypeNotifier = ValueNotifier<String>('hour');

//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text('Xác nhận đề suất cho khách hàng',
//   //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//   //       contentPadding: const EdgeInsets.all(20),
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           const Text('Xác nhận để hoàn thành tiến trình đánh giá',
//   //               style: TextStyle(fontSize: 16, color: Colors.grey),
//   //               textAlign: TextAlign.center),
//   //           const SizedBox(height: 20),
//   //           ValueListenableBuilder(
//   //             valueListenable: timeTypeNotifier,
//   //             builder: (context, timeType, child) => Row(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: ['hour', 'minute'].map((type) {
//   //                 final selected = timeType == type;
//   //                 return Expanded(
//   //                   child: Container(
//   //                     height: 40,
//   //                     margin: const EdgeInsets.symmetric(horizontal: 4),
//   //                     decoration: BoxDecoration(
//   //                       color: selected
//   //                           ? AssetsConstants.primaryLighter.withOpacity(0.2)
//   //                           : Colors.white,
//   //                       borderRadius: BorderRadius.circular(8),
//   //                       border: Border.all(
//   //                           color: selected
//   //                               ? AssetsConstants.primaryLighter
//   //                               : Colors.grey,
//   //                           width: 1.2),
//   //                     ),
//   //                     child: RadioListTile<String>(
//   //                       title: Text(
//   //                         type == 'hour' ? 'Giờ' : 'Phút',
//   //                         style: TextStyle(
//   //                             fontSize: 14,
//   //                             fontWeight: FontWeight.w600,
//   //                             color: selected
//   //                                 ? AssetsConstants.primaryLighter
//   //                                 : Colors.grey),
//   //                       ),
//   //                       value: type,
//   //                       groupValue: timeType,
//   //                       onChanged: (value) {
//   //                         timeTypeNotifier.value = value!;
//   //                         timeController.clear();
//   //                       },
//   //                       contentPadding: EdgeInsets.zero,
//   //                       dense: true,
//   //                       activeColor: AssetsConstants.primaryLighter,
//   //                     ),
//   //                   ),
//   //                 );
//   //               }).toList(),
//   //             ),
//   //           ),
//   //           const SizedBox(height: 16),
//   //           TextField(
//   //             controller: timeController,
//   //             keyboardType: TextInputType.number,
//   //             decoration: InputDecoration(
//   //               labelText:
//   //                   'Thời gian dự kiến (${timeTypeNotifier.value == 'hour' ? 'giờ' : 'phút'})',
//   //               hintText: 'Nhập thời gian dự kiến',
//   //               border:
//   //                   OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//   //               focusedBorder: OutlineInputBorder(
//   //                 borderSide: const BorderSide(
//   //                     color: AssetsConstants.primaryLighter, width: 2),
//   //                 borderRadius: BorderRadius.circular(8),
//   //               ),
//   //               enabledBorder: OutlineInputBorder(
//   //                   borderSide: const BorderSide(color: Colors.grey),
//   //                   borderRadius: BorderRadius.circular(8)),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       backgroundColor: AssetsConstants.whiteColor,
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const LabelText(
//   //               content: "Đóng",
//   //               size: 16,
//   //               fontWeight: FontWeight.bold,
//   //               color: AssetsConstants.blackColor),
//   //         ),
//   //         TextButton(
//   //           onPressed: () async {
//   //             final inputTime = double.tryParse(timeController.text);
//   //             if (inputTime == null) {
//   //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//   //                   content: Text('Vui lòng nhập thời gian hợp lệ')));
//   //               return;
//   //             }
//   //             final estimatedTime = timeTypeNotifier.value == 'minute'
//   //                 ? inputTime / 60
//   //                 : inputTime;
//   //             // await ref
//   //             //     .read(reviewerUpdateControllerProvider.notifier)
//   //             //     .updateReviewerStatus(
//   //             //       id: order.id,
//   //             //       context: context,
//   //             //       request: ReviewerStatusRequest(
//   //             //           estimatedDeliveryTime: estimatedTime),
//   //             //     );
//   //             fetchResult.refresh();
//   //             Navigator.pop(context);
//   //           },
//   //           child: const LabelText(
//   //               content: "Xác nhận",
//   //               size: 16,
//   //               fontWeight: FontWeight.bold,
//   //               color: AssetsConstants.primaryLight),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }

// class _TimelineStep {
//   final String title;
//   final IconData icon;
//   final bool isActive;
//   final bool isCompleted;
//   final String? action;
//   final VoidCallback? onPressed;

//   _TimelineStep({
//     required this.title,
//     required this.icon,
//     required this.isActive,
//     required this.isCompleted,
//     this.action,
//     this.onPressed,
//   });
// }

// class ZigzagConnectorPainter extends CustomPainter {
//   final bool isEvenRow;

//   ZigzagConnectorPainter({required this.isEvenRow});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final path = Path();
//     final segmentWidth = size.width / 4;

//     if (isEvenRow) {
//       path.moveTo(segmentWidth / 2, 0);
//       path.lineTo(size.width - segmentWidth / 2, size.height);
//     } else {
//       path.moveTo(size.width - segmentWidth / 2, 0);
//       path.lineTo(segmentWidth / 2, size.height);
//     }

//     canvas.drawPath(
//         path,
//         Paint()
//           ..color = Colors.grey.withOpacity(0.3)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.0);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
