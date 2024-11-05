// timeline_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline/timeline_model.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline/timeline_state.dart';

class AnimatedTimeline extends ConsumerStatefulWidget {
  const AnimatedTimeline({super.key});

  @override
  ConsumerState<AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends ConsumerState<AnimatedTimeline>
    with TickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timelineItems = ref.watch(timelineProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            timelineItems.length,
            (index) => TimelineItemWidget(
              item: timelineItems[index],
              isLast: index == timelineItems.length - 1,
              index: index,
              progressAnimation: _progressController,
              previousItemCompleted:
                  index == 0 ? true : timelineItems[index - 1].isCompleted,
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineItemWidget extends ConsumerWidget {
  final TimelineItem item;
  final bool isLast;
  final int index;
  final AnimationController progressAnimation;
  final bool previousItemCompleted;

  const TimelineItemWidget({
    super.key,
    required this.item,
    required this.isLast,
    required this.index,
    required this.progressAnimation,
    required this.previousItemCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineColumn(context, ref),
          Expanded(
            child: _buildContentColumn(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineColumn(BuildContext context, WidgetRef ref) {
    return Container(
      width: 30,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                ref.read(timelineProvider.notifier).toggleComplete(index),
            child: AnimatedBuilder(
              animation: progressAnimation,
              builder: (context, child) {
                final progress =
                    previousItemCompleted ? progressAnimation.value : 0.0;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: item.isCompleted ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, completionValue, child) {
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(Colors.grey, Colors.green,
                            previousItemCompleted ? progress : completionValue),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: item.isCompleted ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (!isLast)
            AnimatedBuilder(
              animation: progressAnimation,
              builder: (context, child) {
                final progress =
                    previousItemCompleted ? progressAnimation.value : 0.0;

                return Stack(
                  children: [
                    Container(
                      width: 1,
                      height: 50,
                      margin: const EdgeInsets.only(left: 9),
                      color: Colors.grey,
                    ),
                    Container(
                      width: 5,
                      height: 50 * progress,
                      margin: const EdgeInsets.only(left: 9),
                      color: Colors.green,
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildContentColumn(BuildContext context) {
    return AnimatedBuilder(
        animation: progressAnimation,
        builder: (context, child) {
          final progress =
              previousItemCompleted ? progressAnimation.value : 0.0;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Color.lerp(Colors.grey, Colors.green, progress) ??
                    Colors.grey,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.lerp(Colors.black, Colors.green, progress),
                  ),
                  child: Text(item.title),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.date.day}/${item.date.month}/${item.date.year}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
