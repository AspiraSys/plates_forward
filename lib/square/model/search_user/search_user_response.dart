class SearchUserModel {
  List<Customer> customers;

  SearchUserModel({required this.customers});

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      customers:
          (json['customers'] as List).map((i) => Customer.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customers': customers.map((i) => i.toJson()).toList(),
    };
  }
}

class Customer {
  String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  String givenName;
  String emailAddress;
  String creationSource;
  int version;

  Customer({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.givenName,
    required this.emailAddress,
    required this.creationSource,
    required this.version,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      givenName: json['given_name'],
      emailAddress: json['email_address'],
      creationSource: json['creation_source'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'given_name': givenName,
      'email_address': emailAddress,
      'creation_source': creationSource,
      'version': version,
    };
  }
}
