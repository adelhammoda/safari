class Room {
  String id;

  double costPerDay;
  DateTime reservedFrom;
  DateTime reservedUnitl;
  int roomNumber;
  String roomType;
  double size;

  Room({
    required this.id,
    required this.size,
    required this.costPerDay,
    required this.reservedFrom,
    required this.reservedUnitl,
    required this.roomNumber,
    required this.roomType,
  });

  factory Room.fromJson(Map json) {
    return Room(
        id: json['id'],
        size: json['size'],
        costPerDay: json['cost'],
        reservedFrom: json['reserved_from'],
        reservedUnitl: json['reserved_unitl'],
        roomNumber: json['room_number'],
        roomType: json['room_type']);
  }

  Map<String ,dynamic> joJson(){
    return{
      'size':size,
      'cost':costPerDay,
      'reserved_from':reservedFrom,
      'reserved_until':reservedUnitl,
      'room_type':roomType,
      'room_number':roomNumber
    };
  }
}
