import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/utils/commons/widgets/promotion_layout/widget/promotion_model.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

final promotionProvider = Provider<List<Promotion>>((ref) {
  return [
    Promotion(
      title: 'up to',
      discount: '50% Off',
      description:
          'Get a Discount up to 50% on domestic flights, maximum discount \$30.',
      code: 'OCTHAPPYFLIGHT',
      imagePath: 'assets/images/promotion/Ellipse171.png',
      bgcolor: AssetsConstants.blue4,
      promoPeriod: '1 - 31 Oct, 2023',
      minTransaction: '120',
      type: 'All class',
      destination: 'Domestic',
    ),
    Promotion(
      title: 'up to',
      discount: '37% Off',
      description:
          'Get a Discount up to 37% on domestic flights, maximum discount \$30.',
      code: 'OCTHAPPYFLIGHT',
      imagePath: 'assets/images/promotion/Ellipse171.png',
      bgcolor: AssetsConstants.beaminColor,
      promoPeriod: '1 - 31 Oct, 2023',
      minTransaction: '120',
      type: 'All class',
      destination: 'Domestic',
    ),
    Promotion(
      title: 'up to',
      discount: '30% Off',
      description:
          'Get a Discount up to 50% on domestic flights, maximum discount \$30.',
      code: 'OCTHAPPYFLIGHT',
      imagePath: 'assets/images/promotion/Ellipse171.png',
      bgcolor: AssetsConstants.purple3,
      promoPeriod: '1 - 31 Oct, 2023',
      minTransaction: '120',
      type: 'All class',
      destination: 'Domestic',
    ),
    Promotion(
      title: 'up to',
      discount: '17% Off',
      description:
          'Get a Discount up to 37% on domestic flights, maximum discount \$30.',
      code: 'OCTHAPPYFLIGHT',
      imagePath: 'assets/images/promotion/Ellipse171.png',
      bgcolor: AssetsConstants.grabColor,
      promoPeriod: '1 - 31 Oct, 2023',
      minTransaction: '120',
      type: 'All class',
      destination: 'Domestic',
    ),
    // Add more promotions here or fetch from an API.
  ];
});
