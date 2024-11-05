class TimelineItem {
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  TimelineItem({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}