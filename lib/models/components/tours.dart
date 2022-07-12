class Tours {
  String id;
  String country;
  int days;
  List<String> images;
  DateTime leavingDate;
  DateTime returningDate;
  String name;
  int nights;
  Map<String, String> phones;
  double cost;
  String program;
  String programInclude;

  Tours({
    required this.id,
    required this.cost,
    required this.country,
    required this.name,
    required this.days,
    required this.images,
    required this.leavingDate,
    required this.nights,
    required this.phones,
    required this.program,
    required this.programInclude,
    required this.returningDate,
  });

  factory Tours.fromJson(Map json){
    return Tours(
        id:json['id'],
        cost: json['cost'],
        country: json['country'],
        name: json['name'],
        days: json['days'],
        images: json['images'],
        leavingDate: DateTime.parse(json['leaving_date']),
        nights: json['nights'],
        phones: json['phones'],
        program: json['program'],
        programInclude: json['program_include'],
        returningDate: DateTime.parse(json['returning_date']));
  }


  Map<String,dynamic> toJson(){
    return {
      'cost':cost,
      'name':name,
      'country':country,
      'days':days,
      'images':images,
      'leaving_date':leavingDate.toIso8601String(),
      'returning_date':returningDate.toIso8601String(),
      'phones':phones,
      'program':program,
      'program_include':programInclude,
      'nights':nights,
    };
  }


}