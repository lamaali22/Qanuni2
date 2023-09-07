class lawyerModel {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String email;
  final String phone;//not sure if it's string 
  final String gender;
  final String licenseNumber;
  final List<String> specialties;
  final double price;
  final String bio;

  lawyerModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    required this.gender,
    required this.licenseNumber,
    required this.specialties,
    required this.price,
    required this.bio,
  });
}