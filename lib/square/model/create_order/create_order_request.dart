class CreateOrderRequest {
  String? idempotencyKey;
  Order? order;

  CreateOrderRequest({this.idempotencyKey, this.order});

  CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    idempotencyKey = json['idempotency_key'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idempotency_key'] = idempotencyKey;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? locationId;
  String? customerId;

  Order({this.locationId, this.customerId});

  Order.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['customer_id'] = customerId;
    return data;
  }
}