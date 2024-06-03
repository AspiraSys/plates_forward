import 'package:plates_forward/square/model/create_payment/amount.dart';

class CreatePaymentRequest {
  final String idempotencyKey;
  final String sourceId;
  final bool acceptPartialAuthorization;
  final AmountMoney amountMoney;

  CreatePaymentRequest(
      {required this.idempotencyKey,
      required this.sourceId,
      required this.acceptPartialAuthorization,
      required this.amountMoney});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idempotency_key'] = idempotencyKey;
    data['source_id'] = sourceId;
    data['accept_partial_authorization'] = acceptPartialAuthorization;
    data['amount_money'] = amountMoney.toJson();
    return data;
  }
}
