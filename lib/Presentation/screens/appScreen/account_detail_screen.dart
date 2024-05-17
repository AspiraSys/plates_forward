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
  String errorText = '';

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
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
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
      appBar: const AppBarScreen(
        title: 'Account Details',
        subScreen: true,
        isProfile: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           errorText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 40, right: 40),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color.fromARGB(79, 244, 67, 54)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            errorText = '';
                          }),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.red,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            errorText,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
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
                      disabled: !saveText,
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
                      disabled: !saveText,

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
                      inputType: 'email',
                      disabled: false,
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
                      inputType: 'phone',
                      phone: true,
                      disabled: !saveText,

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

Future<void> _handleSave() async {
    setState(() {
      errorText = '';
    });

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _mobileNumberController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter all the fields';
      });
      return;
    } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
        .hasMatch(_firstNameController.text)) {
      setState(() {
        errorText = 'Invalid First Name';
      });
      return;
    } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
        .hasMatch(_lastNameController.text)) {
      setState(() {
        errorText = 'Invalid Last Name';
      });
      return;
    } else if (_firstNameController.text.length > 8) {
      setState(() {
        errorText = 'First Name should be at least 8 characters ';
      });
      return;
    } else if (_lastNameController.text.length > 8) {
      setState(() {
        errorText = 'Last Name should be at least 8 characters ';
      });
      return;
    } else if (_mobileNumberController.text.length < 10 ||
        _mobileNumberController.text.length > 12) {
      setState(() {
        errorText = 'Mobile number must be between 10 to 12 digits';
      });
      return;
    } 

    // If there are no errors, set submit to true and run updateUserDetails
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

  // Future<void> _handleSave() async {
  //   setState(() {
  //     errorText = '';
  //   });

  //   if (_firstNameController.text.isEmpty ||
  //       _lastNameController.text.isEmpty ||
  //       _mobileNumberController.text.isEmpty
  //     ) {
  //     setState(() {
  //       errorText = 'Please enter all the fields';
  //     });
  //     return;
  //   } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
  //       .hasMatch(_firstNameController.text)) {
  //     setState(() {
  //       errorText = 'Invalid First Name';
  //     });
  //     return;
  //   } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
  //       .hasMatch(_lastNameController.text)) {
  //     setState(() {
  //       errorText = 'Invalid Last Name';
  //     });
  //     return;
  //   } else if (_firstNameController.text.length > 8) {
  //     setState(() {
  //       errorText = 'First Name should be at least 8 characters ';
  //     });
  //     return;
  //   } else if (_lastNameController.text.length > 8) {
  //     setState(() {
  //       errorText = 'Last Name should be at least 8 characters ';
  //     });
  //     return;
  //   } 
  //   else if (_mobileNumberController.text.length == 8 ||
  //       _mobileNumberController.text.length <= 10) {
  //     setState(() {
  //       errorText = 'Mobile number must be between 10 to 12 digits';
  //     });
  //     return;
  //   } else
  //   // ignore: curly_braces_in_flow_control_structures
  //   setState(() {
  //     submit = true;
  //   });
    
  //   // Update user details and set saveText to true
  //   updateUserDetails().then((_) {
  //     Future.delayed(const Duration(seconds: 5), () {
  //       submit = false;
  //       setState(() {
  //         saveText = true;
  //       });
  //     });
  //   });
  // }
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
