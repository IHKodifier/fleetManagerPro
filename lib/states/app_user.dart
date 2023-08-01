// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:core';

import 'package:equatable/equatable.dart';

import 'package:fleet_manager_pro/states/vehicle.dart';

/// An App User account

class AppUser extends Equatable {
  final String uuid;
  String? location;
  String? profileType;
  String? displayName;
  String? photoUrl;
   List<Vehicle?>?  vehicles;
 
  String? email;
  String? phone;
  AppUser({
    required this.uuid,
    this.location,
    this.profileType,
    this.displayName,
    this.photoUrl,
     this.vehicles,
    this.email,
    this.phone,
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      uuid,
      location!,
      profileType!,
      displayName!,
      photoUrl!,
      // vehicles!,
      email!,
      phone!,
    ];
  }

  AppUser copyWith({
    String? uuid,
    String? location,
    String? profileType,
    String? displayName,
    String? photoUrl,
    List<Vehicle?>? vehicles,
    String? email,
    String? phone,
  }) {
    return AppUser(
      uuid: uuid ?? this.uuid,
      location: location ?? this.location,
      profileType: profileType ?? this.profileType,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      vehicles: vehicles ?? this.vehicles,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
  AppUser cloneFrom( AppUser from ){
 return AppUser(uuid: from.uuid,
location: from.location,
profileType: from.profileType ,
      displayName: from.displayName,
      email: from.email,
      phone: from.phone,
);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'uuid': uuid});
    if(location != null){
      result.addAll({'location': location});
    }
    if(profileType != null){
      result.addAll({'profileType': profileType});
    }
    if(displayName != null){
      result.addAll({'displayName': displayName});
    }
    if(photoUrl != null){
      result.addAll({'photoUrl': photoUrl});
    }
    if(vehicles != null){
      result.addAll({'vehicles': vehicles!.map((x) => x?.toMap()).toList()});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(phone != null){
      result.addAll({'phone': phone});
    }
  
    return result;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uuid: map['uuid'] ?? '',
      location: map['location'],
      profileType: map['profileType'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      vehicles: map['vehicles'] != null ? List<Vehicle?>.from(map['vehicles']?.map((x) => Vehicle?.fromMap(x))) : null,
      email: map['email'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uuid: $uuid, location: $location, profileType: $profileType, displayName: $displayName, photoUrl: $photoUrl, vehicles: $vehicles, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.uuid == uuid &&
      other.location == location &&
      other.profileType == profileType &&
      other.displayName == displayName &&
      other.email == email &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      location.hashCode ^
      profileType.hashCode ^
      displayName.hashCode ^
      email.hashCode ^
      phone.hashCode;
  }
}
