class RetrieveOrderResponse {
  Order? order;
  RetrieveOrderResponse({this.order});

  RetrieveOrderResponse.fromJson(Map<String, dynamic> json) {
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
  List<LineItems>? lineItems;
  String? createdAt;
  String? updatedAt;
  String? state;
  int? version;
  BasePriceMoney? totalTaxMoney;
  BasePriceMoney? totalDiscountMoney;
  BasePriceMoney? totalTipMoney;
  BasePriceMoney? totalMoney;
  BasePriceMoney? totalServiceChargeMoney;
  NetAmounts? netAmounts;
  Source? source;
  String? customerId;
  BasePriceMoney? netAmountDueMoney;

  Order(
      {this.id,
        this.locationId,
        this.lineItems,
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
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state = json['state'];
    version = json['version'];
    totalTaxMoney = json['total_tax_money'] != null
        ? BasePriceMoney.fromJson(json['total_tax_money'])
        : null;
    totalDiscountMoney = json['total_discount_money'] != null
        ? BasePriceMoney.fromJson(json['total_discount_money'])
        : null;
    totalTipMoney = json['total_tip_money'] != null
        ? BasePriceMoney.fromJson(json['total_tip_money'])
        : null;
    totalMoney = json['total_money'] != null
        ? BasePriceMoney.fromJson(json['total_money'])
        : null;
    totalServiceChargeMoney = json['total_service_charge_money'] != null
        ? BasePriceMoney.fromJson(json['total_service_charge_money'])
        : null;
    netAmounts = json['net_amounts'] != null
        ? NetAmounts.fromJson(json['net_amounts'])
        : null;
    source =
    json['source'] != null ? Source.fromJson(json['source']) : null;
    customerId = json['customer_id'];
    netAmountDueMoney = json['net_amount_due_money'] != null
        ? BasePriceMoney.fromJson(json['net_amount_due_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location_id'] = locationId;
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
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

class LineItems {
  String? uid;
  String? quantity;
  String? name;
  BasePriceMoney? basePriceMoney;
  BasePriceMoney? grossSalesMoney;
  BasePriceMoney? totalTaxMoney;
  BasePriceMoney? totalDiscountMoney;
  BasePriceMoney? totalMoney;
  BasePriceMoney? variationTotalPriceMoney;
  String? itemType;
  BasePriceMoney? totalServiceChargeMoney;

  LineItems(
      {this.uid,
        this.quantity,
        this.name,
        this.basePriceMoney,
        this.grossSalesMoney,
        this.totalTaxMoney,
        this.totalDiscountMoney,
        this.totalMoney,
        this.variationTotalPriceMoney,
        this.itemType,
        this.totalServiceChargeMoney});

  LineItems.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    quantity = json['quantity'];
    name = json['name'];
    basePriceMoney = json['base_price_money'] != null
        ? BasePriceMoney.fromJson(json['base_price_money'])
        : null;
    grossSalesMoney = json['gross_sales_money'] != null
        ? BasePriceMoney.fromJson(json['gross_sales_money'])
        : null;
    totalTaxMoney = json['total_tax_money'] != null
        ? BasePriceMoney.fromJson(json['total_tax_money'])
        : null;
    totalDiscountMoney = json['total_discount_money'] != null
        ? BasePriceMoney.fromJson(json['total_discount_money'])
        : null;
    totalMoney = json['total_money'] != null
        ? BasePriceMoney.fromJson(json['total_money'])
        : null;
    variationTotalPriceMoney = json['variation_total_price_money'] != null
        ? BasePriceMoney.fromJson(json['variation_total_price_money'])
        : null;
    itemType = json['item_type'];
    totalServiceChargeMoney = json['total_service_charge_money'] != null
        ? BasePriceMoney.fromJson(json['total_service_charge_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['quantity'] = quantity;
    data['name'] = name;
    if (basePriceMoney != null) {
      data['base_price_money'] = basePriceMoney!.toJson();
    }
    if (grossSalesMoney != null) {
      data['gross_sales_money'] = grossSalesMoney!.toJson();
    }
    if (totalTaxMoney != null) {
      data['total_tax_money'] = totalTaxMoney!.toJson();
    }
    if (totalDiscountMoney != null) {
      data['total_discount_money'] = totalDiscountMoney!.toJson();
    }
    if (totalMoney != null) {
      data['total_money'] = totalMoney!.toJson();
    }
    if (variationTotalPriceMoney != null) {
      data['variation_total_price_money'] =
          variationTotalPriceMoney!.toJson();
    }
    data['item_type'] = itemType;
    if (totalServiceChargeMoney != null) {
      data['total_service_charge_money'] =
          totalServiceChargeMoney!.toJson();
    }
    return data;
  }
}

class BasePriceMoney {
  int? amount;
  String? currency;

  BasePriceMoney({this.amount, this.currency});

  BasePriceMoney.fromJson(Map<String, dynamic> json) {
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
  BasePriceMoney? totalMoney;
  BasePriceMoney? taxMoney;
  BasePriceMoney? discountMoney;
  BasePriceMoney? tipMoney;
  BasePriceMoney? serviceChargeMoney;

  NetAmounts(
      {this.totalMoney,
        this.taxMoney,
        this.discountMoney,
        this.tipMoney,
        this.serviceChargeMoney});

  NetAmounts.fromJson(Map<String, dynamic> json) {
    totalMoney = json['total_money'] != null
        ? BasePriceMoney.fromJson(json['total_money'])
        : null;
    taxMoney = json['tax_money'] != null
        ? BasePriceMoney.fromJson(json['tax_money'])
        : null;
    discountMoney = json['discount_money'] != null
        ? BasePriceMoney.fromJson(json['discount_money'])
        : null;
    tipMoney = json['tip_money'] != null
        ? BasePriceMoney.fromJson(json['tip_money'])
        : null;
    serviceChargeMoney = json['service_charge_money'] != null
        ? BasePriceMoney.fromJson(json['service_charge_money'])
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