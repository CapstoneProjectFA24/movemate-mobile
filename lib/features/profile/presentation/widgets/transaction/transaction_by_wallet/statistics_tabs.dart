import 'package:flutter/material.dart';

class StatisticsTabs extends StatelessWidget {
  final ValueNotifier<int> selectedTab;
  final Function(int) onTabChanged;

  const StatisticsTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabItem(
            text: 'Nạp tiền',
            isSelected: selectedTab.value == 0,
            onTap: () => onTabChanged(0),
          ),
          TabItem(
            text: 'Thống kê',
            isSelected: selectedTab.value == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: const Color(0xFF8A2BE2),
            ),
        ],
      ),
    );
  }
}
