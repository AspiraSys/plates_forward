class CreatePaymentResponse {
  Payment? payment;

  CreatePaymentResponse({this.payment});

  CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    payment =
    json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    return data;
  }
}

class Payment {
  String? id;
  String? createdAt;
  String? updatedAt;
  AmountMoney? amountMoney;
  String? status;
  String? delayDuration;
  String? sourceType;
  CardDetails? cardDetails;
  String? locationId;
  String? orderId;
  RiskEvaluation? riskEvaluation;
  List<ProcessingFee>? processingFee;
  AmountMoney? totalMoney;
  AmountMoney? approvedMoney;
  String? receiptNumber;
  String? receiptUrl;
  String? delayAction;
  String? delayedUntil;
  ApplicationDetails? applicationDetails;
  String? versionToken;

  Payment(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.amountMoney,
        this.status,
        this.delayDuration,
        this.sourceType,
        this.cardDetails,
        this.locationId,
        this.orderId,
        this.riskEvaluation,
        this.processingFee,
        this.totalMoney,
        this.approvedMoney,
        this.receiptNumber,
        this.receiptUrl,
        this.delayAction,
        this.delayedUntil,
        this.applicationDetails,
        this.versionToken});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amountMoney = json['amount_money'] != null
        ? AmountMoney.fromJson(json['amount_money'])
        : null;
    status = json['status'];
    delayDuration = json['delay_duration'];
    sourceType = json['source_type'];
    cardDetails = json['card_details'] != null
        ? CardDetails.fromJson(json['card_details'])
        : null;
    locationId = json['location_id'];
    orderId = json['order_id'];
    riskEvaluation = json['risk_evaluation'] != null
        ? RiskEvaluation.fromJson(json['risk_evaluation'])
        : null;
    if (json['processing_fee'] != null) {
      processingFee = <ProcessingFee>[];
      json['processing_fee'].forEach((v) {
        processingFee!.add(ProcessingFee.fromJson(v));
      });
    }
    totalMoney = json['total_money'] != null
        ? AmountMoney.fromJson(json['total_money'])
        : null;
    approvedMoney = json['approved_money'] != null
        ? AmountMoney.fromJson(json['approved_money'])
        : null;
    receiptNumber = json['receipt_number'];
    receiptUrl = json['receipt_url'];
    delayAction = json['delay_action'];
    delayedUntil = json['delayed_until'];
    applicationDetails = json['application_details'] != null
        ? ApplicationDetails.fromJson(json['application_details'])
        : null;
    versionToken = json['version_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (amountMoney != null) {
      data['amount_money'] = amountMoney!.toJson();
    }
    data['status'] = status;
    data['delay_duration'] = delayDuration;
    data['source_type'] = sourceType;
    if (cardDetails != null) {
      data['card_details'] = cardDetails!.toJson();
    }
    data['location_id'] = locationId;
    data['order_id'] = orderId;
    if (riskEvaluation != null) {
      data['risk_evaluation'] = riskEvaluation!.toJson();
    }
    if (processingFee != null) {
      data['processing_fee'] =
          processingFee!.map((v) => v.toJson()).toList();
    }
    if (totalMoney != null) {
      data['total_money'] = totalMoney!.toJson();
    }
    if (approvedMoney != null) {
      data['approved_money'] = approvedMoney!.toJson();
    }
    data['receipt_number'] = receiptNumber;
    data['receipt_url'] = receiptUrl;
    data['delay_action'] = delayAction;
    data['delayed_until'] = delayedUntil;
    if (applicationDetails != null) {
      data['application_details'] = applicationDetails!.toJson();
    }
    data['version_token'] = versionToken;
    return data;
  }
}

class AmountMoney {
  int? amount;
  String? currency;

  AmountMoney({this.amount, this.currency});

  AmountMoney.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}

class CardDetails {
  String? status;
  Card? card;
  String? entryMethod;
  String? cvvStatus;
  String? avsStatus;
  String? statementDescription;
  CardPaymentTimeline? cardPaymentTimeline;

  CardDetails(
      {this.status,
        this.card,
        this.entryMethod,
        this.cvvStatus,
        this.avsStatus,
        this.statementDescription,
        this.cardPaymentTimeline});

  CardDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    entryMethod = json['entry_method'];
    cvvStatus = json['cvv_status'];
    avsStatus = json['avs_status'];
    statementDescription = json['statement_description'];
    cardPaymentTimeline = json['card_payment_timeline'] != null
        ? CardPaymentTimeline.fromJson(json['card_payment_timeline'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['entry_method'] = entryMethod;
    data['cvv_status'] = cvvStatus;
    data['avs_status'] = avsStatus;
    data['statement_description'] = statementDescription;
    if (cardPaymentTimeline != null) {
      data['card_payment_timeline'] = cardPaymentTimeline!.toJson();
    }
    return data;
  }
}

class Card {
  String? cardBrand;
  String? last4;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? cardType;
  String? prepaidType;
  String? bin;

  Card(
      {this.cardBrand,
        this.last4,
        this.expMonth,
        this.expYear,
        this.fingerprint,
        this.cardType,
        this.prepaidType,
        this.bin});

  Card.fromJson(Map<String, dynamic> json) {
    cardBrand = json['card_brand'];
    last4 = json['last_4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    fingerprint = json['fingerprint'];
    cardType = json['card_type'];
    prepaidType = json['prepaid_type'];
    bin = json['bin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_brand'] = cardBrand;
    data['last_4'] = last4;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['fingerprint'] = fingerprint;
    data['card_type'] = cardType;
    data['prepaid_type'] = prepaidType;
    data['bin'] = bin;
    return data;
  }
}

class CardPaymentTimeline {
  String? authorizedAt;
  String? capturedAt;

  CardPaymentTimeline({this.authorizedAt, this.capturedAt});

  CardPaymentTimeline.fromJson(Map<String, dynamic> json) {
    authorizedAt = json['authorized_at'];
    capturedAt = json['captured_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authorized_at'] = authorizedAt;
    data['captured_at'] = capturedAt;
    return data;
  }
}

class RiskEvaluation {
  String? createdAt;
  String? riskLevel;

  RiskEvaluation({this.createdAt, this.riskLevel});

  RiskEvaluation.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    riskLevel = json['risk_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['risk_level'] = riskLevel;
    return data;
  }
}

class ProcessingFee {
  String? effectiveAt;
  String? type;
  AmountMoney? amountMoney;

  ProcessingFee({this.effectiveAt, this.type, this.amountMoney});

  ProcessingFee.fromJson(Map<String, dynamic> json) {
    effectiveAt = json['effective_at'];
    type = json['type'];
    amountMoney = json['amount_money'] != null
        ? AmountMoney.fromJson(json['amount_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['effective_at'] = effectiveAt;
    data['type'] = type;
    if (amountMoney != null) {
      data['amount_money'] = amountMoney!.toJson();
    }
    return data;
  }
}

class ApplicationDetails {
  String? squareProduct;
  String? applicationId;

  ApplicationDetails({this.squareProduct, this.applicationId});

  ApplicationDetails.fromJson(Map<String, dynamic> json) {
    squareProduct = json['square_product'];
    applicationId = json['application_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['square_product'] = squareProduct;
    data['application_id'] = applicationId;
    return data;
  }
}