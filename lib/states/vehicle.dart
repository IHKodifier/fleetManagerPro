import 'package:fleet_manager_pro/states/maintenances.dart';

class Vehicle {
  final String id;
  String? reg,make,model,doors;
  List<Maintenance?>? maintenances;

  Vehicle(this.id);

}