class ValuationEntity {
  final double total;
  final double deposit;

  ValuationEntity({required this.total, required this.deposit});

  factory ValuationEntity.fromJson(Map<String, dynamic> json) {
    return ValuationEntity(
      total: json['total'],
      deposit: json['deposit'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'deposit': deposit,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'deposit': deposit,
    };
  }
}
