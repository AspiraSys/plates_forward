// class UsersData {
//   UsersData({
//     // required this.img,
//     required this.firstName,
//     required this.lastName,
//     required this.mobileNumber,
//     required this.email,
//     this.profilePictureUrl,
//     // required this.password,
//   });
//   // late String img;
//   late String firstName;
//   late String lastName;
//   late int mobileNumber;
//   late String email;
//   final String? profilePictureUrl;
//   // late String password;

//   UsersData.fromJson(Map<String, dynamic> json) {
//     firstName = json['firstName'] ?? '';
//     lastName = json['lastName'] ?? '';
//     mobileNumber = json['mobileNumber'] ?? '';
//     email = json['email'] ?? '';
//     profilePictureUrl = json['profilePictureUrl'];
//     // password = json['password'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['mobileNumber'] = mobileNumber;
//     data['email'] = email;
//     // _data['id'] = id;
//     // _data['email'] = email;
//     return data;
//   }
// }

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

