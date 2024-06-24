class SearchOrderRequest {
  final String locationId;
  final String customerId;

  SearchOrderRequest({
    required this.locationId,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': {
        'filter': {
          'customer_filter': {
            'customer_ids': [customerId],
          }
        }
      },
      'location_ids': [locationId]
    };
  }
}
