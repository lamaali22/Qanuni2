class ReviewModel {
  String? bookingId;
  String? clientEmail;
  String? lawyerEmail; //changed to String instead of DateTime temporarly(lama)
  double? ratings; //not sure if it's string
  String? reviews; //added reviews (lama)

  ReviewModel({
    required this.bookingId,
    required this.clientEmail,
    required this.lawyerEmail,
    required this.reviews,
    required this.ratings,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'] ?? '';
    clientEmail = json['clientEmail'] ?? '';
    lawyerEmail = json['lawyerEmail'] ?? '';
    if (json['ratings'] != null) {
      ratings = json['ratings'] is int
          ? (json['ratings'] as int).toDouble()
          : json['ratings'];
    } else {
      ratings = 0.0;
    }

    reviews = json['reviews'] ?? '';
  }

  toJson() {
    return {
      "bookingId": bookingId,
      "clientEmail": clientEmail,
      "lawyerEmail": lawyerEmail,
      "ratings": ratings,
      "reviews": reviews,
    };
  }
}
