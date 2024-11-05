import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimelineSteps extends HookWidget {
  final List<Map<String, dynamic>> steps;
  final ValueNotifier<int> expandedIndex;
  final BookingStatusType currentStatus;
  final OrderEntity order;

  const TimelineSteps({
    super.key,
    required this.steps,
    required this.expandedIndex,
    required this.currentStatus,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final currentStepIndex =
        getStatusIndex(currentStatus, order.isReviewOnline);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    // Animation for timeline progress
    final progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation when widget builds
    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          // Timeline header with dots
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedBuilder(
                animation: progressAnimation,
                builder: (context, child) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      steps.length,
                      (index) => SlideInRight(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        from: 50.0,
                        child: MyTimelineTitle(
                          isFirst: index == 0,
                          isLast: index == steps.length - 1,
                          isPast: index <=
                              (currentStepIndex * progressAnimation.value),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Timeline titles and details
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(steps.length, (index) {
                      final step = steps[index];
                      return SlideInRight(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        from: 30.0,
                        child: GestureDetector(
                          onTap: () {
                            expandedIndex.value =
                                expandedIndex.value == index ? -1 : index;
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: index <= currentStepIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index <= currentStepIndex
                                    ? AssetsConstants.primaryMain
                                    : Colors.grey,
                              ),
                              child: Text(
                                step['title'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Expanded details
                ...List.generate(steps.length, (index) {
                  final step = steps[index];
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Visibility(
                        visible: expandedIndex.value == index,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 400),
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
                                (detailIndex) => FadeInLeft(
                                  delay:
                                      Duration(milliseconds: detailIndex * 100),
                                  child: TimelineTile(
                                    alignment: TimelineAlign.start,
                                    isFirst: detailIndex == 0,
                                    isLast: detailIndex ==
                                        step['details'].length - 1,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                  ),
                                ),
                              ),
                            ),
                          ),
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

  int getStatusIndex(BookingStatusType status, bool isReviewOnline) {
    if (status == BookingStatusType.pending) {
      return 0;
    } else if (status == BookingStatusType.assigned) {
      return 1;
    } else if (status == BookingStatusType.reviewing && isReviewOnline) {
      return 2;
    } else if (status == BookingStatusType.reviewed) {
      return 3;
    } else if (status == BookingStatusType.depositing) {
      return 4;
    } else if (status == BookingStatusType.coming) {
      return 5;
    } else if (status == BookingStatusType.waiting && !isReviewOnline) {
      return 3;
    } else if (status == BookingStatusType.reviewing && !isReviewOnline) {
      return 5;
    } else if (status == BookingStatusType.reviewed && !isReviewOnline) {
      return 6;
    } else if (status == BookingStatusType.coming && !isReviewOnline) {
      return 7;
    } else {
      return -1;
    }
  }
}
