import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';

import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class DiscountCodesWidget extends HookConsumerWidget {
  const DiscountCodesWidget({super.key});

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

    final promotionUserNotGet = promotionAboutUser?.promotionNoUser ?? [];
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(125, 255, 204, 128),
              Colors.orange.shade700,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Mã Khuyến Mãi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                  itemCount: promotionUserNotGet.length,
                  itemBuilder: (context, index) {
                    final promo = promotionUserNotGet[index];

//                            VuochersCard(
//                             promoCode: 'MOVEMATESALE',
//                             description: 'Giảm ngay 99% mọi đơn',
//                             companyLogo:
//                                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrJzam42WkZj1p3UDnYjduuv7dtyB51i_yGQ&s',
//                           ),

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: VuochersCard(
                        promoCode: promo.id
                            .toString(), // Assuming `promo.code` is available
                        description: promo
                            .description, // Assuming `promo.description` is available
                        companyLogo:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrJzam42WkZj1p3UDnYjduuv7dtyB51i_yGQ&s', // Assuming `promo.companyLogo` is available
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VuochersCard extends StatelessWidget {
  final String promoCode;
  final String description;
  final String companyLogo;

  const VuochersCard({
    super.key,
    required this.promoCode,
    required this.description,
    required this.companyLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Badge
            Positioned(
              top: -10,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Ưu đãi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Image.network(
                      companyLogo,
                      width: 30,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported,
                            color: Colors.grey);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Ưu đãi MoveMate',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.info_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.copy,
                        color: Color(0xFFFF6F00),
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          promoCode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: promoCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã sao chép mã $promoCode!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'SAO CHÉP',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
