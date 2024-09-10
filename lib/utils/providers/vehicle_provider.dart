import 'package:hooks_riverpod/hooks_riverpod.dart';

// Vehicle provider (This would be replaced with an API call later)
final availableVehiclesProvider =
    StateProvider<List<Map<String, String>>>((ref) => [
          {
            'title': 'Xe Máy',
            'description':
                'Vận chuyển mặt hàng nhỏ trị giá đến 3 triệu đồng, Vận chuyển mặt hàng nhỏ trị giá đến 3 triệu đồng',
            'size': '0.5 x 0.4 x 0.5 Mét - Lên đến 30 kg',
            'imagePath': 'assets/images/bike.png',
          },
          {
            'title': 'Xe Van 500 kg',
            'description':
                'Hoạt Động Tất Cả Khung Giờ | Chở tối đa 500kg & 1.65CBM',
            'size': '1.7 x 1.2 x 1.5 Mét - Lên đến 500 kg',
            'imagePath': 'assets/images/van500.png',
          },
          {
            'title': 'Xe Van 750 kg',
            'description':
                'Hoạt Động Tất Cả Khung Giờ | Chở tối đa 750kg & 3CBM',
            'size': '1.9 x 1.2 x 1.3 Mét - Lên đến 750 kg',
            'imagePath': 'assets/images/van750.png',
          },
          // Add more vehicle entries here...
        ]);
