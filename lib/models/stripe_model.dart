class StripeModel {
  String? transactionId;
  double? totalAmount;
  String? currency;
  // ignore: non_constant_identifier_names
  String? payment_method_types;
  String? status;
  bool? paymentProcess;
  DateTime? createdAt;
  String? userId;
  String? locationId;
  String? quantity;

  StripeModel({
    this.transactionId,
    this.totalAmount,
    this.currency,
    // ignore: non_constant_identifier_names
    this.payment_method_types,
    this.status,
    this.paymentProcess,
    this.createdAt,
    this.userId,
    this.locationId,
    this.quantity,
  });

  factory StripeModel.fromJson(Map<String, dynamic> json) {
    return StripeModel(
        transactionId: json['transactionId'],
        totalAmount: (json['totalAmount'] ?? 0) / 100,
        currency: json['currency'],
        payment_method_types: json['payment_method_types']?.first,
        status: json['status'],
        paymentProcess: false,
        createdAt: DateTime.now(),
        userId: json['userId'],
        locationId: json['locationId'],
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'totalAmount': totalAmount,
      'currency': currency,
      'payment_method_types': payment_method_types,
      'status': status,
      'paymentProcess': paymentProcess,
      'createdAt': createdAt?.toIso8601String(),
      'userId': userId,
      'locationId': locationId,
      'quantity': quantity,
    };
  }

  static Map<String, dynamic> stripeModelToMap(StripeModel stripeModel) {
    return {
      'transactionId': stripeModel.transactionId,
      'totalAmount': stripeModel.totalAmount,
      'currency': stripeModel.currency,
      'payment_method_types': stripeModel.payment_method_types,
      'status': stripeModel.status,
      'paymentProcess': stripeModel.paymentProcess,
      'createdAt': stripeModel.createdAt?.millisecondsSinceEpoch,
      'userId': stripeModel.userId,
      'locationId': stripeModel.locationId,
      'quantity': stripeModel.quantity
    };
  }
}
