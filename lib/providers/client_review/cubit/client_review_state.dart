part of 'client_review_cubit.dart';

@immutable
abstract class ClientReviewState {}

 class ClientReviewInitial extends ClientReviewState {}

class SubmittingReview extends ClientReviewState {}

class ReviewSubmitted extends ClientReviewState {}

class Error extends ClientReviewState {
  final String error;

  Error({required this.error});
}
