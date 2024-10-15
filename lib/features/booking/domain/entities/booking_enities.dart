// booking_entities.dart

import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';

import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';

class Booking {
  final HouseTypeEntity? houseType;

  final String? reviewType;
  final int? numberOfRooms;
  final int? numberOfFloors;
  final int? selectedVehicleIndex;
  final double vehiclePrice;
  final List<Vehicle> availableVehicles;
  final double totalPrice;
  final ServiceEntity? selectedVehicle;

  final double packagePrice;
  final bool isRoundTrip;
  final List<bool> checklistValues;
  final String notes;

  // Booking select package

  final int? selectedPackageIndex;
  final List<int> additionalServiceQuantities;
  final List<ServicesFeeSystemEntity> servicesFeeList;

  // Added from booking_provider_these.dart
  final List<ServicesPackageEntity> selectedPackages;
  final List<SubServiceEntity> selectedSubServices;

  // Image lists for each room
  final List<String> livingRoomImages;
  final List<String> bedroomImages;
  final List<String> diningRoomImages;
  final List<String> officeRoomImages;
  final List<String> bathroomImages;

  // Location
  final bool isSelectingPickUp;
  final LocationModel? pickUpLocation;
  final LocationModel? dropOffLocation;
  final DateTime? bookingDate;

  // FromJson and ToJson methods
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      houseType: json['houseType'],

      numberOfRooms: json['numberOfRooms'],
      numberOfFloors: json['numberOfFloors'],
      selectedVehicleIndex: json['selectedVehicleIndex'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      selectedPackageIndex: json['selectedPackageIndex'],
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 0.0,
      isRoundTrip: json['isRoundTrip'] ?? false,
      notes: json['notes'] ?? '',

      // Location
      pickUpLocation: json['pickUpLocation'] != null
          ? LocationModel.fromJson(json['pickUpLocation'])
          : null,
      dropOffLocation: json['dropOffLocation'] != null
          ? LocationModel.fromJson(json['dropOffLocation'])
          : null,
      livingRoomImages: List<String>.from(json['livingRoomImages'] ?? []),
      bedroomImages: List<String>.from(json['bedroomImages'] ?? []),
      diningRoomImages: List<String>.from(json['diningRoomImages'] ?? []),
      officeRoomImages: List<String>.from(json['officeRoomImages'] ?? []),
      bathroomImages: List<String>.from(json['bathroomImages'] ?? []),
      checklistValues:
          List<bool>.from(json['checklistValues'] ?? List.filled(10, false)),
      // Added fields
      selectedPackages: (json['selectedPackages'] as List<dynamic>?)
              ?.map((e) => ServicesPackageEntity.fromJson(e))
              .toList() ??
          [],
      selectedSubServices: (json['selectedSubServices'] as List<dynamic>?)
              ?.map((e) => SubServiceEntity.fromJson(e))
              .toList() ??
          [],
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
      'isRoundTrip': isRoundTrip,
      'notes': notes,
      // Location
      'pickUpLocation': pickUpLocation?.toJson(),
      'dropOffLocation': dropOffLocation?.toJson(),

      'livingRoomImages': livingRoomImages,
      'bedroomImages': bedroomImages,
      'diningRoomImages': diningRoomImages,
      'officeRoomImages': officeRoomImages,
      'bathroomImages': bathroomImages,
      'checklistValues': checklistValues,
      // Added fields
      'selectedPackages': selectedPackages.map((e) => e.toJson()).toList(),
      'selectedSubServices':
          selectedSubServices.map((e) => e.toJson()).toList(),
    };
  }

  Booking({
    this.houseType,
    this.reviewType,
    this.numberOfRooms,
    this.numberOfFloors,
    this.selectedVehicleIndex,
    this.vehiclePrice = 0.0,
    this.availableVehicles = const [],
    this.totalPrice = 0.0,
    this.packagePrice = 0.0,
    this.isRoundTrip = false,
    List<bool>? checklistValues,
    this.notes = '',
    this.servicesFeeList = const [],
    // Booking select packages
    this.selectedVehicle,
    this.selectedPackageIndex,
    this.additionalServiceQuantities = const [0, 0, 0],
    // Added fields
    this.selectedPackages = const [],
    this.selectedSubServices = const [],
    // Location
    this.isSelectingPickUp = false,
    this.pickUpLocation,
    this.dropOffLocation,
    this.bookingDate,
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
    HouseTypeEntity? houseType,
    String? reviewType,
    int? numberOfRooms,
    int? numberOfFloors,
    int? selectedVehicleIndex,
    double? vehiclePrice,
    List<Vehicle>? availableVehicles,
    double? totalPrice,
    double? packagePrice,
    bool? isRoundTrip,
    List<bool>? checklistValues,
    String? notes,
    List<ServicesFeeSystemEntity>? servicesFeeList,
    // Booking select package
    ServiceEntity? selectedVehicle,
    int? selectedPackageIndex,
    List<int>? additionalServiceQuantities,
    // Added fields
    List<ServicesPackageEntity>? selectedPackages,
    List<SubServiceEntity>? selectedSubServices,
    // Location
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

      reviewType: reviewType ?? this.reviewType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      selectedVehicleIndex: selectedVehicleIndex ?? this.selectedVehicleIndex,
      vehiclePrice: vehiclePrice ?? this.vehiclePrice,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      totalPrice: totalPrice ?? this.totalPrice,
      packagePrice: packagePrice ?? this.packagePrice,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      checklistValues: checklistValues ?? this.checklistValues,
      notes: notes ?? this.notes,
      servicesFeeList: servicesFeeList ?? this.servicesFeeList,
      // Booking select package
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,

      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      additionalServiceQuantities:
          additionalServiceQuantities ?? this.additionalServiceQuantities,
      // Added fields
      selectedPackages: selectedPackages ?? this.selectedPackages,
      selectedSubServices: selectedSubServices ?? this.selectedSubServices,
      // Location
      isSelectingPickUp: isSelectingPickUp ?? this.isSelectingPickUp,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      bookingDate: bookingDate ?? this.bookingDate,
      livingRoomImages: livingRoomImages ?? this.livingRoomImages,
      bedroomImages: bedroomImages ?? this.bedroomImages,
      diningRoomImages: diningRoomImages ?? this.diningRoomImages,
      officeRoomImages: officeRoomImages ?? this.officeRoomImages,
      bathroomImages: bathroomImages ?? this.bathroomImages,
    );
  }
}
