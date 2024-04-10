// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/users_data.dart';

// class UserApi {
//   static FirebaseAuth auth = FirebaseAuth.instance;

//   // Firebase Cloud
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // Current user auth
//   static User get user => auth.currentUser!;

//   static UsersData me = UsersData(
//     firstName: user.firstName.toString(),
//     lastName: user.lastName.toString(),
//     mobileNumber: int.parse(user.mobileNumber),
//     email: user.email.toString(),
//   );

//   static Future<void> createUser() async {
//     // ignore: non_constant_identifier_names
//     final usersData = UsersData(
//       firstName: user.firstName.toString(),
//       lastName : user.lastName.toString(),
//       mobileNumber: int.parse(user.mobileNumber),
//       email: user.email.toString()

    
//     );

//     return await firestore
//         .collection('users')
//         .doc(user.uid)
//         .set(usersData.toJson());
//   }
// }
