import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/truck_entity_response.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_model_list_price.dart';

class VehicleListPriceProvider extends StateNotifier<int> {
  List<Truck> _vehiclesList;

  VehicleListPriceProvider({required List<Truck> vehiclesList})
      : _vehiclesList = vehiclesList,
        super(0);

  void updateVehiclesList(List<Truck> newList) {
    _vehiclesList = newList;
    state = 0;
  }

  Truck? get currentVehicle =>
      _vehiclesList.isNotEmpty && state < _vehiclesList.length
          ? _vehiclesList[state]
          : null;

  void nextVehicle() {
    if (state < _vehiclesList.length - 1) {
      state = state + 1;
    }
  }

  void previousVehicle() {
    if (state > 0) {
      state = state - 1;
    }
  }
}
