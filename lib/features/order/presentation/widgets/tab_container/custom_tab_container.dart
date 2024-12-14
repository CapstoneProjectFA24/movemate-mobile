import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/tab_container/list_widget_item.dart';

import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class CustomTabContainer extends HookConsumerWidget {
  final int bookingId;
  final OrderEntity order;
  final List<AssignmentsRealtimeEntity> porterItems;
  final List<AssignmentsRealtimeEntity> driverItems;

  const CustomTabContainer({
    super.key,
    required this.porterItems,
    required this.driverItems,
    required this.bookingId,
    required this.order,
  });

  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    String staffType,
    String staffName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AssetsConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Xác nhận gán trách nhiệm',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AssetsConstants.primaryDarker,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn gán trách nhiệm cho $staffType này?\n\nNhân viên: $staffName',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  color: AssetsConstants.primaryDarker,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState<String>('Tài xế');
    final selectedPorter = useState<AssignmentsRealtimeEntity?>(null);
    final selectedDriver = useState<AssignmentsRealtimeEntity?>(null);

    useEffect(() {
      if (porterItems.isNotEmpty &&
          porterItems.any((item) => item.isResponsible)) {
        selectedPorter.value =
            porterItems.firstWhere((item) => item.isResponsible);
      }
      if (driverItems.isNotEmpty &&
          driverItems.any((item) => item.isResponsible)) {
        selectedDriver.value =
            driverItems.firstWhere((item) => item.isResponsible);
      }
      return null;
    }, [porterItems, driverItems]);

    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            buildTabBar(selectedTab),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.2, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: selectedTab.value == 'Bốc vác'
                            ? Column(
                                children: [
                                  Expanded(
                                    child: buildPorterList(
                                      porterItems,
                                      selectedPorter,
                                      ref,
                                      context,
                                      bookingId,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: buildDriverList(
                                      driverItems,
                                      selectedDriver,
                                      ref,
                                      context,
                                      bookingId,
                                    ),
                                  ),
                                ],
                              ),
                      ),
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

  Widget buildTabBar(ValueNotifier<String> selectedTab) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          buildTabItem(
            selectedTab: selectedTab,
            tabName: 'Tài xế',
            icon: Icons.drive_eta_outlined,
            iconColor: Colors.orange,
          ),
          buildTabItem(
            selectedTab: selectedTab,
            tabName: 'Bốc vác',
            icon: Icons.person_outlined,
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required ValueNotifier<String> selectedTab,
    required String tabName,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = selectedTab.value == tabName;

    return Expanded(
      child: InkWell(
        onTap: () => selectedTab.value = tabName,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? iconColor : Colors.grey,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                tabName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.orange : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPorterList(
    List<AssignmentsRealtimeEntity> items,
    ValueNotifier<AssignmentsRealtimeEntity?> selectedPorter,
    WidgetRef ref,
    BuildContext context,
    int bookingId,
  ) {

    return ListView.builder(
      key: const ValueKey('PorterList'),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListItemWidget(
          item: item,
          selectedValue: selectedPorter.value,
          selectionNotifier: selectedPorter,
          icon: Icons.person_outlined,
          iconColor: Colors.orange,
          subtitle:
              (item.isResponsible ?? true) ? 'Chịu trách nhiệm' : 'Nhân viên',
          role: "porter",
          orderId: bookingId,
          order: order,
        );
      },
    );
  }

  Widget buildDriverList(
    List<AssignmentsRealtimeEntity> items,
    ValueNotifier<AssignmentsRealtimeEntity?> selectedDriver,
    WidgetRef ref,
    BuildContext context,
    int bookingId,
  ) {
    return ListView.builder(
      key: const ValueKey('DriverList'),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListItemWidget(
          item: item,
          selectedValue: selectedDriver.value,
          selectionNotifier: selectedDriver,
          icon: Icons.drive_eta_outlined,
          iconColor: Colors.orange,
          subtitle:
              (item.isResponsible ?? true) ? 'Chịu trách nhiệm' : 'Nhân viên',
          role: "driver",
          orderId: bookingId,
          order: order,
        );
      },
    );
  }
}
