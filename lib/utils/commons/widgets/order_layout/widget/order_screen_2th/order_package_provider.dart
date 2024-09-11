//order_package_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

// This will be replaced with your API call
final bocXepServicesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  // Simulating API data
  return [
    {'service': 'Bốc xếp (Bởi tài xế)', 'price': '120.000đ'},
    {'service': 'Bốc xếp (Có người hỗ trợ)', 'price': '400.000đ'},
  ];
});

final thaoLapServicesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  // Simulating API data
  return [
    {'service': 'Tháo lắp (loại 1)', 'price': '300.000đ'},
  ];
});

// Provider for package data (titles and prices)
final packageDataProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'packageTitles': [
      'Gói hỗ trợ chuyển nhà cơ bản',
      'Bốc xếp dưới xe - 1 chiều',
      'Bốc xếp dưới xe - 2 chiều'
    ],
    'packagePrices': ['730.000đ', '660.000đ', '120.000đ'],
    'packageIcons': [
      'assets/images/package_icon.png',
      'assets/images/package_icon.png',
      'assets/images/package_icon.png'
    ],
  };
});

// Provider for checklist options and values
final checklistDataProvider =
    StateNotifierProvider<ChecklistNotifier, List<bool>>((ref) {
  return ChecklistNotifier();
});

// Checklist Notifier
class ChecklistNotifier extends StateNotifier<List<bool>> {
  ChecklistNotifier() : super([false, false, false, false]);

  // Toggles the value at a given index
  void toggleValue(int index) {
    state = List.from(state)..[index] = !state[index];
  }
}

// Provider for checklist options
final checklistOptionsProvider = Provider<List<String>>((ref) {
  return [
    'Hàng dễ vỡ',
    'Cần nhiệt độ thích hợp',
    'Giữ khô ráo',
    'Thực phẩm có mùi'
  ];
});
