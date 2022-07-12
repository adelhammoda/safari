class User {

  String id;
  String firstName, lastName;
  String email, userType, phoneNumber;


  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map json){
    return User(id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        userType: json['user_type'],
        email: json['email'],
        phoneNumber: json['phone_number']);
  }

  Map toJson(){
    return {
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'phone_number':phoneNumber,
      'user_type':userType,
    };
  }
}