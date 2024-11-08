// timeline_steps.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:animate_do/animate_do.dart';

class TimelineSteps extends ConsumerStatefulWidget {
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
  ConsumerState<TimelineSteps> createState() => TimelineStepsState();
}

class TimelineStepsState extends ConsumerState<TimelineSteps>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  int currentAnimatedStep = 0;
  bool isForward = true;

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController với duration 0.5 giây
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 00),
    );

    // Khởi tạo Animation với CurvedAnimation để tạo hiệu ứng mượt mà
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    // Xác định hai bước cho animation dựa trên currentStatus
    final statusIndex =
        getStatusIndex(widget.currentStatus, widget.order.isReviewOnline);
    print("statusIndex $statusIndex");
    final startStep = statusIndex;
    final endStep = statusIndex + 1;

    // Đảm bảo endStep không vượt quá số bước
    if (endStep >= widget.steps.length) {
      isForward = false;
    }

    currentAnimatedStep = startStep;

    // Lắng nghe khi animation hoàn thành
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // Chuyển đổi giữa hai bước
          currentAnimatedStep = isForward ? endStep : startStep;
          isForward = !isForward;
        });
        animationController.reset();
        animationController.forward();
      }
    });

    // Bắt đầu animation
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant TimelineSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu trạng thái hiện tại thay đổi, reset và bắt đầu lại animation
    if (oldWidget.currentStatus != widget.currentStatus) {
      resetAnimation();
    }
  }

  void resetAnimation() {
    animationController.stop();
    animationController.reset();

    // Xác định lại hai bước dựa trên currentStatus mới
    final statusIndex =
        getStatusIndex(widget.currentStatus, widget.order.isReviewOnline);
    final startStep = statusIndex;
    final endStep = statusIndex + 1;

    // Đảm bảo endStep không vượt quá số bước
    isForward = true;
    if (endStep >= widget.steps.length) {
      isForward = false;
    }

    currentAnimatedStep = startStep;

    // Bắt đầu lại animation
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // Hàm xác định chỉ số bước hiện tại dựa trên trạng thái đơn hàng
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

  @override
  Widget build(BuildContext context) {
    final currentStepIndex = currentAnimatedStep;

    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          // Gộp Timeline header và titles thành một hàng
          SizedBox(
            height: 80, // Chiều cao cố định cho container
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                bool isPast = index <= currentStepIndex;
                final step = widget.steps[index];

                return SizedBox(
                  width: 100, // Chiều rộng cố định cho mỗi item
                  child: SlideInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    from: 50.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Quan trọng
                      children: [
                        SizedBox(
                          height: 35, // Chiều cao cố định cho MyTimelineTitle
                          child: MyTimelineTitle(
                            isFirst: index == 0,
                            isLast: index == widget.steps.length - 1,
                            isPast: isPast,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              widget.expandedIndex.value =
                                  widget.expandedIndex.value == index
                                      ? -1
                                      : index;
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isPast
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isPast
                                      ? AssetsConstants.primaryMain
                                      : Colors.grey,
                                ),
                                child: Text(
                                  step['title'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Phần còn lại của widget giữ nguyên
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: List.generate(widget.steps.length, (index) {
                final step = widget.steps[index];
                bool isExpanded = widget.expandedIndex.value == index;
                bool isPast = index <= currentStepIndex;

                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isExpanded
                        ? FadeInUp(
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
                                  (detailIndex) {
                                    bool isDetailPast =
                                        index < currentStepIndex ||
                                            (index == currentStepIndex &&
                                                detailIndex <
                                                    (step['details'].length / 2)
                                                        .ceil());

                                    return FadeInLeft(
                                      delay: Duration(
                                          milliseconds: detailIndex * 100),
                                      child: TimelineTile(
                                        alignment: TimelineAlign.start,
                                        isFirst: detailIndex == 0,
                                        isLast: detailIndex ==
                                            step['details'].length - 1,
                                        indicatorStyle: IndicatorStyle(
                                          color: isDetailPast
                                              ? AssetsConstants.primaryMain
                                              : Colors.grey,
                                          iconStyle: IconStyle(
                                            color: Colors.white,
                                            iconData: isDetailPast
                                                ? Icons.check
                                                : Icons.circle,
                                          ),
                                        ),
                                        endChild: Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Text(
                                            step['details'][detailIndex],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: isDetailPast
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        beforeLineStyle: LineStyle(
                                          color: isDetailPast
                                              ? AssetsConstants.primaryMain
                                              : Colors.grey,
                                          thickness: 4,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
