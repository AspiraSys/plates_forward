import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/models/user_activity.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_request.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'dart:io';

import 'package:plates_forward/utils/app_assets.dart';

class TotalOrderDialog extends StatefulWidget {
  final Function(bool) updateOrderState;
  final VoidCallback onSuccess;

  const TotalOrderDialog({
    super.key,
    required this.updateOrderState,
    required this.onSuccess,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddOrderDialogState createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<TotalOrderDialog> {

  String errorText = '';
  int selectedIndex = -1;
  bool enable = false;
  String locationId = '';
  var square = SquareFunction();

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> saveUserTransactionData(RetrieveOrderResponse result) async {
  //   List<ListItem> lineItems = result.order?.lineItems?.map((item) {
  //         return ListItem(
  //           name: item.name ?? '',
  //           uid: item.uid ?? '',
  //           amount: item.basePriceMoney?.amount ?? 0,
  //           quantity: item.quantity ?? '',
  //         );
  //       }).toList() ??
  //       [];

  //   num totalAmount = result.order?.netAmounts?.totalMoney?.amount ?? 0;

  //   UserActivityData userActivityData = UserActivityData(
  //     id: result.order?.id ?? '',
  //     locationId: result.order?.locationId ?? '',
  //     createdAt: result.order?.createdAt ?? '',
  //     totalAmount: totalAmount,
  //     lineItems: lineItems,
  //   );

  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   final FirebaseAuth auth = FirebaseAuth.instance;

  //   final User? user = auth.currentUser;
  //   if (user != null) {
  //     final String userId = user.uid;

  //     await firestore.collection("userTransaction").doc(userId).set({
  //       'userActivityData': FieldValue.arrayUnion([userActivityData.toJson()])
  //     }, SetOptions(merge: true));

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Successfully added to Impact',
  //           style: TextStyle(color: AppColor.whiteColor),
  //         ),
  //         duration: Duration(seconds: 5),
  //       ),
  //     );

  //     Future.delayed(const Duration(seconds: 3), () {
  //       widget.updateOrderState(false);
  //       Navigator.pop(context);
  //     });
  //   } else {
  //     print("User not authenticated");
  //   }
  // }

  Future<void> handleOrder() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      print("User not authenticated");
      return;
    }

    
    // final response = await square.retrieveOrder(
    //     orderId: RetrieveOrderRequest(orderId: orderId));

    // if (_orderController.text.isEmpty) {
    //   setState(() {
    //     errorText = 'Invalid order ID';
    //   });
    //   return;
    // } else if (response is RetrieveOrderResponse) {
    //   if (response.errors != null) {
    //     final errorDetail = response.errors![0].detail;
    //     setState(() {
    //       errorText = errorDetail!;
    //     });
    //     return;
    //   } else {
    //     final String userUid = user.uid;
    //     final CollectionReference userTransactionCollection =
    //         FirebaseFirestore.instance.collection('userTransaction');

    //     DocumentSnapshot<Object?> userTransactionDocumentSnapshot =
    //         await userTransactionCollection.doc(userUid).get();

    //     if (userTransactionDocumentSnapshot.exists) {
    //       Map<String, dynamic> userData =
    //           userTransactionDocumentSnapshot.data() as Map<String, dynamic>;

    //       List<Map<String, dynamic>> userActivityDataList =
    //           (userData['userActivityData'] as List<dynamic>)
    //               .cast<Map<String, dynamic>>()
    //               .toList();
    //       bool orderIdFound = false;
    //       for (var activity in userActivityDataList) {
    //         var idValue = activity['id'];
    //         if (idValue == orderId) {
    //           orderIdFound = true;
    //           break;
    //         }
    //       }
    //       if (orderIdFound) {
    //         setState(() {
    //           errorText = 'OrderId is already exists';
    //         });
    //       } else {
    //         await saveUserTransactionData(response);
    //         _orderController.text = '';
    //         setState(() {
    //           errorText = '';
    //         });
    //         widget.onSuccess();
    //       }
    //     } else {
    //       await saveUserTransactionData(response);
    //       _orderController.text = '';
    //       setState(() {
    //         errorText = '';
    //       });
    //       widget.onSuccess();
    //     }
    //   }
    // }
  }

  void onVenueSelected(DocumentSnapshot selectedDocument) {
    setState(() {
      locationId = selectedDocument['locationId'];
    });
  }

  static CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    debugPrint('the id ${userController.userSquareId.value}');
    print('uuuu $locationId');
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.navBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.only(left: 20),
                  child: Expanded(
                    child: Text(
                      'Select the location to fetch'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      widget.updateOrderState(false);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.blackColor,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.whiteColor,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: fetchStream('venueMaster').snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapShot) {
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
                          List<DocumentSnapshot> activeVenues = snapShot
                              .data!.docs
                              .where((doc) => doc['isActive'] == 1)
                              .toList();
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, left: 10),
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
                                              onVenueSelected(
                                                  activeVenues[index]);
                                              setState(() {
                                                selectedIndex = index;
                                                enable = true;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Container(
                                                width: 72,
                                                height: 72,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: AppColor
                                                          .primaryColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                  color: selectedIndex ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : AppColor.whiteColor,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ColorFiltered(
                                                      colorFilter: ColorFilter.mode(
                                                          selectedIndex ==
                                                                  index
                                                              ? AppColor
                                                                  .whiteColor
                                                              : AppColor
                                                                  .primaryColor,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: selectedIndex ==
                                                                  index
                                                              ? AppColor
                                                                  .whiteColor
                                                              : AppColor
                                                                  .primaryColor),
                                                      textAlign:
                                                          TextAlign.center,
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
                ),
              ],
            ),
            if (errorText.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.redColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            ButtonBox(
              buttonText: 'Total Order',
              fillColor: true,
              onPressed: handleOrder,
            ),
          ],
        ),
      ),
    );
  }
}
