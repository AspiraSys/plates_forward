class CustomerResponse {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String givenName;
  final String emailAddress;

  CustomerResponse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.givenName,
    required this.emailAddress,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      id: json['customer']['id'],
      createdAt: DateTime.parse(json['customer']['created_at']),
      updatedAt: DateTime.parse(json['customer']['updated_at']),
      givenName: json['customer']['given_name'],
      emailAddress: json['customer']['email_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'given_name': givenName,
      'email_address': emailAddress,
    };
  }
}
