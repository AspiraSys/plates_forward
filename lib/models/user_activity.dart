class UserActivityData {
  UserActivityData({
    required this.id,
    required this.locationId,
    required this.createdAt,
    required this.totalAmount,
    required this.lineItems,
    required this.type,
    this.method = '',
  });

  late String id;
  late String locationId;
  late String createdAt;
  late num totalAmount;
  late List<ListItem> lineItems;
  late num type;
  late String method;

  UserActivityData.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        locationId = json['locationId'] ?? '',
        createdAt = json['createdAt'] ?? '',
        method = json['method'] ?? '',
        totalAmount = json['totalAmount'] ?? 0,
        type = json['type'] ?? 0,
        lineItems = (json['lineItems'] as List)
            .map((item) => ListItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'createdAt': createdAt,
      'totalAmount': totalAmount,
      'type': type,
      'method': method,
      'lineItems': lineItems.map((item) => item.toJson()).toList(),
    };
  }
}

class ListItem {
  ListItem({
    required this.name,
    required this.uid,
    required this.amount,
    required this.quantity,
  });

  late String name;
  late String uid;
  late num amount;
  late String quantity;

  ListItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        uid = json['uid'] ?? '',
        amount = json['amount'] ?? 0,
        quantity = json['quantity'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'amount': amount,
      'quantity': quantity,
    };
  }
}
