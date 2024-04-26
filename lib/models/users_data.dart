class UsersData {
  UsersData({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    this.profilePicture,
  });

  late String firstName;
  late String lastName;
  late int mobileNumber;
  late String email;
  final String? profilePicture;

  UsersData.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        mobileNumber = json['mobileNumber'] ?? 0,
        email = json['email'] ?? '',
        profilePicture = json['profilePicture'];

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
