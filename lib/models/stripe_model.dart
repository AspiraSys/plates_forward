// class StripeModel {
//   String? id;
//   double? amount;
//   double? created;
//   String? currency;
//   String? payment_method_types;
//   String? status;
//   bool? paymentProcess;
//   DateTime? createdAt;

//   StripeModel({
//     this.id,
//     this.amount,
//     this.created,
//     this.currency,
//     this.payment_method_types,
//     this.status,
//     this.paymentProcess,
//     this.createdAt,
//   });

//   factory StripeModel.fromJson(Map<String, dynamic> json) {
//     return StripeModel(
//       id: json['id'],
//       amount: (json['amount'] ?? 0) / 100,
//       created: json['created'],
//       currency: json['currency'],
//       payment_method_types: json['payment_method_types']?.first,
//       status: json['status'],
//       paymentProcess: false,
//       createdAt: DateTime.now(),
//     );
//   }

//   static Map<String, dynamic> stripeModelToMap(StripeModel stripeModel) {
//     return {
//       'id': stripeModel.id,
//       'amount': stripeModel.amount,
//       'created': stripeModel.created,
//       'currency': stripeModel.currency,
//       'payment_method_types': stripeModel.payment_method_types,
//       'status': stripeModel.status,
//       'paymentProcess': stripeModel.paymentProcess,
//       'createdAt': stripeModel.createdAt
//     };
//   }
// }

// class StripeModel {
//   String? transactionId;
//   double? amount;
//   // double? created;
//   String? currency;
//   String? payment_method_types;
//   String? orderName;
//   String? quantity;
//   String? status;
//   bool? paymentProcess;
//   DateTime? createdAt;

//   StripeModel({
//     this.transactionId,
//     this.amount,
//     // this.created,
//     this.currency,
//     this.payment_method_types,
//     this.orderName,
//     this.quantity,
//     this.status,
//     this.paymentProcess,
//     this.createdAt,
//   });

//   factory StripeModel.fromJson(Map<String, dynamic> json) {
//     return StripeModel(
//       transactionId: json['transactionId'],
//       amount: (json['amount'] ?? 0) / 100,
//       // created: json['created'],
//       currency: json['currency'],
//       payment_method_types: json['payment_method_types']?.first,
//       orderName: 'Meals',
//       quantity: json['quantity'],
//       status: json['status'],
//       paymentProcess: false,
//       createdAt: DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'transactionId': transactionId,
//       'amount': amount,
//       // 'created': created,
//       'currency': currency,
//       'payment_method_types': payment_method_types,
//       'orderName': orderName,
//       'quantity' : quantity,
//       'status': status,
//       'paymentProcess': paymentProcess,
//       'createdAt': createdAt?.millisecondsSinceEpoch,
//     };
//   }

//   static Map<String, dynamic> stripeModelToMap(StripeModel stripeModel) {
//     return {
//       'transactionId': stripeModel.transactionId,
//       'amount': stripeModel.amount,
//       // 'created': stripeModel.created,
//       'currency': stripeModel.currency,
//       'payment_method_types': stripeModel.payment_method_types,
//       'orderName': stripeModel.orderName,
//       'quantity' : stripeModel.quantity,
//       'status': stripeModel.status,
//       'paymentProcess': stripeModel.paymentProcess,
//       'createdAt': stripeModel.createdAt?.millisecondsSinceEpoch,
//     };
//   }
// }

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
        quantity: json['quantity']
      );
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
      'quantity' : stripeModel.quantity
    };
  }
}
