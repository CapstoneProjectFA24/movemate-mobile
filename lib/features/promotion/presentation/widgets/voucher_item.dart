import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Import necessary packages and models
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class VoucherItem extends HookConsumerWidget {
  final PromotionEntity promotionUserGot;

  const VoucherItem({
    super.key,
    required this.promotionUserGot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the service data using the hook
    final state = ref.watch(serviceControllerProvider);
    final useFetchResultService = useFetchObject<ServicesPackageEntity>(
      function: (context) async {
        return ref
            .read(serviceControllerProvider.notifier)
            .getServicesById(promotionUserGot.serviceId, context);
      },
      context: context,
    );

    final serviceData = useFetchResultService.data;
    print("checking service ${serviceData?.name}");

    final formattedDateReviewAt = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(promotionUserGot.endDate.toString()));

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: GestureDetector(
        onTap: () {
          // Clipboard.setData(
          //     ClipboardData(text: promotionUserGot.id.toString()));
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Đã sao chép mã: ${promotionUserGot.id}'),
          //     backgroundColor: Colors.orange[700],
          //   ),
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange[400]!,
                Colors.orange[300]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Decorative side bar
              Container(
                width: 15,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Stack(
                  children: [
                    // Large jagged tooth-like decorations
                    ...List.generate(6, (index) {
                      return Positioned(
                        left: -5,
                        top: 10.0 + (index * 25),
                        child: Container(
                          width: 10,
                          height: index.isEven ? 20.0 : 15.0,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(index.isOdd ? 5 : 10),
                              bottomRight:
                                  Radius.circular(index.isOdd ? 5 : 10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                        ),
                      );
                    }),

                    // Micro teeth between large teeth
                    ...List.generate(5, (index) {
                      return Positioned(
                        left: -2,
                        top: 25.0 + (index * 25),
                        child: Container(
                          width: 5,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 1,
                              )
                            ],
                          ),
                        ),
                      );
                    }),

                    // Gradient overlay for depth
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.card_giftcard,
                          color: Colors.orange[800],
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Voucher details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              promotionUserGot.name.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Giảm tối đa: ${promotionUserGot.discountMax.toInt()}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Dành cho dịch vụ: ${serviceData?.name}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hết hạn: $formattedDateReviewAt',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   'Đã sử dụng cho đơn hàng: $formattedDateReviewAt',
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.copy_rounded,
                      //   color: Colors.orange[800],
                      // ),
                    ],
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
