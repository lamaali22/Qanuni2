import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanuni/data/models/lawyerModel.dart';
import 'package:qanuni/data/models/review_model.dart';
import 'package:qanuni/viewListOfLawyers.dart';
part 'client_review_state.dart';

class ClientReviewCubit extends Cubit<ClientReviewState> {
  ClientReviewCubit() : super(ClientReviewInitial());

  static ClientReviewCubit get(context) => BlocProvider.of(context);

  String lawyerName = '';
  String lawyerImg = '';
  String lawyerRating = '';
  String bookingId = '';
  String lawyerEmail = '';
  List<dynamic> specialities = [];
  double clientRate = 0.0;
  TextEditingController clientReviewController = TextEditingController();

  reset() {
    lawyerName = '';
    lawyerImg = '';
    lawyerRating = '';
    bookingId = '';
    lawyerEmail = '';
    specialities = [];
    clientRate = 0.0;
    clientReviewController.text = '';
    emit(ClientReviewInitial());
  }

  init(String name, String img, String rating, String booking,
      List<dynamic> spec, String email, String? review, double? rate) {
    lawyerName = name;
    lawyerImg = img;
    lawyerRating = rating;
    bookingId = booking;
    specialities = spec;
    lawyerEmail = email;
    clientReviewController.text = review ?? '';
    clientRate = rate ?? 0.0;
    print(rate);
    emit(ClientReviewInitial());
  }

  changeRate(double rate) {
    clientRate = rate;
    emit(ClientReviewInitial());
  }

  submit() async {
    try {
      emit(SubmittingReview());
      final firestore = FirebaseFirestore.instance;
      String? email = FirebaseAuth.instance.currentUser!.email;

      // Query the "reviews" collection for all reviews for the lawyer
      await firestore.collection('reviews').add(ReviewModel(
              bookingId: bookingId,
              clientEmail: email,
              lawyerEmail: lawyerEmail,
              reviews: clientReviewController.text,
              ratings: clientRate)
          .toJson());
      final reviewsQuery = await firestore
          .collection('reviews')
          .where('lawyerEmail', isEqualTo: lawyerEmail)
          .get();

      await firestore.collection('bookings').doc(bookingId).set(
          {'review': clientReviewController.text, 'rate': clientRate},
          SetOptions(merge: true));

      // Calculate the average rating
      double totalRating = 0.0;
      int totalRatingsCount = 0;

      for (final review in reviewsQuery.docs) {
        final rating = review.data()['ratings'] as double;
        if (rating != null && rating != 0.0) {
          totalRating += rating;
          totalRatingsCount++;
        }
      }

      // Calculate the new average rating
      final newAverageRating =
          totalRatingsCount == 0 ? 0.0 : totalRating / totalRatingsCount;

      // Update the "Lawyers" collection with the new average rating directly
      final lawyersCollection = firestore.collection('lawyers');
      await lawyersCollection
          .where('email', isEqualTo: lawyerEmail)
          .get()
          .then((querySnapshot) {
        for (final document in querySnapshot.docs) {
          document.reference
              .update({'AverageRating': newAverageRating.toStringAsFixed(1)});
        }
      });

      emit(ReviewSubmitted());
    } catch (e) {
      print(e);
      emit(Error(error: e.toString()));
    }
  }
}
