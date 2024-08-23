class MasterData {
  MasterData({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    this.squareCustomerId
    // this.profilePicture,
  });

  late String firstName;
  late String lastName;
  late int mobileNumber;
  late String email;
  late String? squareCustomerId;
  // final String? profilePicture;

  MasterData.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        mobileNumber = json['mobileNumber'] ?? 0,
        email = json['email'] ?? '',
        squareCustomerId = json['squareCustomerId'];
  // profilePicture = json['profilePicture'];

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'email': email,
      'squareCustomerId': squareCustomerId,
      // 'profilePicture': profilePicture,
    };
  }
}
