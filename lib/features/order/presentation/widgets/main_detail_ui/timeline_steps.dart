import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:animate_do/animate_do.dart';

class TimelineSteps extends HookConsumerWidget {
  final ValueNotifier<int> expandedIndex;
  final OrderEntity order;

  const TimelineSteps({
    super.key,
    required this.expandedIndex,
    required this.order,
  });
  List<Map<String, dynamic>> _buildStepsFromStatus(
      BookingStatusResult status, bool isReviewOnline) {
    if (isReviewOnline) {
      // Define completed states for online flow
      final hasPassedProcess = !status.isProcessingRequest;
      final hasPassedReview = hasPassedProcess &&
          !status.isOnlineReviewing &&
          !status.isOnlineSuggestionReady;
      final hasPassedSuggestion =
          hasPassedReview && !status.canReviewSuggestion;
      final hasPassedPayment = hasPassedSuggestion && !status.canMakePayment;

      return [
        {
          'title': 'Xử lý yêu cầu',
          'isActive': status.isProcessingRequest || hasPassedProcess,
          'details': ['Nhân viên đang xem xét yêu cầu của bạn'],
          'detailsStatus': [status.isProcessingRequest || hasPassedProcess]
        },
        {
          'title': 'Đánh giá online',
          'isActive':
              (status.isOnlineReviewing || status.isOnlineSuggestionReady) ||
                  hasPassedReview,
          'details': [
            'Đang trong quá trình đánh giá trực tuyến',
            'Đã có đề xuất dịch vụ mới'
          ],
          'detailsStatus': [
            status.isOnlineReviewing || hasPassedReview,
            status.isOnlineSuggestionReady || hasPassedReview
          ]
        },
        {
          'title': 'Xác nhận đề xuất',
          'isActive': status.canReviewSuggestion || hasPassedSuggestion,
          'details': ['Vui lòng xác nhận đề xuất dịch vụ'],
          'detailsStatus': [status.canReviewSuggestion || hasPassedSuggestion]
        },
        {
          'title': 'Thanh toán',
          'isActive': status.canMakePayment || hasPassedPayment,
          'details': ['Vui lòng thanh toán để tiến hành dịch vụ'],
          'detailsStatus': [status.canMakePayment || hasPassedPayment]
        },
        {
          'title': 'Vận chuyển',
          'isActive': status.isMovingInProgress,
          'details': [
            'Đội ngũ vận chuyển đang làm việc',
            'Theo dõi quá trình vận chuyển'
          ],
          'detailsStatus': [
            status.isMovingInProgress,
            status.isMovingInProgress
          ]
        }
      ];
    } else {
      // Define completed states for offline flow
      final hasPassedSchedule = !status.isWaitingStaffSchedule;
      final hasPassedScheduleConfirm =
          hasPassedSchedule && !status.canAcceptSchedule;
      final hasPassedDeposit =
          hasPassedScheduleConfirm && !status.canMakePayment;
      final hasPassedReview = hasPassedDeposit &&
          !status.isReviewerMoving &&
          !status.isReviewerAssessing &&
          !status.isSuggestionReady;
      final hasPassedSuggestion =
          hasPassedReview && !status.canReviewSuggestion;

      return [
        {
          'title': 'Xử lý yêu cầu',
          'isActive': status.isWaitingStaffSchedule || hasPassedSchedule,
          'details': ['Đang chờ nhân viên xếp lịch khảo sát'],
          'detailsStatus': [status.isWaitingStaffSchedule || hasPassedSchedule]
        },
        {
          'title': 'Lịch khảo sát',
          'isActive': status.canAcceptSchedule || hasPassedScheduleConfirm,
          'details': ['Vui lòng xác nhận lịch khảo sát'],
          'detailsStatus': [
            status.canAcceptSchedule || hasPassedScheduleConfirm
          ]
        },
        {
          'title': 'Thanh toán',
          'isActive': status.canMakePayment || hasPassedDeposit,
          'details': ['Vui lòng thanh toán đặt cọc'],
          'detailsStatus': [status.canMakePayment || hasPassedDeposit]
        },
        {
          'title': 'Khảo sát',
          'isActive': (status.isReviewerMoving ||
                  status.isReviewerAssessing ||
                  status.isSuggestionReady) ||
              hasPassedReview,
          'details': [
            'Nhân viên đang di chuyển',
            'Đang khảo sát tại nhà',
            'Đã có đề xuất dịch vụ mới'
          ],
          'detailsStatus': [
            status.isReviewerMoving || hasPassedReview,
            status.isReviewerAssessing || hasPassedReview,
            status.isSuggestionReady || hasPassedReview
          ]
        },
        {
          'title': 'Xác nhận đề xuất',
          'isActive': status.canReviewSuggestion
          // || hasPassedSuggestion
          ,
          'details': ['Vui lòng xác nhận đề xuất dịch vụ'],
          'detailsStatus': [
            status.canReviewSuggestion
            // || hasPassedSuggestion
          ]
        },
        {
          'title': 'Vận chuyển',
          'isActive': status.isMovingInProgress,
          'details': [
            'Đội ngũ vận chuyển đang làm việc',
            'Theo dõi quá trình vận chuyển'
          ],
          'detailsStatus': [
            status.isMovingInProgress,
            status.isMovingInProgress
          ]
        }
      ];
    }
  }

  int _getCurrentStepIndex(BookingStatusResult status, bool isReviewOnline) {
    if (isReviewOnline) {
      if (status.isMovingInProgress) return 4;
      if (status.canMakePayment) return 3;
      if (status.canReviewSuggestion) return 2;
      if (status.isOnlineReviewing || status.isOnlineSuggestionReady) return 1;
      if (status.isProcessingRequest) return 0;
      return 0;
    } else {
      if (status.isMovingInProgress) return 5;
      if (status.canReviewSuggestion) return 4;
      if (status.isReviewerMoving ||
          status.isReviewerAssessing ||
          status.isSuggestionReady) return 3;
      if (status.canMakePayment) return 2;
      if (status.canAcceptSchedule) return 1;
      if (status.isWaitingStaffSchedule) return 0;
      return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);

    final steps = _buildStepsFromStatus(bookingStatus, order.isReviewOnline);
    final currentStepIndex =
        _getCurrentStepIndex(bookingStatus, order.isReviewOnline);

    // Convert animation controller to hooks
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    // Create animation using hooks
    final animation = useAnimation(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // State management using hooks
    final currentAnimatedStep = useState(currentStepIndex);
    final isForward = useState(true);

    // Effect to handle animation status
    useEffect(() {
      final startStep = currentStepIndex + 1;
      final endStep = currentStepIndex;

      if (endStep >= steps.length) {
        isForward.value = false;
      }

      currentAnimatedStep.value = startStep;

      void handleAnimationStatus(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          currentAnimatedStep.value = isForward.value ? endStep : startStep;
          isForward.value = !isForward.value;
          animationController
            ..reset()
            ..forward();
        }
      }

      animationController.addStatusListener(handleAnimationStatus);
      animationController.forward();

      return () {
        animationController.removeStatusListener(handleAnimationStatus);
      };
    }, [currentStepIndex]);

    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                final isPast =
                    step['isActive'] || index <= currentAnimatedStep.value;

                return SizedBox(
                  width: 100,
                  child: SlideInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    from: 50.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 35,
                          child: MyTimelineTitle(
                            isFirst: index == 0,
                            isLast: index == steps.length - 1,
                            isPast: isPast,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
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
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                bool isExpanded = expandedIndex.value == index;
                final isPast =
                    step['isActive'] || index <= currentAnimatedStep.value;

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
                                  (step['details'] as List).length,
                                  (detailIndex) {
                                    final isDetailActive =
                                        step['detailsStatus'][detailIndex];
                                    final detailText =
                                        step['details'][detailIndex];

                                    return FadeInLeft(
                                      delay: Duration(
                                          milliseconds: detailIndex * 100),
                                      child: TimelineTile(
                                        alignment: TimelineAlign.start,
                                        isFirst: detailIndex == 0,
                                        isLast: detailIndex ==
                                            (step['details'] as List).length -
                                                1,
                                        indicatorStyle: IndicatorStyle(
                                          color: isDetailActive
                                              ? AssetsConstants.primaryMain
                                              : Colors.grey,
                                          iconStyle: IconStyle(
                                            color: Colors.white,
                                            iconData: isDetailActive
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
                                            detailText,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: isDetailActive
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        beforeLineStyle: LineStyle(
                                          color: isDetailActive
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
