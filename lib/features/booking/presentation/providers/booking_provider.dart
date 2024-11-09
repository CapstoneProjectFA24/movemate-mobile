// booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';
import '/features/booking/domain/entities/booking_enities.dart';

class BookingNotifier extends StateNotifier<Booking> {
  static const int maxImages = 5; // Giới hạn hình ảnh tối đa
  static const int maxVideos = 2; // Giới hạn video tối đa
  static const int maxVideoSize = 25 * 1024 * 1024; // 25 MB tính bằng bytes
  final emptyLocationModel = LocationModel(
    label: 'Chọn địa điểm',
    address: 'Chọn địa điểm',
    latitude: 0.0,
    longitude: 0.0,
    distance: 'Chọn địa điểm',
  );
  BookingNotifier()
      : super(Booking(
          totalPrice: 0.0,
          additionalServiceQuantities: [],
          livingRoomImages: [],
          livingRoomVideos: [],
        ));

  void updateSubServiceQuantity(SubServiceEntity subService, int newQuantity) {
    // Đảm bảo newQuantity không vượt quá quantityMax
    int finalQuantity = newQuantity;
    if (subService.quantityMax != null &&
        newQuantity > subService.quantityMax!) {
      finalQuantity = subService.quantityMax!;
    }
    List<SubServiceEntity> updatedSubServices =
        List.from(state.selectedSubServices);

    final index = updatedSubServices.indexWhere((s) => s.id == subService.id);

    if (index != -1) {
      if (finalQuantity > 0) {
        // Update existing subService's quantity
        updatedSubServices[index] =
            updatedSubServices[index].copyWith(quantity: finalQuantity);
      } else {
        // Remove subService if quantity is zero
        updatedSubServices.removeAt(index);
      }
    } else {
      if (finalQuantity > 0) {
        // Add new subService with the specified quantity
        updatedSubServices.add(subService.copyWith(quantity: finalQuantity));
      }
    }

    state = state.copyWith(selectedSubServices: updatedSubServices);
  }

  void updateServicesFeeQuantity(ServicesFeeSystemEntity fee, int newQuantity) {
    List<ServicesFeeSystemEntity> updatedServicesFeeList =
        List.from(state.servicesFeeList ?? []);

    final index = updatedServicesFeeList.indexWhere((f) => f.id == fee.id);

    if (index != -1) {
      if (newQuantity > 0) {
        // Update existing fee's quantity
        updatedServicesFeeList[index] =
            updatedServicesFeeList[index].copyWith(quantity: newQuantity);
      } else {
        // Remove fee if quantity is zero
        updatedServicesFeeList.removeAt(index);
      }
    } else {
      if (newQuantity > 0) {
        // Add new fee with specified quantity
        updatedServicesFeeList.add(fee.copyWith(quantity: newQuantity));
      }
    }

    state = state.copyWith(servicesFeeList: updatedServicesFeeList);

    // Recalculate total price
    calculateAndUpdateTotalPrice();
  }

// Method to update selected vehicle
  void updateSelectedVehicle(InverseParentServiceEntity vehicle) {
    state = state.copyWith(
      selectedVehicle: vehicle,
      vehicleError: null, // Clear error when vehicle is selected
    );

    calculateAndUpdateTotalPrice();
  }

  void setVehicleError(String error) {
    state = state.copyWith(vehicleError: error);
  }

  void clearVehicleError() {
    state = state.copyWith(vehicleError: null);
  }

  void updateServicePackageQuantity(
      ServicesPackageEntity servicePackage, int newQuantity) {
    List<ServicesPackageEntity> updatedPackages =
        List.from(state.selectedPackages);

    final index = updatedPackages.indexWhere((p) => p.id == servicePackage.id);

    if (index != -1) {
      if (newQuantity > 0) {
        // Update existing package's quantity
        updatedPackages[index] =
            updatedPackages[index].copyWith(quantity: newQuantity);
      } else {
        // Remove package if quantity is zero
        updatedPackages.removeAt(index);
      }
    } else {
      if (newQuantity > 0) {
        // Add new package with specified quantity
        updatedPackages.add(servicePackage.copyWith(quantity: newQuantity));
      }
    }

    state = state.copyWith(selectedPackages: updatedPackages);

    // Recalculate total price
    calculateAndUpdateTotalPrice();
  }

  void calculateAndUpdateTotalPrice() {
    double total = 0.0;

    // Tổng giá của các gói dịch vụ đã chọn
    for (var package in state.selectedPackages) {
      if ((package.quantity != null && package.quantity! > 0)) {
        total += package.amount * package.quantity!;
      }
    }

    // Tổng giá của các dịch vụ phụ đã chọn với số lượng
    for (var subService in state.selectedSubServices) {
      total += subService.amount * (subService.quantity ?? 1);
    }

    // Tổng giá của các dịch vụ phí hệ thống với số lượng
    for (var fee in state.servicesFeeList ?? []) {
      total += fee.amount * (fee.quantity ?? 0);
    }

    // Thêm giá của phương tiện đã chọn
    if (state.selectedVehicle != null) {
      total += state.selectedVehicle!.truckCategory!.price;
    }

    // Các tính toán khác (ví dụ: chuyến đi khứ hồi)
    if (state.isRoundTrip == true) {
      total *= 2;
    }

    // Tính thuế GTGT
    // double vat = total * 0.08;

    // Cập nhật tổng giá bao gồm thuế GTGT
    // total += vat;
    // Cập nhật tổng giá
    state = state.copyWith(totalPrice: total);
  }

  void updateBookingResponse(BookingResponseEntity response) {
    print(
        "tuan Updating booking response for first ${response.bookingDetails}");
    state = state.copyWith(
      totalPrice: response.total.toDouble(),
      // Bạn có thể cập nhật thêm các trường khác nếu cần
    );
    print("tuan Updated booking response for last ${response.bookingDetails}");
  }

  // Replaced updateRoundTrip method
  void updateRoundTrip(bool value) {
    state = state.copyWith(isRoundTrip: value);
    calculateAndUpdateTotalPrice();
  }

  void updateHouseType(HouseTypeEntity houseType) {
    state = state.copyWith(
      houseType: houseType,
      houseTypeError: null, // Clear error when house type is selected
    );
  }

  void setHouseTypeError(String error) {
    state = state.copyWith(houseTypeError: error);
  }

  void clearHouseTypeError() {
    state = state.copyWith(houseTypeError: null);
  }

  void updateNumberOfRooms(int rooms) {
    state = state.copyWith(numberOfRooms: rooms);
  }

  void updateNumberOfFloors(int floors) {
    state = state.copyWith(numberOfFloors: floors);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  /// xử lý ảnh và video

  // Method to set the loading state for uploading living room images
  void setUploadingLivingRoomImage(bool isUploading) {
    state = state.copyWith(isUploadingLivingRoomImage: isUploading);
  }

  // Method to set the loading state for uploading living room videos
  void setUploadingLivingRoomVideo(bool isUploading) {
    state = state.copyWith(isUploadingLivingRoomVideo: isUploading);
  }

// Phương thức lấy danh sách hình ảnh cho một loại phòng
  List<ImageData> getImages(RoomType roomType) {
    switch (roomType) {
      case RoomType.livingRoom:
        return state.livingRoomImages;
      case RoomType.bedroom:
        return state.bedroomImages;
      case RoomType.diningRoom:
        return state.diningRoomImages;
      case RoomType.officeRoom:
        return state.officeRoomImages;
      case RoomType.bathroom:
        return state.bathroomImages;
    }
  }

  // Phương thức lấy danh sách video cho phòng khách
  List<VideoData> getVideos(RoomType roomType) {
    switch (roomType) {
      case RoomType.livingRoom:
        return state.livingRoomVideos;
      // Nếu muốn mở rộng cho các loại phòng khác, thêm vào đây
      default:
        return [];
    }
  }

  // Phương thức kiểm tra xem có thể thêm hình ảnh mới hay không
  bool canAddImage(RoomType roomType) {
    return getImages(roomType).length < maxImages;
  }

  // Phương thức kiểm tra xem có thể thêm video mới hay không
  bool canAddVideo(RoomType roomType) {
    return getVideos(roomType).length < maxVideos;
  }

// Modify addImageToRoom to handle loading state
  Future<void> addImageToRoom(RoomType roomType, ImageData imageData) async {
    if (!canAddImage(roomType)) {
      // Không thêm hình ảnh nếu đã đạt giới hạn
      return;
    }

    // Set loading state if roomType is livingRoom
    if (roomType == RoomType.livingRoom) {
      setUploadingLivingRoomImage(true);
    }

    try {
      switch (roomType) {
        case RoomType.livingRoom:
          state = state.copyWith(
            livingRoomImages: [...state.livingRoomImages, imageData],
          );
          break;
        case RoomType.bedroom:
          state = state.copyWith(
            bedroomImages: [...state.bedroomImages, imageData],
          );
          break;
        case RoomType.diningRoom:
          state = state.copyWith(
            diningRoomImages: [...state.diningRoomImages, imageData],
          );
          break;
        case RoomType.officeRoom:
          state = state.copyWith(
            officeRoomImages: [...state.officeRoomImages, imageData],
          );
          break;
        case RoomType.bathroom:
          state = state.copyWith(
            bathroomImages: [...state.bathroomImages, imageData],
          );
          break;
      }
    } finally {
      // Reset loading state
      if (roomType == RoomType.livingRoom) {
        setUploadingLivingRoomImage(false);
      }
    }
  }

// Xóa hình ảnh khỏi phòng
  void removeImageFromRoom(RoomType roomType, ImageData imageData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages: state.livingRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages: state.bedroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages: state.diningRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages: state.officeRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages: state.bathroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
    }
  }

  // Xóa video khỏi phòng
  void removeVideoFromRoom(RoomType roomType, VideoData videoData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomVideos: state.livingRoomVideos
              .where((vid) => vid.publicId != videoData.publicId)
              .toList(),
        );
        break;
      // Nếu muốn mở rộng cho các loại phòng khác, thêm vào đây
      default:
        break;
    }
  }

  // Thêm video vào phòng với kiểm tra giới hạn và kích thước
  Future<void> addVideoToRoom(RoomType roomType, VideoData videoData) async {
    if (!canAddVideo(roomType)) {
      // Do not add video if maximum limit is reached
      return;
    }

    // Set loading state if roomType is livingRoom
    if (roomType == RoomType.livingRoom) {
      setUploadingLivingRoomVideo(true);
    }

    try {
      switch (roomType) {
        case RoomType.livingRoom:
          state = state.copyWith(
            livingRoomVideos: [...state.livingRoomVideos, videoData],
          );
          break;
        // If you want to support other room types for videos, add cases here
        default:
          break;
      }
    } finally {
      // Reset loading state
      if (roomType == RoomType.livingRoom) {
        setUploadingLivingRoomVideo(false);
      }
    }
  }

  void updateChecklistValue(int index, bool value) {
    final updatedChecklistValues = List<bool>.from(state.checklistValues);
    updatedChecklistValues[index] = value;
    state = state.copyWith(checklistValues: updatedChecklistValues);
  }

  // Location methods
  // void updatePickUpLocation(LocationModel? location) {
  //   state = state.copyWith(pickUpLocation: location);
  // }

  // void updateDropOffLocation(LocationModel? location) {
  //   state = state.copyWith(dropOffLocation: location);
  // }

  // void updateBookingDate(DateTime? date) {
  //   state = state.copyWith(bookingDate: date);
  // }

  void setSelectorHasError(String error) {
    state = state.copyWith(selectorHasError: error);
  }

  void clearSelectorHasError() {
    state = state.copyWith(selectorHasError: null);
  }

  void updatePickUpLocation(LocationModel? location) {
    print("Updating Pick-Up Location: ${location?.address}");
    state = state.copyWith(
      pickUpLocation: location,
      selectorHasError: null,
    );
  }

  void updateDropOffLocation(LocationModel? location) {
    print("Updating Drop-Off Location: ${location?.address}");
    state = state.copyWith(
      dropOffLocation: location,
      selectorHasError: null,
    );
  }

  void updateBookingDate(DateTime date) {
    state = state.copyWith(bookingDate: date);
    print("Updating Booking Date to ${state.bookingDate}");
  }

  void clearPickUpLocation() {
    state = state.copyWith(pickUpLocation: emptyLocationModel);
    print(
        " Clearing pick-up Location ${emptyLocationModel.address.toString()}");
  }

  void clearDropOffLocation() {
    state = state.copyWith(dropOffLocation: emptyLocationModel);
    print(" Clearing Drop-Off Location ${state.dropOffLocation?.address}");
  }

  void clearBookingDate() {
    state = state.copyWith(setBookingDateToNull: true);
    print("Clearing Booking Date ${state.bookingDate}");
  }

  void toggleSelectingPickUp(bool isSelecting) {
    state = state.copyWith(isSelectingPickUp: isSelecting);
  }

  void updateIsReviewOnline(bool isReviewOnline) {
    state = state.copyWith(isReviewOnline: isReviewOnline);
  }

  void resetHouseTypeInfo(
    HouseTypeEntity? houseType,
  ) {
    print("Resetting house type info");
    state = state.copyWith(
      houseType: HouseTypeEntity(name: 'Chọn loại nhà ở', description: ''),
      houseTypeError: null,
      numberOfRooms: 1,
      numberOfFloors: 1,
      selectedVehicleIndex: 0,
      vehiclePrice: 0.0,
      selectedPackageIndex: 0,
      packagePrice: 0.0,
      servicesFeeList: [],
    );
  }

  void resetVehiclesSelected(InverseParentServiceEntity? selectedVehicle) {
    print("Resetting house type info");
    state = state.copyWith(
      selectedVehicle: InverseParentServiceEntity(
        id: 0,
        name: 'not selected',
        description: '',
        isActived: true,
        tier: 1,
        imageUrl: 'default_url',
        type: 'default_type',
        discountRate: 0.0,
        amount: 0.0,
        isQuantity: true,
      ),
      vehicleError: null,
    );
  }

  // Hàm resetAllQuantities để đặt lại tất cả các gói dịch vụ
  void resetAllQuantities() {
    print("Resetting all quantities to 0 for all packages.");

    List<ServicesPackageEntity> updatedPackages =
        state.selectedPackages.map((package) {
      ServicesPackageEntity updatedPackage = package.copyWith(quantity: 0);

      if (package.type != 'SYSTEM') {
        List<SubServiceEntity> updatedSubServices =
            package.inverseParentService.map((subService) {
          return subService.copyWith(quantity: 0);
        }).toList();

        updatedPackage =
            updatedPackage.copyWith(inverseParentService: updatedSubServices);
        print(
            "Sub-services quantities reset to 0 for package ID: ${package.id}");
      }

      return updatedPackage;
    }).toList();

    state = state.copyWith(selectedPackages: updatedPackages);
    print("All service package quantities set to 0.");

    // Kiểm tra trạng thái mới
    for (var pkg in state.selectedPackages) {
      print(
          'Package ID: ${pkg.id}, Quantity: ${pkg.quantity}, Type: ${pkg.type}');
      for (var sub in pkg.inverseParentService) {
        print('  SubService ID: ${sub.id}, Quantity: ${sub.quantity}');
      }
    }
  }

  void reset() {
    state = Booking(
      totalPrice: 0.0,
      additionalServiceQuantities: [],
      livingRoomImages: [],
      livingRoomVideos: [],
      checklistValues: List.filled(10, false),
      bookingDate: null,
      isSelectingPickUp: false,
      isReviewOnline: false,
      houseType: null,
      isRoundTrip: false,
    );
  }
}

// The global provider that can be accessed in all screens
final bookingProvider = StateNotifierProvider<BookingNotifier, Booking>(
  (ref) => BookingNotifier(),
);

enum RoomType { livingRoom, bedroom, diningRoom, officeRoom, bathroom }
