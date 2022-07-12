class Car {
  String id;
  double costPerHour;
  List<String> imagePath;
  Map phone;
  String name;
  int capacity;


  Car({
    required this.id,
    required this.name,
    required this.phone,
    required this.capacity,
    required this.costPerHour,
    required this.imagePath,
  });

  factory Car.fromJson(Map json){
    return Car(id: json['id'],
        name: json['name'],
        phone: json['phone'],
        capacity: json['capacity'],
        costPerHour: json['cost'],
        imagePath: json['images']);
  }

  Map toJson(){
    return {
      'name':name,
      'phone':phone,
      'capacity':capacity,
      'cost':costPerHour,
      'images':imagePath,
    };
  }


}