import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline/timeline_model.dart';

class TimelineState extends StateNotifier<List<TimelineItem>> {
  TimelineState()
      : super([
          TimelineItem(
            title: 'Start Project',
            description: 'Project initialization',
            isCompleted: false,
          ),
          TimelineItem(
            title: 'Development Phase',
            description: 'Main development phase',
            isCompleted: true,
          ),
          TimelineItem(
            title: 'Testing Phase',
            description: 'Testing and bug fixes',
            isCompleted: false,
          ),
          TimelineItem(
            title: 'Deployment',
            description: 'Project deployment',
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
