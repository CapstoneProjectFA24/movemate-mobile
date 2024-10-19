class BookingTrackersResponseEntity {
  final int id;
  final int bookingId;
  final String time;
  final String type;
  final String? location;
  final String? point;
  final String? description;
  final String? status;
  final List<dynamic> trackerSources;

  BookingTrackersResponseEntity({
    required this.id,
    required this.bookingId,
    required this.time,
    required this.type,
    this.location,
    this.point,
    this.description,
    this.status,
    required this.trackerSources,
  });

  factory BookingTrackersResponseEntity.fromMap(Map<String, dynamic> json) {
    return BookingTrackersResponseEntity(
      id: json['id'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      location: json['location'],
      point: json['point'],
      description: json['description'],
      status: json['status'],
      trackerSources: json['trackerSources'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'time': time,
      'type': type,
      'location': location,
      'point': point,
      'description': description,
      'status': status,
      'trackerSources': trackerSources,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
