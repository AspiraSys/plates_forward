class CreateUserRequest {
 final String emailAddress;
  final String givenName;
  CreateUserRequest({required this.emailAddress, required this.givenName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   data['email_address'] = emailAddress;
    data['given_name'] = givenName;
    return data;
  }
}
