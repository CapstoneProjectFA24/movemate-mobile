import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_model_list_price.dart';

class VehicleListPriceProvider extends StateNotifier<int> {
  final List<VehicleModel> vehiclesList;

  VehicleListPriceProvider({required this.vehiclesList}) : super(0);

  void nextVehicle() {
    state = (state + 1) % vehiclesList.length; // Move to the next vehicle
  }

  void previousVehicle() {
    state = (state - 1 + vehiclesList.length) %
        vehiclesList.length; // Move to the previous vehicle
  }

  VehicleModel get currentVehicle => vehiclesList[state];
}
