import 'dart:convert';

class PromotionSortRequest {
  final String? dateNow;

  PromotionSortRequest({
    this.dateNow,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'currentTime': dateNow});

    return result;
  }

  factory PromotionSortRequest.fromMap(Map<String, dynamic> map) {
    return PromotionSortRequest(
      dateNow: map['currentTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionSortRequest.fromJson(String source) =>
      PromotionSortRequest.fromMap(json.decode(source));
}
