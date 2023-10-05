import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:qanuni/utils/constants.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  static PaymentCubit get(context) => BlocProvider.of(context);

  TextEditingController cardHoldeNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  Map<String, dynamic>? paymentIntent;
  String timeslot = '';
  String price = '0';
  DateTime? selectedDate;
  String lawyerEmail = '';
  late User? _user;
  String dateOldValue = '';

  init(String slot, String selectedPrice, DateTime date, String lawyerMail) {
    price = selectedPrice;
    timeslot = slot;
    selectedDate = date;
    lawyerEmail = lawyerMail;
    _user = FirebaseAuth.instance.currentUser;

    emit(PaymentInitial());
  }

  Future<void> makePayment() async {
    emit(ProcessingPayment());

    try {
      var billingDetails = const BillingDetails(); // mocked data for tests
      await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
          number: cardNumberController.text,
          expirationMonth: int.parse(expiryController.text.split('/').first),
          expirationYear: int.parse(expiryController.text.split('/').last),
          cvc: cvvController.text));
      // 2. Create payment method
      await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      paymentIntent = await createPaymentIntent(price, 'SAR');
      if (paymentIntent != null &&
          paymentIntent!['client_secret'] != null &&
          paymentIntent!['next_action'] == null) {
        bookSelectedTimeSlot();
      } else {
        emit(InvalidCard());
      }
    } catch (err) {
      print(err);
      if (err is StripeException) {
        emit(Error(error: err.error.message!));
      } else {
        emit(Error(error: err.toString()));
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    //Make post request to Stripe
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${AppConstants.stripeSecret}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return json.decode(response.body);
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  void bookSelectedTimeSlot() async {
    DateTime startOfDay = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        int.parse(timeslot.split(':').first),
        int.parse(timeslot.split(':').last));

    try {
      // Get the client's email from the current user
      String? clientEmail = _user?.email;

      if (clientEmail != null) {
        // Query the available time slot
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('timeSlots')
            .where('available', isEqualTo: true)
            .where('lawyerEmail', isEqualTo: lawyerEmail)
            .where('startTime', isEqualTo: Timestamp.fromDate(startOfDay))
            .get();

        print('Query snapshot size: ${querySnapshot.size}');

        if (querySnapshot.size > 0) {
          String timeSlotId = querySnapshot.docs[0].id;

          print('Selected time slot: $timeslot');

          // Ensure that the selected time slot matches the available time slots
          if (querySnapshot.docs.any((doc) =>
              _formatTime((doc['startTime'] as Timestamp).toDate()) ==
              timeslot)) {
            // Update 'available' status in 'timeSlots' collection
            await FirebaseFirestore.instance
                .collection('timeSlots')
                .doc(timeSlotId)
                .update({'available': false});

            // Add a new document to 'bookings' collection
            await FirebaseFirestore.instance.collection('bookings').add({
              'clientEmail': clientEmail,
              'lawyerEmail': lawyerEmail,
              'startTime': startOfDay,
              'endTime': startOfDay.add(Duration(hours: 1)),
              'timeSlotId': timeSlotId,
            });

            emit(PaymentSuccess());
          }
        }
      } else {
        print(
            'Client email is null. Provide a default value or handle accordingly.');
      }
    } catch (e) {
      print('Error booking time slot: $e');
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  onCardDateChange(String text) {
    print('$text >>> $dateOldValue');

    if (text.length == 2 && !dateOldValue.contains('/')) {
      expiryController.text += '/';
    } else if (text.length == 3) {
      expiryController.text = text.substring(0, 2);
    }
    dateOldValue = expiryController.text;

    emit(PaymentInitial());
  }

  clearData() {
    cardHoldeNameController.clear();
    cardNumberController.clear();
    expiryController.clear();
    cvvController.clear();
    paymentIntent = null;
    timeslot = '';
    price = '0';
    selectedDate = null;
    lawyerEmail = '';
    _user = null;
    emit(PaymentInitial());
  }
}
