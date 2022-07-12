import 'package:flutter/material.dart';

abstract class OfficeBase {
  String name;
  String city;
  String country;
  String area;
  int stars;
  double phone;
  Map<String, String> address;
  String description;
  List<String> imagesPath = List.empty(growable: false)
    ..length = 3;
  String account;

  OfficeBase({required this.name,
    required this.account,
    required this.address,
    required this.description,
    required this.imagesPath,
    required this.city,
    required this.country,
    required this.area,
    required this.phone,
    required this.stars});

  static String fromLocation(String location,int i){
   return   location.split('/')[i];
  }
}


class Office implements OfficeBase {
  @override
  String account;

  @override
  Map<String, String> address;

  @override
  String area;

  @override
  String city;

  @override
  String country;

  @override
  String description;

  @override
  List<String> imagesPath;

  @override
  String name;

  @override
  double phone;

  @override
  int stars;

  Office({
    required this.country,
    required this.stars,
    required this.phone,
    required this.imagesPath,
    required this.description,
    required this.address,
    required this.account,
    required this.name,
    required this.area,
    required this.city
  });


  factory Office.fromJson(Map json){
    try {
      return Office(
          country: OfficeBase.fromLocation(json['location'], 0),
          stars: json['stars'],
          phone: json['phone'],
          imagesPath: json['image_path'],
          description: json['description'],
          address: json['address'],
          account: json['account'],
          name: json['name'],
          area: json['area'],
          city: json['city']);
    } on Exception catch (e) {
      throw "Error happened while trying to decode office";
    }
  }



}
