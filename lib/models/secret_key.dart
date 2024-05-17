class StripeKeys {
  final String publishableKey;
  final String secretKey;
  final String squareKey;

  StripeKeys({
    required this.publishableKey,
    required this.secretKey,
    required this.squareKey,
  });

  factory StripeKeys.fromMap(Map<String, dynamic> map) {
    return StripeKeys(
      publishableKey: map['PUBLISHABLE_KEY'] as String,
      secretKey: map['STRIPE_SECRET'] as String,
      squareKey: map['SQUARE_SECRET'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PUBLISHABLE_KEY': publishableKey,
      'STRIPE_SECRET': secretKey,
      'SQUARE_SECRET': squareKey,
    };
  }

  void add(StripeKeys stripeKeys) {}
}
