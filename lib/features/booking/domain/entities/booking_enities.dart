//booking_entities.dart

import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/booking/domain/entities/package_entities.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

class Booking {
  final String? houseType;
  final int? numberOfRooms;
  final int? numberOfFloors;
  final int? selectedVehicleIndex;
  final double vehiclePrice;
  final List<Vehicle> availableVehicles;
  final double totalPrice;

  final double packagePrice;
  final int peopleCount;
  final int airConditionersCount;
  final bool isRoundTrip;
  final List<bool> checklistValues;
  final String notes;

  //booking select package
  final List<Package> packages;
  final bool isHandlingExpanded;
  final bool isDisassemblyExpanded;
  final int? selectedPackageIndex;
  final List<int>
      additionalServiceQuantities; // Track quantities of additional services
  final List<ServicesFeeSystemEntity> servicesFeeList;
  //

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
      'packages': packages,
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
    this.totalPrice = 0.0,
    this.packagePrice = 0.0,
    this.peopleCount = 1,
    this.airConditionersCount = 1,
    this.isRoundTrip = false,
    List<bool>? checklistValues,
    this.notes = '',
    this.servicesFeeList = const [],
    //booking select packages
    this.packages = const [],
    this.isHandlingExpanded = false,
    this.isDisassemblyExpanded = false,
    this.selectedPackageIndex,
    this.additionalServiceQuantities = const [0, 0, 0],

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
    double? packagePrice,
    int? peopleCount,
    int? airConditionersCount,
    bool? isRoundTrip,
    List<bool>? checklistValues,
    String? notes,
    List<ServicesFeeSystemEntity>? servicesFeeList,
    //booking select package
    List<Package>? packages,
    bool? isHandlingExpanded,
    bool? isDisassemblyExpanded,
    int? selectedPackageIndex,
    List<int>? additionalServiceQuantities,

    //

    //location
    bool? isSelectingPickUp,
    LocationModel? pickUpLocation,
    LocationModel? dropOffLocation,
    DateTime? bookingDate,
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

      packagePrice: packagePrice ?? this.packagePrice,
      peopleCount: peopleCount ?? this.peopleCount,
      airConditionersCount: airConditionersCount ?? this.airConditionersCount,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      checklistValues: checklistValues ?? this.checklistValues,

      notes: notes ?? this.notes,
      servicesFeeList: servicesFeeList ?? this.servicesFeeList,
      //booking select package
      packages: packages ?? this.packages,
      isHandlingExpanded: isHandlingExpanded ?? this.isHandlingExpanded,
      isDisassemblyExpanded:
          isDisassemblyExpanded ?? this.isDisassemblyExpanded,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      additionalServiceQuantities:
          additionalServiceQuantities ?? this.additionalServiceQuantities,

      //
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
    );
  }
}
