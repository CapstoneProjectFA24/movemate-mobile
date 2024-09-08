// promotion_list.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/promotion/presentation/promotion_details.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_card.dart';

class PromotionList extends StatelessWidget {
  const PromotionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PromotionDetails(
                  title: 'up to',
                  discount: '50% Off',
                  description:
                      'Get a Discount up to 50% on domestic flights, maximum discount \$30.',
                  code: 'OCTHAPPYFLIGHT',
                  imagePath: 'assets/images/promotion/Ellipse171.png',
                  bgcolor: Colors.deepOrangeAccent,
                  promoPeriod: '1 - 31 Oct, 2023',
                  minTransaction: '120',
                  type: 'All class',
                  destination: 'Domestic',
                ),
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: const PromotionCard(
            title: 'up to',
            discount: '50% Off',
            description: 'On domestic flights',
            code: 'DOMESTIC50',
            imagePath: 'assets/images/promotion/Ellipse171.png',
            bgcolor: Colors.deepOrangeAccent,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PromotionDetails(
                  title: 'up to',
                  discount: '37% Off',
                  description:
                      'Get a Discount up to 50% on domestic flights, maximum discount \$30.',
                  code: 'OCTHAPPYFLIGHT',
                  imagePath: 'assets/images/promotion/Ellipse171.png',
                  bgcolor: Colors.deepOrangeAccent,
                  promoPeriod: '1 - 31 Oct, 2023',
                  minTransaction: '120',
                  type: 'All class',
                  destination: 'Domestic',
                ),
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: const PromotionCard(
            title: 'up to',
            discount: '37% Off',
            description: 'On domestic flights',
            code: 'DOMESTIC50',
            imagePath: 'assets/images/promotion/Ellipse171.png',
            bgcolor: Colors.tealAccent,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PromotionDetails(
                  title: 'up to',
                  discount: '30% Off',
                  description:
                      'Get a Discount up to 50% on domestic flights, maximum discount \$30.',
                  code: 'OCTHAPPYFLIGHT',
                  imagePath: 'assets/images/promotion/Ellipse171.png',
                  bgcolor: Colors.deepOrangeAccent,
                  promoPeriod: '1 - 31 Oct, 2023',
                  minTransaction: '120',
                  type: 'All class',
                  destination: 'Domestic',
                ),
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: const PromotionCard(
            title: 'up to',
            discount: '30% Off',
            description: 'On domestic flights',
            code: 'DOMESTIC30',
            imagePath: 'assets/images/promotion/Ellipse171.png',
            bgcolor: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PromotionDetails(
                  title: 'up to',
                  discount: '25% Off',
                  description:
                      'Get a Discount up to 50% on domestic flights, maximum discount \$25.',
                  code: 'OCTHAPPYFLIGHT',
                  imagePath: 'assets/images/promotion/Ellipse171.png',
                  bgcolor: Colors.deepOrangeAccent,
                  promoPeriod: '1 - 31 Oct, 2023',
                  minTransaction: '120',
                  type: 'All class',
                  destination: 'Domestic',
                ),
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: const PromotionCard(
            title: 'up to',
            discount: '25% Off',
            description: 'On domestic flights',
            code: 'DOMESTIC30',
            imagePath: 'assets/images/promotion/Ellipse171.png',
            bgcolor: Colors.lightGreenAccent,
          ),
        ),
      ],
    );
  }
}
