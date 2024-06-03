class SearchUserRequest {
  final String emailAddress;
  SearchUserRequest({required this.emailAddress});

  Map<String, dynamic> toJson() {
    return {
      'query': {
        'filter': {
          'email_address': {
            'exact': emailAddress,
          }
        }
      }
    };
  }
}
