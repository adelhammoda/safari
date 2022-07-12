class Booking {
  String id;
  String bookingPattern, bookingType;
  DateTime? reservedFrom, reservedUntil;
  String reservedId;
  String userId;
  double cost;
  DateTime date;

  Booking(
      {required this.id,
      required this.cost,
      required this.reservedFrom,
      required this.bookingPattern,
      required this.bookingType,
      required this.date,
      required this.reservedId,
      required this.reservedUntil,
      required this.userId});

  factory Booking.fromJson(Map json) {
    return Booking(
        id: json['id'],
        cost: json['cost'],
        reservedFrom: DateTime.parse(json['reserved_from']),
        bookingPattern: json['booking_pattern'],
        bookingType: json['booking_type'],
        date: DateTime.parse(json['date']),
        reservedId: json['reserved_id'],
        reservedUntil: DateTime.parse(json['reserved_until']),
        userId: json['user_id']);
  }

  Map toJson() {
    return {
      'cost':cost,
      'reserved_from':reservedFrom?.toIso8601String(),
      'reserved_until':reservedUntil?.toIso8601String(),
      'booking_pattern':bookingPattern,
      'booking_type':bookingType,
      'date':date.toIso8601String(),
      'reserved_id':reservedId,
      'user_id':userId
    };
  }
}
