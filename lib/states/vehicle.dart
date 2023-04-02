import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:fleet_manager_pro/states/maintenances.dart';

class Vehicle extends Equatable {
 

 


   String id;
  int? doors;
  List<Maintenance?>? maintenances;
  String? make;
  String? model;
  String? year;
  String? reg;
  String? regCity;
  List<String?>? images;
  Vehicle({
    required this.id,
    this.doors,
    this.maintenances,
    this.make,
    this.model,
    this.year,
    this.reg,
    this.regCity,
    this.images,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      doors!,
      maintenances!,
      make!,
      model!,
      year!,
      reg!,
      regCity!,
      images!,
    ];
  }


  Vehicle copyWith({
    String? id,
    int? doors,
    List<Maintenance?>? maintenances,
    String? make,
    String? model,
    String? year,
    String? reg,
    String? regCity,
    List<String?>? images,
  }) {
    return Vehicle(
      id: id ?? this.id,
      doors: doors ?? this.doors,
      maintenances: maintenances ?? this.maintenances,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      reg: reg ?? this.reg,
      regCity: regCity ?? this.regCity,
      images:images??this.images,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    if(doors != null){
      result.addAll({'doors': doors});
    }
    if(maintenances != null){
      result.addAll({'maintenances': maintenances!.map((x) => x?.toMap()).toList()});
    }
    if(make != null){
      result.addAll({'make': make});
    }
    if(model != null){
      result.addAll({'model': model});
    }
    if(year != null){
      result.addAll({'year': year});
    }
    if(reg != null){
      result.addAll({'reg': reg});
    }
    if(regCity != null){
      result.addAll({'regcity': regCity});
    }
    if(images != null){
      result.addAll({'images': images!.map((x) => x).toList()});
    }
  
    return result;
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] ?? '',
      doors: map['doors']?.toInt(),
      maintenances: map['maintenances'] != null ? List<Maintenance?>.from(map['maintenances']?.map((x) => Maintenance?.fromMap(x))) : null,
      make: map['make'],
      model: map['model'],
      year: map['year'],
      reg: map['reg'],
      regCity: map['regcity'],
      images: map['images'] != null ?
       List<String?>.from(map['images']?.map(( x) => x)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vehicle.fromJson(String source) => Vehicle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Vehicle(id: $id, doors: $doors, maintenances: $maintenances, make: $make, model: $model, year: $year, reg: $reg, regCity: $regCity, images: $images)';
  }
}
