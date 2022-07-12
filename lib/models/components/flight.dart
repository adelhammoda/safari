class Flight {
  String id;
  String from,to;
  double cost;
  DateTime dateFrom;
  DateTime dateTo;
  int numberOfPassengers,passengersCapacity;

  Flight({
    required this.id,
    required this.cost,
    required this.dateFrom,
    required this.dateTo,
    required this.from,
    required this.numberOfPassengers,
    required this.passengersCapacity,
    required this.to,
  });

  factory Flight.fromJson(Map json) {
    return Flight(
      from: json['from'],
        id: json['id'],
        cost: json['cost'],
        dateFrom: DateTime.parse(json['date_from']),
        dateTo: DateTime.parse(json['date_to']),
        numberOfPassengers: json['number_0f_passengers'],
        passengersCapacity: json['passengers_capacity'],
        to: json['to']);
  }

  Map<String ,dynamic> joJson(){
    return{
      'from':from,
      'to':to,
      'passengers_capacity':passengersCapacity,
      'number_0f_passengers':numberOfPassengers,
      'date_to':dateFrom.toIso8601String(),
      'date_from':dateTo.toIso8601String(),
      'cost':cost,
    };
  }
}
