class FeeSetting {
  final int id;
  final String name;
  final String description;
  final int amount;

  FeeSetting({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
  });
  factory FeeSetting.fromMap(Map<String, dynamic> json) {
    return FeeSetting(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}

class Truck {
  final int id;
  final String categoryName;
  final double maxLoad;
  final String description;
  final String imageUrl;
  final String estimatedLenght;
  final String estimatedWidth;
  final String estimatedHeight;
  final String summarize;
  final int price;
  final int? totalTrips;
  final List<FeeSetting> feeSettings;

  Truck({
    required this.id,
    required this.categoryName,
    required this.maxLoad,
    required this.description,
    required this.imageUrl,
    required this.estimatedLenght,
    required this.estimatedWidth,
    required this.estimatedHeight,
    required this.summarize,
    required this.price,
    this.totalTrips,
    required this.feeSettings,
  });

  factory Truck.fromMap(Map<String, dynamic> map) {
    return Truck(
      id: map['id'],
      categoryName: map['categoryName'],
      maxLoad: map['maxLoad'].toDouble(),
      description: map['description'],
      imageUrl: map['imageUrl'],
      estimatedLenght: map['estimatedLenght'],
      estimatedWidth: map['estimatedWidth'],
      estimatedHeight: map['estimatedHeight'],
      summarize: map['summarize'],
      price: map['price'],
      totalTrips: map['totalTrips'],
      feeSettings: map['feeSettings'] != null
          ? List<FeeSetting>.from(
              map['feeSettings'].map((x) => FeeSetting.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'maxLoad': maxLoad,
      'description': description,
      'imageUrl': imageUrl,
      'estimatedLenght': estimatedLenght,
      'estimatedWidth': estimatedWidth,
      'estimatedHeight': estimatedHeight,
      'price': price,
      'totalTrips': totalTrips,
    };
  }
}

class TruckCategoryPriceResponse {
  final List<Truck> payload;

  TruckCategoryPriceResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory TruckCategoryPriceResponse.fromMap(Map<String, dynamic> map) {
    return TruckCategoryPriceResponse(
      payload: List<Truck>.from(map['payload']?.map((x) => Truck.fromMap(x))),
    );
  }
}
