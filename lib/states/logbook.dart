import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../states/destination.dart'; // Import the Destination class

class Logbook extends Equatable {
  String id;
  Timestamp timestamp;
  List<Destination> destinations; // Change the type to List<Destination>
  double kmsTravelled;
  int startReading;
  int endReading;
  String driver;

  // Constructor with just the id
  Logbook({required this.id})
      : timestamp = Timestamp.now(),
        destinations = [], // Initialize as an empty list of Destination
        kmsTravelled = 0.0,
        startReading = 0,
        endReading = 0,
        driver = '';

  Logbook._({
    required this.id,
    required this.timestamp,
    required this.destinations, // Change the type to List<Destination>
    required this.kmsTravelled,
    required this.startReading,
    required this.endReading,
    required this.driver,
  });

  factory Logbook.full({
    required String id,
    required Timestamp timestamp,
    required List<Destination>
        destinations, // Change the type to List<Destination>
    required double kmsTravelled,
    required int startReading,
    required int endReading,
    required String driver,
  }) {
    return Logbook._(
      id: id,
      timestamp: timestamp,
      destinations: destinations, // Change the type to List<Destination>
      kmsTravelled: kmsTravelled,
      startReading: startReading,
      endReading: endReading,
      driver: driver,
    );
  }

  @override
  List<Object> get props => [
        id,
        timestamp,
        destinations,
        kmsTravelled,
        startReading,
        endReading,
        driver
      ];

  @override
  bool get stringify => true;

  Logbook copyWith({
    String? id,
    Timestamp? timestamp,
    List<Destination>? destinations, // Change the type to List<Destination>
    double? kmsTravelled,
    int? startReading,
    int? endReading,
    String? driver,
  }) {
    return Logbook._(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      destinations: destinations ??
          this.destinations, // Change the type to List<Destination>
      kmsTravelled: kmsTravelled ?? this.kmsTravelled,
      startReading: startReading ?? this.startReading,
      endReading: endReading ?? this.endReading,
      driver: driver ?? this.driver,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'destinations': destinations
          .map((destination) => destination.toMap())
          .toList(), // Convert each Destination to a map
      'kmsTravelled': kmsTravelled,
      'startReading': startReading,
      'endReading': endReading,
      'driver': driver,
    };
  }

  factory Logbook.fromMap(Map<String, dynamic> map) {
    return Logbook.full(
      id: map['id'],
      timestamp: map['timestamp'],
      destinations: (map['destinations'] as List)
          .map((item) => Destination.fromMap(item))
          .toList(), // Convert each map to a Destination
      kmsTravelled: map['kmsTravelled'],
      startReading: map['startReading'],
      endReading: map['endReading'],
      driver: map['driver'],
    );
  }
}
