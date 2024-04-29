import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
// import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/models/stripe_model.dart';
import 'package:plates_forward/models/user_activity.dart';
import 'package:plates_forward/stripe/stripe_function.dart';
import 'package:plates_forward/stripe/stripe_response_model.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  int numberOfMeals = 1;
  int totalCost = 10;
  int selectedIndex = -1;
  bool enable = false;
  String locationId = '';
  var stripe = StripePayment();

  void incrementMeals() {
    setState(() {
      numberOfMeals++;
      totalCost = 10 * numberOfMeals;
    });
  }

  void decrementMeals() {
    if (numberOfMeals > 1) {
      setState(() {
        numberOfMeals--;
        totalCost = 10 * numberOfMeals;
      });
    }
  }

  static CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarScreen(title: 'Donate'),
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 25, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Number of meals',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: numberOfMeals > 1 ? decrementMeals : null,
                            child: Icon(Icons.indeterminate_check_box_sharp,
                                color: numberOfMeals > 1
                                    ? AppColor.primaryColor
                                    : const Color.fromARGB(168, 2, 60, 167),
                                size: 30),
                          ),
                          const SizedBox(width: 30),
                          Image.asset(
                            ImageAssets.mealIcon,
                            width: 50,
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              numberOfMeals.toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.primaryColor),
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: incrementMeals,
                            child: const Icon(Icons.add_box,
                                color: AppColor.primaryColor, size: 30),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Total cost',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      RichText(
                          text: TextSpan(
                              text: '\$',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primaryColor,
                              ),
                              children: <TextSpan>[
                            TextSpan(
                                text: totalCost.toString(),
                                style: const TextStyle(
                                    color: AppColor.primaryColor)),
                            const TextSpan(
                                text: '.00',
                                style: TextStyle(color: AppColor.primaryColor))
                          ])),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 25),
              child: Text(
                'Donate to',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            StreamBuilder(
                stream: fetchStream('venueMaster').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                  if (!snapShot.hasData) {
                    return Center(
                      child: Container(
                        width: 100,
                        color: AppColor.whiteColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<DocumentSnapshot> activeVenues = snapShot.data!.docs
                        .where((doc) => doc['isActive'] == 1)
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 25),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Row(
                                children: [
                                  for (int index = 0;
                                      index < activeVenues.length;
                                      index++)
                                    GestureDetector(
                                      onTap: () {
                                        onVenueSelected(activeVenues[index]);
                                        setState(() {
                                          selectedIndex = index;
                                          enable = true;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Container(
                                          width: 72,
                                          height: 72,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.primaryColor),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                            color: selectedIndex == index
                                                ? AppColor.primaryColor
                                                : AppColor.whiteColor,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                    selectedIndex == index
                                                        ? AppColor.whiteColor
                                                        : AppColor.primaryColor,
                                                    BlendMode.srcIn),
                                                child: Image.network(
                                                  activeVenues[index]
                                                      ['venueImage'],
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              Text(
                                                activeVenues[index]
                                                    ['venueName'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedIndex ==
                                                            index
                                                        ? AppColor.whiteColor
                                                        : AppColor
                                                            .primaryColor),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
            // const Padding(
            //   padding: EdgeInsets.only(top: 10, left: 25, bottom: 10),
            //   child: Text(
            //     'Billing Address',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            //   ),
            // ),
            // Expanded(
            //   child: Center(
            //     child: SingleChildScrollView(
            //       child: Container(
            //         width: MediaQuery.of(context).size.width * 0.8,
            //         padding: const EdgeInsets.symmetric(vertical: 10),
            //         child: Column(
            //           children: [
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "Address 1",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter your first address',
            //                 inputType: 'text',
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "Address 2",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter your second address',
            //                 inputType: 'text',
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "City",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter your city',
            //                 inputType: 'text',
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "State",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter state name',
            //                 inputType: 'text',
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "Country",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter country name',
            //                 inputType: 'text',
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               margin: const EdgeInsets.only(top: 15),
            //               padding: const EdgeInsets.only(left: 15),
            //               child: const Text(
            //                 "Postal Code",
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               alignment: Alignment.centerLeft,
            //               child: InputBox(
            //                 // inputController: _firstNameController,
            //                 labelText: 'Enter postal code',
            //                 inputType: 'number',
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                child: IgnorePointer(
                  ignoring: !enable,
                  child: InkWell(
                    onTap: () async {
                      StripeResponseModel result =
                          await stripe.stripeMakePayment(
                              amount: (totalCost * 100).toString(),
                              currency: "USD");
                      if (result.isSuccess) {
                        firebaseDataTrans(result.response);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.green));
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context)
                              .pushNamed(RoutePaths.donateSuccessRoute);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(result.message),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                      /*Navigator.of(context)
                          .pushNamed(RoutePaths.donateSuccessRoute)*/
                    },
                    child: Container(
                      width: 176,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: enable
                            ? AppColor.primaryColor
                            : const Color.fromARGB(168, 2, 60, 167),
                      ),
                      child: Text(
                        'Donate'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ]),
      bottomNavigationBar: const BottomNavBar(
        activeIcon: 2,
      ),
    );
  }

  Future<void> firebaseDataTrans(StripeModel stripeModel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final String userId = user.uid;
      try {
        await StripeRepository()
            .updateModel(stripeModel, userId, locationId, numberOfMeals);
        if (stripeModel.transactionId != null) {
          await updateUserTransaction(stripeModel.transactionId!);
        } else {
          debugPrint('Transaction ID is null');
        }
      } catch (e) {
        debugPrint('Error updating Firebase Firestore: $e');
      }
    } else {
      debugPrint('User not logged in');
    }
  }

  void onVenueSelected(DocumentSnapshot selectedDocument) {
    setState(() {
      locationId = selectedDocument['locationId'];
    });
  }

  Future<void> updateUserTransaction(String transactionId) async {
    try {
      DocumentSnapshot<Object?> stripeTransactionDoc = await FirebaseFirestore
          .instance
          .collection('stripeTransaction')
          .doc(transactionId)
          .get();

      String generateRandomUid() {
        const String chars =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        Random rnd = Random();
        String uid = '';
        for (int i = 0; i < 10; i++) {
          uid += chars[rnd.nextInt(chars.length)];
        }
        return uid;
      }

      if (stripeTransactionDoc.exists) {
        Map<String, dynamic> stripeData =
            stripeTransactionDoc.data() as Map<String, dynamic>;
        List<ListItem> lineItems = {
          ListItem(
            name: 'Meals',
            uid: generateRandomUid(),
            amount: (stripeData['totalAmount'] / int.parse(stripeData['quantity'])) ?? 0,
            quantity: stripeData['quantity'] ?? '',
          )
        }.toList();

        UserActivityData userTransactionData = UserActivityData(
          id: stripeData['transactionId'] ?? '',
          locationId: stripeData['locationId'] ?? '',
          createdAt: stripeData['createdAt'] ?? '',
          totalAmount: stripeData['totalAmount'] ?? 0,
          lineItems: lineItems,
        );
        // UserActivityData userTransactionData = UserActivityData{

        // id: stripeData['transactionId'],
        // 'locationId': stripeData['locationId'],
        // 'createdAt': stripeData['createdAt'],
        // 'totalAmount': stripeData['totalAmount'],
        // 'lineItems': lineItems
        // };

        final FirebaseAuth auth = FirebaseAuth.instance;

        final User? user = auth.currentUser;

        if (user != null) {
          final String userId = user.uid;
          await FirebaseFirestore.instance
              .collection("userTransaction")
              .doc(userId)
              .set({
            'userActivityData':
                FieldValue.arrayUnion([userTransactionData.toJson()])
          }, SetOptions(merge: true));
        } else {
          print("user is not authenticate");
        }
        // await FirebaseFirestore.instance
        //     .collection('userTransaction')
        //     .doc(transactionId)
        //     .set(userTransactionData);
      } else {
        print('Stripe transaction document does not exist');
      }
    } catch (e) {
      print('Error updating userTransaction: $e');
    }
  }
}

class StripeRepository {
  Future<void> updateModel(StripeModel updatedModel, String userId,
      String locationId, int numberOfMeals) async {
    Map<String, dynamic> modelMap = updatedModel.toJson();
    modelMap['userId'] = userId;
    modelMap['locationId'] = locationId;
    modelMap['quantity'] = numberOfMeals.toString();
    await FirebaseFirestore.instance
        .collection('stripeTransaction')
        .doc(updatedModel.transactionId)
        .set(modelMap);
  }
}
