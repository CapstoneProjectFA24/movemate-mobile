import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimelineSteps extends HookWidget {
  final List<Map<String, dynamic>> steps;
  final ValueNotifier<int> expandedIndex;
  final BookingStatusType currentStatus;

  const TimelineSteps({
    super.key,
    required this.steps,
    required this.expandedIndex,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final currentStepIndex = getStatusIndex(currentStatus);

    return FadeInLeft(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  steps.length,
                  (index) => MyTimelineTitle(
                    isFirst: index == 0,
                    isLast: index == steps.length - 1,
                    isPast: index <= currentStepIndex,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: [
                // Wrap the Row with SingleChildScrollView
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(steps.length, (index) {
                      final step = steps[index];
                      return GestureDetector(
                        onTap: () {
                          expandedIndex.value =
                              expandedIndex.value == index ? -1 : index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            step['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: index <= currentStepIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index <= currentStepIndex
                                  ? AssetsConstants.primaryMain
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                ...List.generate(steps.length, (index) {
                  final step = steps[index];
                  return Visibility(
                    visible: expandedIndex.value == index,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(
                          step['details'].length,
                          (detailIndex) {
                            return TimelineTile(
                              alignment: TimelineAlign.start,
                              isFirst: detailIndex == 0,
                              isLast: detailIndex == step['details'].length - 1,
                              indicatorStyle: IndicatorStyle(
                                color: index <= currentStepIndex
                                    ? AssetsConstants.primaryMain
                                    : Colors.grey,
                                iconStyle: IconStyle(
                                  iconData: Icons.circle,
                                  color: Colors.white,
                                ),
                              ),
                              endChild: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  step['details'][detailIndex],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: index <= currentStepIndex
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              beforeLineStyle: LineStyle(
                                color: index <= currentStepIndex
                                    ? AssetsConstants.primaryMain
                                    : Colors.grey,
                                thickness: 4,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getStatusIndex(BookingStatusType status) {
    switch (status) {
      case BookingStatusType.pending:
        return 0;
      case BookingStatusType.waiting:
        return 1;
      case BookingStatusType.assigned:
        return 2;
      case BookingStatusType.reviewing:
        return 3;
      case BookingStatusType.reviewed:
        return 4;
      default:
        return -1;
    }
  }
}
