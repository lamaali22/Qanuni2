class clientModel {
  final String firstName;
  final String lastName;
  final String
      dateOfBirth; //changed to String instead of DateTime temporarly(lama)
  final String email;
  final String phone; //not sure if it's string
  final String password; //added password (lama)
  final String gender;

  clientModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
  });

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "dateOfBirth": dateOfBirth,
      "phoneNumber": phone,
      "email": email,
      "password": password,
      "gender": gender
    };
  }
}
