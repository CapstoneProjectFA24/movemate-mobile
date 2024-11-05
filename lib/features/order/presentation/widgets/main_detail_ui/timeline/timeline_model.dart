class TimelineItem {
  final String title;
  final String description;
  final bool isCompleted;

  TimelineItem({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}