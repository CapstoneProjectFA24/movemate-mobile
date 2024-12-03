import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

@RoutePage()
class CartVoucherScreen extends HookConsumerWidget {
  final List<String> vouchers;

  const CartVoucherScreen({super.key, required this.vouchers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promotionControllerProvider);
    final useFetchResult = useFetchObject<PromotionAboutUserEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionNoUser(context),
      context: context,
    );
    final promotionAboutUser = useFetchResult.data;

    final promotionUserGot = promotionAboutUser?.promotionUser ?? [];

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E0), // Light orange background
        appBar: AppBar(
          title: Text(
            'Mã Voucher Của Tôi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.orange[900]),
        ),
        body: promotionUserGot.isEmpty
            ? _buildEmptyVoucherState(context)
            : _buildVoucherGrid(
                context: context, promotionUserGot: promotionUserGot),
      ),
    );
  }

  Widget _buildEmptyVoucherState(
    BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard,
            size: 200,
            color: Colors.orange[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Bạn chưa có mã voucher nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange[900],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to voucher collection screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Khám phá Voucher',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherGrid(
      {required BuildContext context,
      required List<PromotionEntity> promotionUserGot}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        itemCount: promotionUserGot.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildVoucherCard(
              context: context, promotionUserGot: promotionUserGot[index]);
        },
      ),
    );
  }

  Widget _buildVoucherCard(
      {required BuildContext context,
      required PromotionEntity promotionUserGot}) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: promotionUserGot.id.toString()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã sao chép mã: ${promotionUserGot.id}'),
            backgroundColor: Colors.orange[700],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange[100]!,
              Colors.orange[200]!,
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
                  // Large jagged tooth-like decorations with varied sizes and positions
                  ...List.generate(6, (index) {
                    return Positioned(
                      left: -5,
                      top: 10.0 + (index * 25),
                      child: Container(
                        width: 10,
                        height: index.isEven ? 20.0 : 15.0, // Varied heights
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(index.isOdd ? 5 : 10),
                            bottomRight: Radius.circular(index.isOdd ? 5 : 10),
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

                  // Optional: Add a subtle gradient overlay for depth
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            promotionUserGot.id.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hết hạn: 31/12/2023',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.copy_rounded,
                      color: Colors.orange[800],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
