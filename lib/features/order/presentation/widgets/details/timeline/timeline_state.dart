import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeline/timeline_model.dart';

class TimelineState extends StateNotifier<List<TimelineItem>> {
  TimelineState()
      : super([
          TimelineItem(
            title: 'Start Project',
            description: 'Project initialization',
            date: DateTime(2024, 1, 1),
            isCompleted: true,
          ),
          TimelineItem(
            title: 'Development Phase',
            description: 'Main development phase',
            date: DateTime(2024, 2, 1),
            isCompleted: true,
          ),
          TimelineItem(
            title: 'Testing Phase',
            description: 'Testing and bug fixes',
            date: DateTime(2024, 3, 1),
            isCompleted: false,
          ),
          TimelineItem(
            title: 'Deployment',
            description: 'Project deployment',
            date: DateTime(2024, 4, 1),
            isCompleted: false,
          ),
        ]);

  void toggleComplete(int index) {
    state = [
      ...state.asMap().entries.map((entry) {
        if (entry.key == index) {
          return TimelineItem(
            title: entry.value.title,
            description: entry.value.description,
            date: entry.value.date,
            isCompleted: !entry.value.isCompleted,
          );
        }
        return entry.value;
      })
    ];
  }
}

final timelineProvider =
    StateNotifierProvider<TimelineState, List<TimelineItem>>(
  (ref) => TimelineState(),
);
