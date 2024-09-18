
// code rác -> làm clear

class Booking {
  final String? houseType;
  final int? numberOfRooms;
  final int? numberOfFloors;
  final int? selectedVehicleIndex;
  final double totalPrice;
  final int? selectedPackageIndex;
  final double packagePrice;
  final int peopleCount;
  final int airConditionersCount;
  final bool isRoundTrip;
  final List<bool> checklistValues;
  final String notes;

  Booking({
    this.houseType,
    this.numberOfRooms,
    this.numberOfFloors,
    this.selectedVehicleIndex,
    this.totalPrice = 0.0,
    this.selectedPackageIndex,
    this.packagePrice = 0.0,
    this.peopleCount = 1,
    this.airConditionersCount = 1,
    this.isRoundTrip = false,
    List<bool>? checklistValues,
    this.notes = '',
  }) : checklistValues = checklistValues ?? List.filled(10, false);

  Booking copyWith({
    String? houseType,
    int? numberOfRooms,
    int? numberOfFloors,
    int? selectedVehicleIndex,
    double? totalPrice,
    int? selectedPackageIndex,
    double? packagePrice,
    int? peopleCount,
    int? airConditionersCount,
    bool? isRoundTrip,
    List<bool>? checklistValues,
    String? notes,
  }) {
    return Booking(
      houseType: houseType ?? this.houseType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      numberOfFloors: numberOfFloors ?? this.numberOfFloors,
      selectedVehicleIndex: selectedVehicleIndex ?? this.selectedVehicleIndex,
      totalPrice: totalPrice ?? this.totalPrice,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      packagePrice: packagePrice ?? this.packagePrice,
      peopleCount: peopleCount ?? this.peopleCount,
      airConditionersCount: airConditionersCount ?? this.airConditionersCount,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      checklistValues: checklistValues ?? this.checklistValues,
      notes: notes ?? this.notes,
    );
  }
}
