import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
enum TimelineStep { booking, reviewer, driver, poster, home }

class TimelineEvent {
  final String title;
  final String location;
  final String date;
  final bool isCompleted;
  final TimelineStep step;

  TimelineEvent({
    required this.title,
    required this.location,
    required this.date,
    required this.step,
    this.isCompleted = false,
  });
}

// Providers
final selectedStepProvider =
    StateProvider<TimelineStep>((ref) => TimelineStep.booking);

final eventsProvider =
    StateProvider<Map<TimelineStep, List<TimelineEvent>>>((ref) => {
          TimelineStep.booking: [
            TimelineEvent(
                title: 'Booking Title 1',
                location: 'Booking Location 1',
                date: 'Date 1',
                step: TimelineStep.booking,
                isCompleted: true),
            TimelineEvent(
                title: 'Booking Title 2',
                location: 'Booking Location 2',
                date: 'Date 2',
                step: TimelineStep.booking),
          ],
          TimelineStep.reviewer: [
            TimelineEvent(
                title: 'Review Title 1',
                location: 'Review Location 1',
                date: 'Date 1',
                step: TimelineStep.reviewer),
          ],
          TimelineStep.driver: [
            TimelineEvent(
                title: 'Driver Title 1',
                location: 'Driver Location 1',
                date: 'Date 1',
                step: TimelineStep.driver),
          ],
          TimelineStep.poster: [
            TimelineEvent(
                title: 'Poster Title 1',
                location: 'Poster Location 1',
                date: 'Date 1',
                step: TimelineStep.poster),
          ],
        });

// Colors
class TimelineColors {
  static const yellow = Color(0xFFF5A623);
  static const gray = Color(0xFFD8D8D8);
  static const green = Color(0xFF4CAF50);
  static const blue = Color(0xFF2196F3);
  static const orange = Color(0xFFFF9800);
}

@RoutePage()
class TimeLineBooking extends HookConsumerWidget {
  const TimeLineBooking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStep = ref.watch(selectedStepProvider);
    final events = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTimelineWithLabels(ref, selectedStep),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildEvents(events[selectedStep] ?? [], selectedStep),
              ),
              const SizedBox(height: 16),
              _buildMoreButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineWithLabels(WidgetRef ref, TimelineStep selectedStep) {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Row(
              children: [
                _buildInteractiveIcon(
                  ref,
                  step: TimelineStep.booking,
                  selectedStep: selectedStep,
                  icon: Icons.book,
                ),
                Expanded(
                    child: _buildLine(
                        color:
                            _getLineColor(TimelineStep.booking, selectedStep))),
                _buildInteractiveIcon(
                  ref,
                  step: TimelineStep.reviewer,
                  selectedStep: selectedStep,
                  icon: Icons.person,
                ),
                Expanded(
                    child: _buildLine(
                        color: _getLineColor(
                            TimelineStep.reviewer, selectedStep))),
                _buildInteractiveIcon(
                  ref,
                  step: TimelineStep.driver,
                  selectedStep: selectedStep,
                  icon: Icons.directions_car,
                ),
                Expanded(
                    child: _buildLine(
                        color:
                            _getLineColor(TimelineStep.driver, selectedStep))),
                _buildInteractiveIcon(
                  ref,
                  step: TimelineStep.poster,
                  selectedStep: selectedStep,
                  icon: Icons.post_add,
                ),
                Expanded(
                    child: _buildLine(
                        color:
                            _getLineColor(TimelineStep.poster, selectedStep))),
                _buildInteractiveIcon(
                  ref,
                  step: TimelineStep.home,
                  selectedStep: selectedStep,
                  icon: Icons.home,
                  border: true,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('Booking',
                    _getLabelColor(TimelineStep.booking, selectedStep)),
                _buildLabel('Reviewer',
                    _getLabelColor(TimelineStep.reviewer, selectedStep)),
                _buildLabel('Driver',
                    _getLabelColor(TimelineStep.driver, selectedStep)),
                _buildLabel('Poster',
                    _getLabelColor(TimelineStep.poster, selectedStep)),
                const SizedBox(width: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(TimelineStep step, TimelineStep selectedStep) {
    if (step == selectedStep) return TimelineColors.yellow;
    if (step.index < selectedStep.index) return TimelineColors.yellow;
    return TimelineColors.gray;
  }

  Color _getLineColor(TimelineStep step, TimelineStep selectedStep) {
    if (step.index < selectedStep.index) return TimelineColors.yellow;
    return TimelineColors.gray;
  }

  Color _getLabelColor(TimelineStep step, TimelineStep selectedStep) {
    if (step == selectedStep) return TimelineColors.yellow;
    switch (step) {
      case TimelineStep.booking:
        return TimelineColors.green;
      case TimelineStep.reviewer:
        return step.index < selectedStep.index
            ? TimelineColors.yellow
            : Colors.black87;
      case TimelineStep.driver:
        return TimelineColors.blue;
      default:
        return Colors.black87;
    }
  }

  Widget _buildInteractiveIcon(
    WidgetRef ref, {
    required TimelineStep step,
    required TimelineStep selectedStep,
    required IconData icon,
    bool border = false,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedStepProvider.notifier).state = step;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: _getIconColor(step, selectedStep),
          borderRadius: BorderRadius.circular(15),
          border:
              border ? Border.all(color: TimelineColors.gray, width: 1) : null,
          boxShadow: step == selectedStep
              ? [
                  BoxShadow(
                    color: TimelineColors.yellow.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: step == selectedStep || step.index < selectedStep.index
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLine({required Color color}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      color: color,
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEvents(List<TimelineEvent> events, TimelineStep step) {
    return Column(
      key: ValueKey(step), // Important for AnimatedSwitcher
      children: [
        ...events.map((event) => _buildEventItem(event)),
        const SizedBox(height: 20),
        if (step != TimelineStep.home) _buildNextStepButton(step),
      ],
    );
  }

  Widget _buildNextStepButton(TimelineStep currentStep) {
    return Consumer(
      builder: (context, ref, child) {
        return ElevatedButton(
          onPressed: () {
            if (currentStep.index < TimelineStep.values.length - 1) {
              ref.read(selectedStepProvider.notifier).state =
                  TimelineStep.values[currentStep.index + 1];
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TimelineColors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Next Step',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildEventItem(TimelineEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10, top: 2),
            decoration: BoxDecoration(
              color: event.isCompleted
                  ? TimelineColors.green
                  : TimelineColors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              event.isCompleted ? Icons.check : Icons.circle,
              size: 12,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  event.location,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  event.date,
                  style: const TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButton() {
    return TextButton(
      onPressed: () {},
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'xem thêm',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 14,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
