// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final String id;
  String name;

  Destination({
    required this.id,
     this.name='',
  });
  
  @override
  // TODO: implement props
  List<Object> get props => [id, name];
  

  Destination copyWith({
    String? id,
    String? name,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
  
    return result;
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Destination.fromJson(String source) => Destination.fromMap(json.decode(source));

  @override
  String toString() => 'Destination(id: $id, name: $name)';
}
