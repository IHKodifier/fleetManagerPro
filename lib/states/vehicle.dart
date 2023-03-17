import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fleet_manager_pro/states/maintenances.dart';

class Vehicle extends Equatable {
  Vehicle(
    this.doors,
    this.id,
    this.maintenances,
    this.make,
    this.model,
    this.year,
    this.reg,
    this.regCity,
  );

  factory Vehicle.fromJson(String source) =>
      Vehicle.fromMap(json.decode(source));

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      map['doors']?.toInt(),
      map['id'] ?? '',
      map['maintenances'] != null
          ? List<Maintenance?>.from(
              map['maintenances']?.map((x) => Maintenance?.fromMap(x)))
          : null,
      map['make'],
      map['model'],
      map['year'],
      map['reg'],
      map['regCity'],
    );
  }

  int? doors;
  final String id;
  List<Maintenance?>? maintenances;
  String? make;
  String? model;
  String? year;
  String? reg;
  String? regCity;

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      doors ?? '',
      maintenances ?? [],
      make ?? '',
      model ?? '',
      year ?? '',
      reg ?? '',
      regCity ?? '',
    ];
  }

  @override
  String toString() {
    return 'Vehicle(doors: $doors, id: $id, maintenances: $maintenances, make: $make, model: $model, year: $year, reg: $reg, regCity: $regCity)';
  }

  Vehicle copyWith({
    int? doors,
    required final String id,
    List<Maintenance?>? maintenances,
    String? make,
    String? model,
    String? year,
    String? reg,
    String? regCity,
  }) {
    return Vehicle(
      doors ?? this.doors,
      id ,
      maintenances ?? this.maintenances,
      make ?? this.make,
      model ?? this.model,
      year ?? this.year,
      reg ?? this.reg,
      regCity ?? this.regCity,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (doors != null) {
      result.addAll({'doors': doors});
    }
    result.addAll({'id': id});
    if (maintenances != null) {
      result.addAll(
          {'maintenances': maintenances!.map((x) => x?.toMap()).toList()});
    }
    if (make != null) {
      result.addAll({'make': make});
    }
    if (model != null) {
      result.addAll({'model': model});
    }
    if (year != null) {
      result.addAll({'year': year});
    }
    if (reg != null) {
      result.addAll({'reg': reg});
    }
    if (regCity != null) {
      result.addAll({'regCity': regCity});
    }

    return result;
  }

  String toJson() => json.encode(toMap());
}
