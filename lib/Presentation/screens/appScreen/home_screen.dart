import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_expanded_box.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
// import 'package:plates_forward/http_base/exception.dart';
import 'package:plates_forward/models/user_activity.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_request.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool orderState = false;
  final TextEditingController orderController = TextEditingController();

  String errorText = '';
  var square = SquareFunction();
  List<Map<String, dynamic>> venueMasterData = [];
  List<Map<String, dynamic>> userTransactionData = [];

  Future<List<Object?>> fetchVenueMasterData(
      String locationId) async {
    final CollectionReference venueMasterCollection =
        FirebaseFirestore.instance.collection('venueMaster');

    QuerySnapshot<Object?> querySnapshot =
        await venueMasterCollection
            .where('locationId', isEqualTo: locationId)
            .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

Future<void> checkAndPrintMatchingData() async {
    final CollectionReference userTransactionCollection =
        FirebaseFirestore.instance.collection('userTransaction');

    QuerySnapshot<Object?> userTransactionQuerySnapshot =
        await userTransactionCollection.get();

    List<Map<String, dynamic>> userData = userTransactionQuerySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    print('Fetched userTransactionData:');
    print(userData);

    if (userData.isNotEmpty) {
      List<String?> locationIds = userData
          .map((data) => (data['userActivityData'] as List<dynamic>)
              .map((activity) => activity['locationId'] as String?)
              .toList())
          .expand((i) => i)
          .toList();

      for (String? locationId in locationIds) {
        if (locationId != null) {
         final venueData =
              await fetchVenueMasterData(locationId);

          print('Matching venueMaster Data for locationId: $locationId');
          print(venueData);

          venueMasterData.addAll(venueData as Iterable<Map<String, dynamic>>);
          

          setState(() {}); // Update the UI with the fetched data
        } else {
          print('locationId is null');
        }
       
      }
    } else {
      print('userData is empty');
    }

     userTransactionData.addAll(userData as Iterable<Map<String, dynamic>>);

    // print('Matching userTransaction Data for locationId: $locationId');
    // print(userTransactionData);
  }
  // Future<void> checkAndPrintMatchingData() async {
  //   final CollectionReference userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');

  //   QuerySnapshot<Object?> userTransactionQuerySnapshot =
  //       await userTransactionCollection.get();

  //   List<Map<String, dynamic>> userData = userTransactionQuerySnapshot.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();

  //   print('Fetched userTransactionData:');
  //   // print(userData);

  //   if (userData.isNotEmpty) {
  //     List<String?> locationIds = userData
  //         .map((data) => (data['userActivityData'] as List<dynamic>)
  //             .map((activity) => activity['locationId'] as String?)
  //             .toList())
  //         .expand((i) => i)
  //         .toList();

  //     for (String? locationId in locationIds) {
  //       if (locationId != null) {
  //         List<Object?> venueData =
  //             await fetchVenueMasterData(locationId);

  //         print('Matching venueMaster Data for locationId: $locationId');
  //         // print(venueData);

  //         venueMasterData .addAll(venueData as Iterable<Map<String, dynamic>>);
  //         userTransactionData = userData;

  //         print('Matching userTransaction Data for locationId: $locationId');
  //         // print(userTransactionData);

  //         setState(() {}); // Update the UI with the fetched data
  //       } else {
  //         print('locationId is null');
  //       }
  //     }
  //   } else {
  //     print('userData is empty');
  //   }
  // }


  // Future<List<Object?>> fetchVenueMasterData(String locationId) async {
  //   final CollectionReference venueMasterCollection =
  //       FirebaseFirestore.instance.collection('venueMaster');

  //   QuerySnapshot<Object?> querySnapshot = await venueMasterCollection
  //       .where('locationId', isEqualTo: locationId)
  //       .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // Future<void> checkAndPrintMatchingData() async {
  //   final CollectionReference userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');

  //   QuerySnapshot<Object?> userTransactionQuerySnapshot =
  //       await userTransactionCollection.get();

  //   List<Map<String, dynamic>> userData = userTransactionQuerySnapshot.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();

  //   print('Fetched userTransactionData:');
  //   print(userData);

  //   if (userData.isNotEmpty) {
  //     dynamic locationId = userData.first['locationId'];

  //     if (locationId != null) {
  //       venueMasterData = await fetchVenueMasterData(locationId);
  //       userTransactionData = userData;

  //       setState(() {}); // Update the UI with the fetched data
  //     } else {
  //       print('locationId is null');
  //     }
  //   } else {
  //     print('userData is empty');
  //   }
  // }

  // Future<void> checkAndPrintMatchingData() async {
  //   final CollectionReference userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');

  //   QuerySnapshot<Object?> userTransactionQuerySnapshot =
  //       await userTransactionCollection.get();

  //   List<Map<String, dynamic>> userData = userTransactionQuerySnapshot.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();

  //   print('Fetched userTransactionData:');
  //   print(userData);

  //   if (userData.isNotEmpty) {
  //     List locationIds =
  //         userData.map((data) => data['locationId']).toList();

  //     for (String locationId in locationIds) {
  //       if (locationId != null) {
  //         venueMasterData = await fetchVenueMasterData(locationId);
  //         userTransactionData = userData;
  //         // List<Object?> venueData = await fetchVenueMasterData(locationId);

  //         print('Matching venueMaster Data for locationId: $locationId');
  //         print(venueMasterData);

  //         userTransactionData = userData;

  //         setState(() {}); // Update the UI with the fetched data
  //       } else {
  //         print('locationId is null');
  //       }
  //     }
  //   } else {
  //     print('userData is empty');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    checkAndPrintMatchingData();
    // fetchVenueMasterData();
    // listenToData(); // Call the function here
  }

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
  }

  static CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  // Future<List<Object?>> fetchVenueMasterData(
  //     String locationId) async {
  //   final CollectionReference venueMasterCollection =
  //       FirebaseFirestore.instance.collection('venueMaster');

  //   QuerySnapshot<Object?> querySnapshot =
  //       await venueMasterCollection
  //           .where('locationId', isEqualTo: locationId)
  //           .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // Future<Object> fetchMatchData() async {
  //   final CollectionReference userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');

  //    QuerySnapshot<Map<String, dynamic>> userTransactionQuerySnapshot =
  //       await userTransactionCollection.get();

  //   List<Map<String, dynamic>> userTransactionData =
  //       querySnapshot.docs.map((doc) => doc.data()).toList();

  //   if (userTransactionData.isNotEmpty) {
  //     String locationId = userTransactionData.first['locationId'];
  //     List<Object?> venueMasterData =
  //         await fetchVenueMasterData(locationId);
  //     // return fetchVenueMasterData(locationId);
  //     print('Matching venueMaster Data:');
  //     print(venueMasterData);

  //     print('Matching userTransaction Data:');
  //     print(userTransactionData);
  //   }
  //   // return [];
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> countryImpactApi = [
      {
        "id": "1",
        "country": "Australia",
        "count": "75,199",
        "t_count": "36",
        "flag": ImageAssets.australiaFlag
      },
      {
        "id": "2",
        "country": "Ukraine",
        "count": "75,199",
        "t_count": "48",
        "flag": ImageAssets.ukraineFlag
      },
      {
        "id": "3",
        "country": "Afghnistan",
        "count": "75,199",
        "t_count": "44",
        "flag": ImageAssets.afghanistanFlag
      },
      {
        "id": "4",
        "country": "Sri Lanka",
        "count": "75,199",
        "t_count": "44",
        "flag": ImageAssets.sriLankaFlag
      },
    ];

    List<Map<String, dynamic>> totalDonationApi = [
      {
        "id": 1,
        "image": ImageAssets.kyivIcon,
        "country": [
          {"id": 1, "city": "Kyviv", "image": ImageAssets.kyivIcon},
          // {"id": 2, "city": "Sydney", "image": ImageAssets.sydneyIcon},
        ],
        "order": [
          {"id": 1, "item": "Saumon a la Parisienne", "cost": "32.00"},
          {"id": 2, "item": "Croque Monsieur", "cost": "13.00"},
          {"id": 3, "item": "Salade de Truite Fumee", "cost": "16.00"},
          {"id": 4, "item": "Total", "cost": "61.00"},
        ],
        "title": "Kyviv Social",
        "date": "06/12/2023"
      },
      {
        "id": 2,
        "image": ImageAssets.bowlMeal,
        "country": [
          {"id": 1, "city": "Kyviv", "image": ImageAssets.kyivIcon},
          {"id": 2, "city": "Sydney", "image": ImageAssets.sydneyIcon},
        ],
        "order": [
          {"id": 1, "item": "Pizza", "cost": "200.00"},
          {"id": 2, "item": "Burger", "cost": "80.00"},
          {"id": 3, "item": "Total", "cost": "280.00"},
        ],
        "title": "Meal Donation",
        "date": "06/12/2023"
      },
    ];

    Future<void> saveUserTransactionData(RetrieveOrderResponse result) async {
      // print('data of response ${result}');
      List<ListItem> lineItems = result.order?.lineItems?.map((item) {
            return ListItem(
              name: item.name ?? '',
              uid: item.uid ?? '',
              amount: item.basePriceMoney?.amount ?? 0,
              quantity: item.quantity ?? '',
            );
          }).toList() ??
          [];

      num totalAmount = result.order?.netAmounts?.totalMoney?.amount ?? 0;

      UserActivityData userActivityData = UserActivityData(
        id: result.order?.id ?? '',
        locationId: result.order?.locationId ?? '',
        createdAt: result.order?.createdAt ?? '',
        totalAmount: totalAmount,
        lineItems: lineItems,
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User? user = auth.currentUser;
      if (user != null) {
        final String userId = user.uid;

        await firestore.collection("userTransaction").doc(userId).set({
          'userActivityData': FieldValue.arrayUnion([userActivityData.toJson()])
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Successfully added to Impact',
              style: TextStyle(color: Colors.green),
            ),
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        print("Data saved to Firebase");
      } else {
        print("User not authenticated");
      }
    }

    // Future<void> handleOrder() async {
    //   setState(() {
    //     errorText = '';
    //     // orderState = false;
    //   });

    //   if (orderController.text.isEmpty) {
    //     setState(() {
    //       errorText = 'Invalid order number';
    //     });
    //     return;
    //   }

    //   final response = await square.retrieveOrder(
    //       orderId: RetrieveOrderRequest(orderId: orderController.text));

    //   if (response is RetrieveOrderResponse) {
    //     RetrieveOrderResponse result = response as RetrieveOrderResponse;

    //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //     final FirebaseAuth auth = FirebaseAuth.instance;
    //     final User? user = auth.currentUser;

    //     if (user != null) {
    //       final String userId = user.uid;
    //       final DocumentSnapshot<Map<String, dynamic>> existingOrder =
    //           await firestore.collection("userTransaction").doc(userId).get();

    //       if (existingOrder.exists &&
    //           existingOrder.data()?['id'] == result.order?.id) {
    //         setState(() {
    //           errorText = "Sorry, order already in your impact";
    //         });
    //         return;
    //       }
    //     }

    //     await saveUserTransactionData(result);

    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Successfully added to Impact',
    //           style: TextStyle(color: Colors.green),
    //         ),
    //         duration: Duration(seconds: 3),
    //       ),
    //     );

    //     Future.delayed(const Duration(seconds: 3), () {
    //       Navigator.pop(context);
    //     });
    //   } else if (response is Map<String, dynamic> &&
    //       response.containsKey('errors')) {
    //     String detail = response['errors'][0]['detail'];
    //     setState(() {
    //       errorText = detail;
    //     });
    //   }
    // }

    // Future<void> handleOrder() async {
    //   setState(() {
    //     errorText = '';
    //   });

    //   if (orderController.text.isEmpty) {
    //     setState(() {
    //       errorText = 'Invalid order number';
    //     });
    //     return;
    //   } else {
    //     final response = await square.retrieveOrder(
    //         orderId: RetrieveOrderRequest(orderId: orderController.text));

    //     if (response is RetrieveOrderResponse) {
    //       RetrieveOrderResponse result = response as RetrieveOrderResponse;

    //       final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //       final FirebaseAuth auth = FirebaseAuth.instance;
    //       final User? user = auth.currentUser;

    //       if (user != null) {
    //         final String userId = user.uid;
    //         final DocumentSnapshot<Map<String, dynamic>> existingOrder =
    //             await firestore.collection("userTransaction").doc(userId).get();

    //         if (existingOrder.exists &&
    //             existingOrder.data()?['id'] == result.order?.id) {
    //           setState(() {
    //             errorText = "Order Id is already in impact";
    //           });
    //           return;
    //         } else {
    //           await saveUserTransactionData(result);
    //         }
    //       }

    //       // if (response.containsKey('errors')) {}

    //       // ScaffoldMessenger.of(context).showSnackBar(
    //       //   const SnackBar(
    //       //     content: Text(
    //       //       'Successfully added to Impact',
    //       //       style: TextStyle(color: Colors.green),
    //       //     ),
    //       //     duration: Duration(seconds: 3),
    //       //   ),
    //       // );

    //       // Future.delayed(const Duration(seconds: 3), () {
    //       //   Navigator.pop(context);
    //       // });
    //     } else {
    //       print('---> Error accor');
    //     }
    //     // else if (response.containsKey('errors')) {
    //     //   // String detail = response['errors'][0]['detail'];
    //     //   setState(() {
    //     //     errorText = 'Order not found for id ${orderController.text}';
    //     //   });
    //     // } else {
    //     //   setState(() {
    //     //     errorText = 'Order not found for id ${orderController.text}';
    //     //   });
    //     // }
    //   }
    // }

    Future<void> handleOrder() async {
      setState(() {
        errorText = '';
      });

      if (orderController.text.isEmpty) {
        setState(() {
          errorText = 'Invalid order number';
        });
        return;
      }

      try {
        final response = await square.retrieveOrder(
            orderId: RetrieveOrderRequest(orderId: orderController.text));

        if (response is RetrieveOrderResponse) {
          RetrieveOrderResponse result = response as RetrieveOrderResponse;

          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;

          if (user != null) {
            final String userId = user.uid;
            final DocumentSnapshot<Map<String, dynamic>> existingOrder =
                await firestore.collection("userTransaction").doc(userId).get();

            if (existingOrder.exists &&
                existingOrder.data()?['id'] == result.order?.id) {
              setState(() {
                errorText = "Order Id is already in impact";
              });
              return;
            } else {
              await saveUserTransactionData(result);
            }
          }
        } else if (response is Map<String, dynamic> &&
            response.containsKey('errors')) {
          String detail = response['errors'][0]['detail'];
          setState(() {
            errorText = detail;
          });
        } else {
          setState(() {
            errorText = 'Order not found for id ${orderController.text}';
          });
        }
      } catch (e) {
        setState(() {
          errorText = 'An error occurred. Please try again.';
        });
        print('---> Error: $e');
      }
    }

    var theme = Theme.of(context);
    return Scaffold(
      appBar: const AppBarScreen(title: 'Impact'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
                child: Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      surfaceVariant: Colors.transparent,
                    ),
                  ),
                  child: TabBar(
                    indicator: const BoxDecoration(),
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (kDebugMode) {
                        print('Selected tab index: $selectedIndex');
                      }
                    },
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: selectedIndex == 0
                              ? const EdgeInsets.only(top: 4)
                              : const EdgeInsets.only(top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: selectedIndex != 0
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
                              border: const Border(
                                top: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                                left: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                                right: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'My Impact'.toUpperCase(),
                                style: TextStyle(
                                  color: selectedIndex == 0
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: selectedIndex == 1
                              ? const EdgeInsets.only(top: 4)
                              : const EdgeInsets.only(top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: selectedIndex != 1
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
                              border: const Border(
                                top: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                                left: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                                right: BorderSide(
                                    width: 1, color: AppColor.primaryColor),
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Community Impact'.toUpperCase(),
                                style: TextStyle(
                                  color: selectedIndex == 1
                                      ? AppColor.primaryColor
                                      : AppColor.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    labelColor: AppColor.whiteColor,
                    unselectedLabelColor: AppColor.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * 8,
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  for (int index = 0;
                                      index < countryImpactApi.length;
                                      index += 2)
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Image.asset(
                                            countryImpactApi[index]['flag'],
                                            width: 80,
                                            height: 46,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          child: Text(
                                            countryImpactApi[index]['country'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          countryImpactApi[index]['t_count'],
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                              Container(
                                width: 160,
                                height: 160,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80)),
                                    color: AppColor.primaryColor),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'Meals',
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.handLeft,
                                          width: 20,
                                          height: 48,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '172',
                                            style: TextStyle(
                                                color: AppColor.whiteColor,
                                                fontSize: 40,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Image.asset(
                                          ImageAssets.handRight,
                                          width: 20,
                                          height: 48,
                                        )
                                      ],
                                    ),
                                    const Text(
                                      'Donate',
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  for (int index = 1;
                                      index < countryImpactApi.length;
                                      index += 2)
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Image.asset(
                                            countryImpactApi[index]['flag'],
                                            width: 80,
                                            height: 46,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7),
                                          child: Text(
                                            countryImpactApi[index]['country'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          countryImpactApi[index]['t_count'],
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Activities',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.primaryColor),
                              ),
                              Container(
                                width: 120,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: const BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      orderState = true;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color:
                                                    AppColor.navBackgroundColor,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Text(
                                                          'Add your Order'
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColor
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => {
                                                          Navigator.of(context)
                                                              .pop(),
                                                        },
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: AppColor
                                                                .blackColor,
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: AppColor
                                                                .whiteColor,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    child: InputBox(
                                                      labelText:
                                                          'Enter Receipt / Order Number',
                                                      inputType: 'number',
                                                      inputController:
                                                          orderController,
                                                    ),
                                                  ),
                                                  errorText.isNotEmpty
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15),
                                                          child: Text(
                                                            errorText,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColor
                                                                  .redColor,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        )
                                                      : Container(),
                                                  const SizedBox(height: 10),
                                                  ButtonBox(
                                                    buttonText: 'Fetch Order',
                                                    fillColor: true,
                                                    onPressed: handleOrder,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.add_circle,
                                        color: AppColor.whiteColor,
                                        size: 20,
                                      ),
                                      Text(
                                        'Add Order',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: orderState
                              ? MediaQuery.of(context).size.height * 0.1
                              : MediaQuery.of(context).size.height * 0.32,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // ExpansionTileControllerApp()
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 2),
                                  child: ExpansionTiles(
                                    // donateData: totalDonationApi,
                                    donateData: venueMasterData,
                                    orderData: userTransactionData,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    StreamBuilder(
                        stream: fetchStream('parameterData').snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                          if (!snapShot.hasData) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // final DocumentSnapshot documentSnapshot =
                            //     snapShot.data!.docs[0];
                            return SingleChildScrollView(
                                child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    children: [
                                      for (var communityData
                                          in snapShot.data!.docs)
                                        // if (communityData['parameterId'] ==
                                        //         'AUS' || communityData['parameterId'] ==
                                        //     'UKR' || communityData['parameterId'] ==
                                        //     'SRL' ) ?  :
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: AppColor.greyColor)),
                                          ),
                                          child: Row(
                                            children: [
                                              // for (var communityDatas
                                              //     in countryImpactApi)
                                              Image.network(
                                                communityData["parameterImage"],
                                                width: 50,
                                                height: 50,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      communityData[
                                                              "parameterValue"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColor
                                                              .primaryColor),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .65,
                                                      child: Text(
                                                        communityData[
                                                            'parameterName'],
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                StreamBuilder(
                                    stream: fetchStream('parameterCountryData')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapShot) {
                                      if (!snapShot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.primaryColor,
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              for (int index = 0;
                                                  index <
                                                      snapShot
                                                          .data!.docs.length;
                                                  index += 2)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 1),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: index ==
                                                              snapShot
                                                                      .data!
                                                                      .docs
                                                                      .length -
                                                                  2
                                                          ? BorderSide.none
                                                          : const BorderSide(
                                                              width: 1,
                                                              color: AppColor
                                                                  .greyColor,
                                                            ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20),
                                                            child:
                                                                Image.network(
                                                              snapShot.data!
                                                                          .docs[
                                                                      index][
                                                                  'countryFlag'],
                                                              width: 80,
                                                              height: 46,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        7),
                                                            child: Text(
                                                              snapShot.data!
                                                                          .docs[
                                                                      index][
                                                                  'countryName'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            snapShot
                                                                .data!
                                                                .docs[index][
                                                                    'parameterValue']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          height: 150,
                                                          decoration:
                                                              const BoxDecoration(
                                                            border: Border(
                                                              right: BorderSide(
                                                                width: 1,
                                                                color: AppColor
                                                                    .greyColor,
                                                              ),
                                                            ),
                                                          )),
                                                      if (index + 1 <
                                                          snapShot.data!.docs
                                                              .length)
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 20),
                                                              child:
                                                                  Image.network(
                                                                snapShot.data!
                                                                            .docs[
                                                                        index +
                                                                            1][
                                                                    'countryFlag'],
                                                                width: 80,
                                                                height: 46,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          7),
                                                              child: Text(
                                                                snapShot.data!
                                                                            .docs[
                                                                        index +
                                                                            1][
                                                                    'countryName'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              snapShot
                                                                  .data!
                                                                  .docs[index +
                                                                          1][
                                                                      'parameterValue']
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppColor
                                                                    .primaryColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }
                                    })
                              ],
                            ));
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        activeIcon: 0,
      ),
    );
  }
}
