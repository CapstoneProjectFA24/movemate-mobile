// code rác -> làm clear

import 'package:movemate/features/booking/data/models/vehicle_model.dart';

class Booking {
  final String? houseType;
  final int? numberOfRooms;
  final int? numberOfFloors;
  final int? selectedVehicleIndex;
  final double vehiclePrice;
  final List<Vehicle> availableVehicles;
  final double totalPrice;
  final int? selectedPackageIndex;
  final double packagePrice;
  final int peopleCount;
  final int airConditionersCount;
  final bool isRoundTrip;
  final List<bool> checklistValues;
  final String notes;

  // Add image lists for each room
  final List<String> livingRoomImages;
  final List<String> bedroomImages;
  final List<String> diningRoomImages;
  final List<String> officeRoomImages;
  final List<String> bathroomImages;

  /// start test
  // Add fromJson and toJson methods
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      houseType: json['houseType'],
      numberOfRooms: json['numberOfRooms'],
      numberOfFloors: json['numberOfFloors'],
      selectedVehicleIndex: json['selectedVehicleIndex'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      selectedPackageIndex: json['selectedPackageIndex'],
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 0.0,
      peopleCount: json['peopleCount'] ?? 1,
      airConditionersCount: json['airConditionersCount'] ?? 1,
      isRoundTrip: json['isRoundTrip'] ?? false,
      notes: json['notes'] ?? '',
      livingRoomImages: List<String>.from(json['livingRoomImages'] ?? []),
      bedroomImages: List<String>.from(json['bedroomImages'] ?? []),
      diningRoomImages: List<String>.from(json['diningRoomImages'] ?? []),
      officeRoomImages: List<String>.from(json['officeRoomImages'] ?? []),
      bathroomImages: List<String>.from(json['bathroomImages'] ?? []),
      checklistValues:
          List<bool>.from(json['checklistValues'] ?? List.filled(10, false)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseType': houseType,
      'numberOfRooms': numberOfRooms,
      'numberOfFloors': numberOfFloors,
      'selectedVehicleIndex': selectedVehicleIndex,
      'totalPrice': totalPrice,
      'selectedPackageIndex': selectedPackageIndex,
      'packagePrice': packagePrice,
      'peopleCount': peopleCount,
      'airConditionersCount': airConditionersCount,
      'isRoundTrip': isRoundTrip,
      'notes': notes,
      'livingRoomImages': livingRoomImages,
      'bedroomImages': bedroomImages,
      'diningRoomImages': diningRoomImages,
      'officeRoomImages': officeRoomImages,
      'bathroomImages': bathroomImages,
      'checklistValues': checklistValues,
    };
  }

  /// end test

  Booking({
    this.houseType,
    this.numberOfRooms,
    this.numberOfFloors,
    this.selectedVehicleIndex,
    this.vehiclePrice = 0.0,
    this.availableVehicles = const [],
    this.totalPrice = 0.0,
    this.selectedPackageIndex,
    this.packagePrice = 0.0,
    this.peopleCount = 1,
    this.airConditionersCount = 1,
    this.isRoundTrip = false,
    List<bool>? checklistValues,
    this.notes = '',
    // Initialize image lists (empty by default)
    List<String>? livingRoomImages,
    List<String>? bedroomImages,
    List<String>? diningRoomImages,
    List<String>? officeRoomImages,
    List<String>? bathroomImages,
  })  : checklistValues = checklistValues ?? List.filled(10, false),
        livingRoomImages = livingRoomImages ?? [],
        bedroomImages = bedroomImages ?? [],
        diningRoomImages = diningRoomImages ?? [],
        officeRoomImages = officeRoomImages ?? [],
        bathroomImages = bathroomImages ?? [];

  Booking copyWith({
    String? houseType,
    int? numberOfRooms,
    int? numberOfFloors,
    int? selectedVehicleIndex,
    double? vehiclePrice,
    List<Vehicle>? availableVehicles,
    double? totalPrice,
    int? selectedPackageIndex,
    double? packagePrice,
    int? peopleCount,
    int? airConditionersCount,
    bool? isRoundTrip,
    List<bool>? checklistValues,
    String? notes,
    List<String>? livingRoomImages,
    List<String>? bedroomImages,
    List<String>? diningRoomImages,
    List<String>? officeRoomImages,
    List<String>? bathroomImages,
  }) {
    return Booking(
      houseType: houseType ?? this.houseType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      selectedVehicleIndex: selectedVehicleIndex ?? this.selectedVehicleIndex,
      vehiclePrice: vehiclePrice ?? this.vehiclePrice,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      totalPrice: totalPrice ?? this.totalPrice,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      packagePrice: packagePrice ?? this.packagePrice,
      peopleCount: peopleCount ?? this.peopleCount,
      airConditionersCount: airConditionersCount ?? this.airConditionersCount,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      checklistValues: checklistValues ?? this.checklistValues,
      notes: notes ?? this.notes,
      livingRoomImages: livingRoomImages ?? this.livingRoomImages,
      bedroomImages: bedroomImages ?? this.bedroomImages,
      diningRoomImages: diningRoomImages ?? this.diningRoomImages,
      officeRoomImages: officeRoomImages ?? this.officeRoomImages,
      bathroomImages: bathroomImages ?? this.bathroomImages,
    );
  }
}
