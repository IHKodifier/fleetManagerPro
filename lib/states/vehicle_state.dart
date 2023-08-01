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

  void updateDriven(int driven) {
    state = state.copyWith(driven: driven);
  }

  void addVehicleImages(List<String?> images) {
    state.images?.insertAll(0, images);
    // state= state.copyWith(images: images);
    state = state.copyWith();
  }
void refreshVehicle(){
  state = state.copyWith();
}
}
