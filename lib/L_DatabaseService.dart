import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/lawyerModel.dart';

class L_DatabaseService {
  static Future<List<lawyerModel>> getLawyers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('lawyers').get();

    List<lawyerModel> lawyers = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      lawyerModel lawyer = lawyerModel(
        firstName: data['firstName'],
        lastName: data['lastName'],
        dateOfBirth: data['dateOfBirth'].toDate(),
        email: data['email'],
        phone: data['phone'],
        gender: data['gender'],
        licenseNumber: data['licenseNumber'],
        specialties: List<String>.from(data['specialties']),
        price: data['price'].toDouble(),
        bio: data['bio'],
      );
      lawyers.add(lawyer);
    });

    return lawyers;
  }
}