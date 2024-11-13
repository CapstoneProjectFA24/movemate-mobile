// booking_entities.dart

import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';

import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';

class Booking {
  // final int id;
  final HouseTypeEntity? houseType;

  final String? reviewType;
  final int? numberOfRooms;
  final int? numberOfFloors;
  final int? selectedVehicleIndex;
  final double vehiclePrice;
  final List<Vehicle> availableVehicles;
  final double? totalPrice;
  final InverseParentServiceEntity? selectedVehicle;
  final bool isUploadingLivingRoomImage;
  final bool isUploadingLivingRoomVideo;
  final String? houseTypeError; // New field for error message
  final String? vehicleError; // New field for error message

  final double packagePrice;
  final bool isRoundTrip;
  final bool isReviewOnline;
  final List<bool> checklistValues;
  final String notes;

  // Booking select package

  final int? selectedPackageIndex;
  final List<int> additionalServiceQuantities;
  final List<ServicesFeeSystemEntity> servicesFeeList;

  // Added from booking_provider_these.dart
  final List<ServicesPackageEntity> selectedPackages;
  final List<SubServiceEntity> selectedSubServices;
  final List<ServicesPackageEntity> selectedPackagesWithQuantity;

  // Image lists for each room
  final List<ImageData> livingRoomImages;
  final List<ImageData> bedroomImages;
  final List<ImageData> diningRoomImages;
  final List<ImageData> officeRoomImages;
  final List<ImageData> bathroomImages;
  final List<VideoData> livingRoomVideos;
  // Location
  final bool isSelectingPickUp;
  final LocationModel? pickUpLocation;
  final LocationModel? dropOffLocation;
  final DateTime? bookingDate;
  final String? selectorHasError;
  final String? estimatedDistance;
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
    this.isReviewOnline = false,
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
    this.selectedPackagesWithQuantity = const [],
    this.houseTypeError, // Default to no error
    this.vehicleError, // Default to no error
    // Location
    this.isSelectingPickUp = false,
    this.pickUpLocation,
    this.dropOffLocation,
    this.bookingDate,
    this.estimatedDistance,
    // Initialize image lists (empty by default)
    this.livingRoomVideos = const [],
    List<ImageData>? livingRoomImages,
    List<ImageData>? bedroomImages,
    List<ImageData>? diningRoomImages,
    List<ImageData>? officeRoomImages,
    List<ImageData>? bathroomImages,
    this.isUploadingLivingRoomImage = false,
    this.isUploadingLivingRoomVideo = false,
    this.selectorHasError, // Default to no error
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
    bool? isReviewOnline,
    List<bool>? checklistValues,
    String? notes,
    List<ServicesFeeSystemEntity>? servicesFeeList,
    String? houseTypeError,
    String? vehicleError,
    // Booking select package
    InverseParentServiceEntity? selectedVehicle,
    int? selectedPackageIndex,
    List<int>? additionalServiceQuantities,
    // Added fields
    List<ServicesPackageEntity>? selectedPackages,
    List<SubServiceEntity>? selectedSubServices,
    List<ServicesPackageEntity>? selectedPackagesWithQuantity,

    // Location
    bool? isSelectingPickUp,
    LocationModel? pickUpLocation,
    LocationModel? dropOffLocation,
    DateTime? bookingDate,
    bool setBookingDateToNull = false,
    String? selectorHasError,
    String? estimatedDistance,
    // Initialize image lists (empty by default)
    //add image
    List<VideoData>? livingRoomVideos,
    List<ImageData>? livingRoomImages,
    List<ImageData>? bedroomImages,
    List<ImageData>? diningRoomImages,
    List<ImageData>? officeRoomImages,
    List<ImageData>? bathroomImages,
    bool? isUploadingLivingRoomImage,
    bool? isUploadingLivingRoomVideo,

    ///
    // double? totalPriceResponse,
  }) {
    final newBookingDate =
        setBookingDateToNull ? null : (bookingDate ?? this.bookingDate);
    // print("Setting bookingDate to: $newBookingDate");
    // final newTotalPrice = totalPriceResponse ?? totalPrice;
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
      isReviewOnline: isReviewOnline ?? this.isReviewOnline,
      checklistValues: checklistValues ?? this.checklistValues,
      notes: notes ?? this.notes,
      servicesFeeList: servicesFeeList ?? this.servicesFeeList,
      // Booking select package
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      houseTypeError: houseTypeError,
      vehicleError: vehicleError,
      selectorHasError: selectorHasError,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      additionalServiceQuantities:
          additionalServiceQuantities ?? this.additionalServiceQuantities,
      selectedPackagesWithQuantity:
          selectedPackagesWithQuantity ?? this.selectedPackagesWithQuantity,

      // Added fields
      selectedPackages: selectedPackages ?? this.selectedPackages,
      selectedSubServices: selectedSubServices ?? this.selectedSubServices,
      // Location
      isSelectingPickUp: isSelectingPickUp ?? this.isSelectingPickUp,
      pickUpLocation: pickUpLocation ?? this.pickUpLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      // bookingDate: bookingDate ?? this.bookingDate,
      bookingDate: newBookingDate,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,

      //add image
      livingRoomVideos: livingRoomVideos ?? this.livingRoomVideos,
      livingRoomImages: livingRoomImages ?? this.livingRoomImages,
      bedroomImages: bedroomImages ?? this.bedroomImages,
      diningRoomImages: diningRoomImages ?? this.diningRoomImages,
      officeRoomImages: officeRoomImages ?? this.officeRoomImages,
      bathroomImages: bathroomImages ?? this.bathroomImages,
      isUploadingLivingRoomImage:
          isUploadingLivingRoomImage ?? this.isUploadingLivingRoomImage,
      isUploadingLivingRoomVideo:
          isUploadingLivingRoomVideo ?? this.isUploadingLivingRoomVideo,
    );
  }
}
