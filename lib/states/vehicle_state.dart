import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentVehicleProvider =
    StateNotifierProvider<CurrentVehicleNotifier, Vehicle>((ref) {
  return CurrentVehicleNotifier();
});

class CurrentVehicleNotifier extends StateNotifier<Vehicle> {
  CurrentVehicleNotifier() : super(Vehicle(id: ''));

  void setVehicle(Vehicle vehicle) {
    state = vehicle;
  }
}