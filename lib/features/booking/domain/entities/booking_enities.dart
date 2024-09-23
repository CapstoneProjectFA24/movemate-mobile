//booking_entities.dart

import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

class Service {
  final String title;
  final String price;

  Service({
    required this.title,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      title: json['title'],
      price: json['price'],
    );
  }
}

class Package {
  final String packageTitle;
  final String packagePrice;
  final String packageIcon;
  final List<Service> services;

  Package({
    required this.packageTitle,
    required this.packagePrice,
    required this.packageIcon,
    required this.services,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      packageTitle: json['packageTitles'],
      packagePrice: json['packagePrices'],
      packageIcon: json['packageIcons'],
      services: (json['service'] as List)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList(),
    );
  }

  toJson() {}
}

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

  final bool isHandlingExpanded;
  final bool isDisassemblyExpanded;

  final List<Package> packages;

  // Add image lists for each room
  final List<String> livingRoomImages;
  final List<String> bedroomImages;
  final List<String> diningRoomImages;
  final List<String> officeRoomImages;
  final List<String> bathroomImages;
  //location

  final bool isSelectingPickUp;
  final LocationModel? pickUpLocation;
  final LocationModel? dropOffLocation;
  final DateTime? bookingDate; // Add this field

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
      packages: (json['packages'] as List<dynamic>?)
              ?.map((e) => Package.fromJson(e))
              .toList() ??
          [],
      //location
      pickUpLocation: json['pickUpLocation'] != null
          ? LocationModel.fromJson(json['pickUpLocation'])
          : null,
      dropOffLocation: json['dropOffLocation'] != null
          ? LocationModel.fromJson(json['dropOffLocation'])
          : null,
      isHandlingExpanded: json['isHandlingExpanded'] ?? false,
      isDisassemblyExpanded: json['isDisassemblyExpanded'] ?? false,
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
      //location
      'pickUpLocation': pickUpLocation?.toJson(),
      'dropOffLocation': dropOffLocation?.toJson(),
      //
      'packages': packages.map((e) => e.toJson()).toList(),
      'isHandlingExpanded': isHandlingExpanded,
      'isDisassemblyExpanded': isDisassemblyExpanded,
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
    this.packages = const [],
    this.totalPrice = 0.0,
    this.selectedPackageIndex,
    this.packagePrice = 0.0,
    this.peopleCount = 1,
    this.airConditionersCount = 1,
    this.isRoundTrip = false,
    List<bool>? checklistValues,
    this.isHandlingExpanded = false,
    this.isDisassemblyExpanded = false,
    this.notes = '',
    //location
    this.isSelectingPickUp = false,
    this.pickUpLocation,
    this.dropOffLocation,
    this.bookingDate, // Include in constructor
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
    bool? isHandlingExpanded,
    bool? isDisassemblyExpanded,
    String? notes,
    //location
    bool? isSelectingPickUp,
    LocationModel? pickUpLocation,
    LocationModel? dropOffLocation,
    DateTime? bookingDate,
    List<Package>? packages,
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
      isHandlingExpanded: isHandlingExpanded ?? this.isHandlingExpanded,
      isDisassemblyExpanded:
          isDisassemblyExpanded ?? this.isDisassemblyExpanded,
      notes: notes ?? this.notes,
      //location
      isSelectingPickUp: isSelectingPickUp ?? this.isSelectingPickUp,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      bookingDate: bookingDate ?? this.bookingDate,
      //
      livingRoomImages: livingRoomImages ?? this.livingRoomImages,
      bedroomImages: bedroomImages ?? this.bedroomImages,
      diningRoomImages: diningRoomImages ?? this.diningRoomImages,
      officeRoomImages: officeRoomImages ?? this.officeRoomImages,
      bathroomImages: bathroomImages ?? this.bathroomImages,
      packages: packages ?? this.packages,
    );
  }
}
