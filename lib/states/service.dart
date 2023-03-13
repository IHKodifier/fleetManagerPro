import 'dart:convert';

import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String name;
   DateTime? date;
final int cost;

  Service(
    this.name,
    this.date,
    this.cost,
  );
  

  Service copyWith({
    String? name,
    DateTime? date,
    int? cost,
  }) {
    return Service(
      name ?? this.name,
      date ?? this.date,
      cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    if(date != null){
      result.addAll({'date': date!.millisecondsSinceEpoch});
    }
    result.addAll({'cost': cost});
  
    return result;
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      map['name'] ?? '',
      map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date']) : null,
      map['cost']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) => Service.fromMap(json.decode(source));

  @override
  String toString() => 'Service(name: $name, date: $date, cost: $cost)';

  @override
  List<Object> get props => [name, date!, cost];
}
