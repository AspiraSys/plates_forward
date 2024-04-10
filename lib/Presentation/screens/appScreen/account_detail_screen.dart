import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/utils/app_colors.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  AccountDetailScreenState createState() => AccountDetailScreenState();
}

class AccountDetailScreenState extends State<AccountDetailScreen> {
  late final TextEditingController _firstNameController =
      TextEditingController();
  late final TextEditingController _lastNameController =
      TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _mobileNumberController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  bool saveText = false;
  bool submit = false;

  @override
  void initState() {
    super.initState();

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      FirebaseFirestore.instance
          .collection('userSignup')
          .doc(userId)
          .get()
          .then((snapshot) {
        setState(() {
          _firstNameController.text = snapshot['firstName'] ?? '';
          _lastNameController.text = snapshot['lastName'] ?? '';
          _emailController.text = snapshot['email'] ?? '';
          _mobileNumberController.text =
              snapshot['mobileNumber']?.toString() ?? '';
        });
      });
    }
  }

  Future<void> fetchUserDetails() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      setState(() {
        _firstNameController.text = userDetails['firstName'];
        _lastNameController.text = userDetails['lastName'];
        _emailController.text = userDetails['email'];
        _mobileNumberController.text = userDetails['mobileNumber'].toString();
        _passwordController.text = userDetails['password'];
      });
    }
  }

  Future<void> updateUserDetails() async {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('userId of respective user $userId');
    if (userId != null) {
      // Update user details in Firestore
      int mobileNumber = int.parse(_mobileNumberController.text.trim());

      await FirebaseFirestore.instance
          .collection('userSignup')
          .doc(userId)
          .update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobileNumber': mobileNumber,
        // 'password': _passwordController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(
        title: 'Account Details',
        subScreen: true,
        isProfile: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "First Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: InputBox(
                      inputController: _firstNameController,
                      labelText: 'Enter your first name',
                      inputType: 'text',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Last Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: InputBox(
                      inputController: _lastNameController,
                      labelText: 'Enter your last name',
                      inputType: 'text',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: InputBox(
                      inputController: _emailController,
                      labelText: 'Enter your email here',
                      inputType: 'text',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Mobile Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: InputBox(
                      inputController: _mobileNumberController,
                      labelText: 'Enter your mobile name',
                      inputType: 'text',
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   margin: const EdgeInsets.only(top: 25),
                  //   padding: const EdgeInsets.only(left: 15),
                  //   child: const Text(
                  //     "Password",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: InputBox(
                  //     inputController: _passwordController,
                  //     labelText: 'Enter your password here',
                  //     inputType: 'password',
                  //     accountDetail: true,
                  //   ),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 10),
                  //   child: Text(
                  //     'Use 8 or more characters with a mix of letters, numbers and symbols.',
                  //     style:
                  //         TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          saveText
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_outlined,
                        size: 24,
                        color: AppColor.primaryColor,
                      ),
                      Text(" Your Changes have been saved",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.primaryColor),
                          textAlign: TextAlign.center)
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: ButtonBox(
                    buttonText: 'Save',
                    fillColor: true,
                    onPressed: _handleSave,
                    isLoading: submit,
                  )),
          const SizedBox(
            height: 16,
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBar(isProfile: true),
    );
  }

  void _handleSave() {
    setState(() {
      submit = true;
    });

    // Update user details and set saveText to true
    updateUserDetails().then((_) {
      Future.delayed(const Duration(seconds: 5), () {
        submit = false;
        setState(() {
          saveText = true;
        });
      });
    });
  }
  // void _handleSave() {
  //   setState(() {
  //     submit = true;
  //   });

  //   Future.delayed(const Duration(seconds: 5), () {
  //     submit = false;
  //     setState(() {
  //       saveText = true;
  //     });
  //   });
  // }
}
