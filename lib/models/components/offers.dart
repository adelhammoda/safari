class Offers {
  String id;
  String companyID;
  String companyType;
  DateTime dateFrom, dateTo;
  String description, offerPath;
  double discount;

  Offers({
    required this.id,
    required this.dateTo,
    required this.dateFrom,
    required this.description,
    required this.companyID,
    required this.companyType,
    required this.discount,
    required this.offerPath,
  });


  factory Offers.fromJson(Map json){
    return Offers(
        id: json['id'],
        dateTo: DateTime.parse(json['date_to']),
        dateFrom: DateTime.parse(json['date_from']),
        description: json['description'],
        companyID: json['company_id'],
        companyType: json['company_type'],
        discount: json['discount'],
        offerPath: json['offer_path']);
  }

  Map toJson(){
    return {
      'date_to':dateTo.toIso8601String(),
      'date_from':dateFrom.toIso8601String(),
      'description':description,
      'company_id':companyID,
      "company_type":companyType,
      'discount':discount,
      'offer_path':offerPath,
    };
  }
}
