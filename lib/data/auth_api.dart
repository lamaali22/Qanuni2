import 'package:cloud_firestore/cloud_firestore.dart';

class AuthApi {
  Future<int> checkClientExistence(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Clients')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return 0;
      } else {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('lawyers')
            .where('email', isEqualTo: email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          return 1;
        } else {
          return 2;
        }
      }
    } catch (e) {
      return 2;
    }
  }

  Future<bool> checkLawyerExistence(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('lawyers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
