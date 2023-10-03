import 'dart:convert';

import 'package:bloc/bloc.dart';
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    if (formKey.currentState!.validate()) {
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
        paymentIntent = await createPaymentIntent('100', 'USD');
        if (paymentIntent != null &&
            paymentIntent!['client_secret'] != null &&
            paymentIntent!['next_action'] == null) {
          emit(PaymentSuccess());
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
}