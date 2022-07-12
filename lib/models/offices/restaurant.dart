import 'package:flutter/material.dart';
import 'package:safari/models/offices/office.dart';

class Restaurant extends Office {
  String id;

  TimeOfDay timeFrom;
  TimeOfDay timeTo;
  List<String> typeOfFood;

  Restaurant(
      {required this.id,
      required this.timeFrom,
      required this.timeTo,
      required this.typeOfFood,
      required super.country,
      required super.stars,
      required super.phone,
      required super.imagesPath,
      required super.description,
      required super.address,
      required super.account,
      required super.name,
      required super.area,
      required super.city});

  factory Restaurant.fromJson(Map json){
    return Restaurant(id: json['id'],
        timeFrom: TimeOfDay.fromDateTime(json['time_from']),
        timeTo: TimeOfDay.fromDateTime(json['time_to']),
        typeOfFood:json['type_of_food'] ,
        country: OfficeBase.fromLocation(json['location'], 0),
        stars: json['stars'] ?? 0,
        phone: json['phone'],
        imagesPath: json['image_path'],
        description: json['description'],
        address: json['address'],
        account: json['account'],
        name: json['name'],
        area: OfficeBase.fromLocation(json['location'], 2),
        city: OfficeBase.fromLocation(json['location'], 1));
  }




  Map<String, dynamic> joJson() {
    return {
      "name":name,
      "location":"$country/$city/$area",
      "stars":stars,
      "phone":phone,
      "images":imagesPath,
      "description":description,
      "account":account,

    };
  }
}
