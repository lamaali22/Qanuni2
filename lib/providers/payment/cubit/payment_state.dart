part of 'payment_cubit.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class ProcessingPayment extends PaymentState {}

class InvalidCard extends PaymentState {}

class Error extends PaymentState {
  final String error;

  Error({required this.error});
}