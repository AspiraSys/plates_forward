class SearchOrderRequestWithDate {
  final String locationId;
  final String customerId;
  final String startAt;

  SearchOrderRequestWithDate({
    required this.locationId,
    required this.customerId,
    required this.startAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': {
        'filter': {
          'customer_filter': {
            'customer_ids': [customerId],
          },
          'date_time_filter': {
            'created_at': {
              'start_at': startAt,
            }
          }
        }
      },
      'location_ids': [locationId]
    };
  }
}
