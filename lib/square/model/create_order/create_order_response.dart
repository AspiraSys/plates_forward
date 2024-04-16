class CreateOrderResponse {
  Order? order;

  CreateOrderResponse({this.order});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? id;
  String? locationId;
  String? createdAt;
  String? updatedAt;
  String? state;
  int? version;
  TotalTaxMoney? totalTaxMoney;
  TotalTaxMoney? totalDiscountMoney;
  TotalTaxMoney? totalTipMoney;
  TotalTaxMoney? totalMoney;
  TotalTaxMoney? totalServiceChargeMoney;
  NetAmounts? netAmounts;
  Source? source;
  String? customerId;
  TotalTaxMoney? netAmountDueMoney;

  Order(
      {this.id,
        this.locationId,
        this.createdAt,
        this.updatedAt,
        this.state,
        this.version,
        this.totalTaxMoney,
        this.totalDiscountMoney,
        this.totalTipMoney,
        this.totalMoney,
        this.totalServiceChargeMoney,
        this.netAmounts,
        this.source,
        this.customerId,
        this.netAmountDueMoney});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationId = json['location_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state = json['state'];
    version = json['version'];
    totalTaxMoney = json['total_tax_money'] != null
        ? TotalTaxMoney.fromJson(json['total_tax_money'])
        : null;
    totalDiscountMoney = json['total_discount_money'] != null
        ? TotalTaxMoney.fromJson(json['total_discount_money'])
        : null;
    totalTipMoney = json['total_tip_money'] != null
        ? TotalTaxMoney.fromJson(json['total_tip_money'])
        : null;
    totalMoney = json['total_money'] != null
        ? TotalTaxMoney.fromJson(json['total_money'])
        : null;
    totalServiceChargeMoney = json['total_service_charge_money'] != null
        ? TotalTaxMoney.fromJson(json['total_service_charge_money'])
        : null;
    netAmounts = json['net_amounts'] != null
        ? NetAmounts.fromJson(json['net_amounts'])
        : null;
    source =
    json['source'] != null ? Source.fromJson(json['source']) : null;
    customerId = json['customer_id'];
    netAmountDueMoney = json['net_amount_due_money'] != null
        ? TotalTaxMoney.fromJson(json['net_amount_due_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['state'] = state;
    data['version'] = version;
    if (totalTaxMoney != null) {
      data['total_tax_money'] = totalTaxMoney!.toJson();
    }
    if (totalDiscountMoney != null) {
      data['total_discount_money'] = totalDiscountMoney!.toJson();
    }
    if (totalTipMoney != null) {
      data['total_tip_money'] = totalTipMoney!.toJson();
    }
    if (totalMoney != null) {
      data['total_money'] = totalMoney!.toJson();
    }
    if (totalServiceChargeMoney != null) {
      data['total_service_charge_money'] =
          totalServiceChargeMoney!.toJson();
    }
    if (netAmounts != null) {
      data['net_amounts'] = netAmounts!.toJson();
    }
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['customer_id'] = customerId;
    if (netAmountDueMoney != null) {
      data['net_amount_due_money'] = netAmountDueMoney!.toJson();
    }
    return data;
  }
}

class TotalTaxMoney {
  int? amount;
  String? currency;

  TotalTaxMoney({this.amount, this.currency});

  TotalTaxMoney.fromJson(Map<String, dynamic> json) {
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

class NetAmounts {
  TotalTaxMoney? totalMoney;
  TotalTaxMoney? taxMoney;
  TotalTaxMoney? discountMoney;
  TotalTaxMoney? tipMoney;
  TotalTaxMoney? serviceChargeMoney;

  NetAmounts(
      {this.totalMoney,
        this.taxMoney,
        this.discountMoney,
        this.tipMoney,
        this.serviceChargeMoney});

  NetAmounts.fromJson(Map<String, dynamic> json) {
    totalMoney = json['total_money'] != null
        ? TotalTaxMoney.fromJson(json['total_money'])
        : null;
    taxMoney = json['tax_money'] != null
        ? TotalTaxMoney.fromJson(json['tax_money'])
        : null;
    discountMoney = json['discount_money'] != null
        ? TotalTaxMoney.fromJson(json['discount_money'])
        : null;
    tipMoney = json['tip_money'] != null
        ? TotalTaxMoney.fromJson(json['tip_money'])
        : null;
    serviceChargeMoney = json['service_charge_money'] != null
        ? TotalTaxMoney.fromJson(json['service_charge_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totalMoney != null) {
      data['total_money'] = totalMoney!.toJson();
    }
    if (taxMoney != null) {
      data['tax_money'] = taxMoney!.toJson();
    }
    if (discountMoney != null) {
      data['discount_money'] = discountMoney!.toJson();
    }
    if (tipMoney != null) {
      data['tip_money'] = tipMoney!.toJson();
    }
    if (serviceChargeMoney != null) {
      data['service_charge_money'] = serviceChargeMoney!.toJson();
    }
    return data;
  }
}

class Source {
  String? name;

  Source({this.name});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}