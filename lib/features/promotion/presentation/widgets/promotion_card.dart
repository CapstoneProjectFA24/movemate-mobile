import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';

class PromotionCard extends StatelessWidget {
  final PromotionEntity promotion;

  const PromotionCard({
    super.key,
    required this.promotion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Giảm padding dọc
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
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
          padding: const EdgeInsets.all(8.0), // Giảm padding bên trong
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Discount Badge at top
              Positioned(
                top: -15, // Thu nhỏ vị trí của badge
                right: -5, // Thu nhỏ khoảng cách bên phải
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8), // Giảm padding badge
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F00),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '-${promotion.discountRate}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Main Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8), // Giảm khoảng cách đầu tiên

                  // Header with logo and title
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(4), // Giảm kích thước icon
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.ticket,
                          color: Colors.orange.shade700,
                          size: 14, // Giảm kích thước icon
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Giảm khoảng cách giữa icon và tiêu đề
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              promotion.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              promotion.type,
                              style: TextStyle(
                                fontSize: 11, // Giảm kích thước font của loại
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.info_outlined,
                      //   color: Colors.grey.shade400,
                      //   size: 18, // Giảm kích thước icon
                      // ),
                    ],
                  ),
                  const SizedBox(
                      height: 6), // Giảm khoảng cách giữa các phần tử

                  // Description
                  Text(
                    promotion.description,
                    style: TextStyle(
                      fontSize: 11, // Giảm kích thước font
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8), // Giảm khoảng cách

                  // Discount Info Container
                  Container(
                    padding: const EdgeInsets.all(6), // Giảm padding
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.tag,
                          color: Colors.orange.shade700,
                          size: 12, // Giảm kích thước icon
                        ),
                        const SizedBox(
                            width: 6), // Giảm khoảng cách giữa icon và text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giảm ${promotion.discountRate}% cho đơn hàng',
                                style: TextStyle(
                                  fontSize: 12, // Giảm kích thước font
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Từ ${promotion.discountMin}\$ - ${promotion.discountMax}\$',
                                style: TextStyle(
                                  fontSize: 11, // Giảm kích thước font
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3), // Giảm padding
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                promotion.isPublic
                                    ? Icons.public
                                    : Icons.lock_outline,
                                color: Colors.orange.shade700,
                                size: 10, // Giảm kích thước icon
                              ),
                              const SizedBox(width: 4),
                              Text(
                                promotion.isPublic ? 'Công khai' : 'Riêng tư',
                                style: TextStyle(
                                  fontSize: 10, // Giảm kích thước font
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), // Giảm khoảng cách

                  // Footer Info
                  Row(
                    children: [
                      // Date Info
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14, // Giảm kích thước icon
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'HSD: ${DateFormat('dd/MM/yy').format(promotion.endDate)}',
                              style: TextStyle(
                                fontSize: 11, // Giảm kích thước font
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity Info
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3), // Giảm padding
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              promotion.isInfinite
                                  ? Icons.all_inclusive
                                  : FontAwesomeIcons.ticket,
                              size: 10, // Giảm kích thước icon
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              promotion.isInfinite
                                  ? 'Không giới hạn'
                                  : 'Còn ${promotion.quantity}',
                              style: TextStyle(
                                fontSize: 10, // Giảm kích thước font
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
