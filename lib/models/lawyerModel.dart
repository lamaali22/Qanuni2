class lawyerModel {
  final String? id; // id added
  final String firstName;
  final String lastName;
  final String dateOfBirth; // changed to string مبدأيا
  final String email;
  final String password;
  final String phone; //not sure if it's string
  final String gender;
  final String licenseNumber;
  final String iban;
  List<String> specialties;
  final String price;
  final String bio;
  final String photoURL;

  lawyerModel({
    this.id, // id added
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.licenseNumber,
    required this.iban,
    required this.specialties,
    required this.price,
    required this.bio,
    required this.photoURL,
  });

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "dateOfBirth": dateOfBirth,
      "phoneNumber": phone,
      "email": email,
      "password": password,
      "gender": gender,
      "licenseNumber": licenseNumber,
      "iban": iban,
      "specialties": specialties,
      "price": price,
      "bio": bio,
      "photoURL": photoURL
    };
  }
}
