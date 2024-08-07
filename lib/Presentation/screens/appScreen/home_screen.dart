import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/Presentation/helpers/app_expanded_box.dart';
import 'package:plates_forward/Presentation/helpers/app_networkError.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Presentation/helpers/app_refresh.dart';
import 'package:plates_forward/Presentation/helpers/app_totalOrder.dart';
import 'package:plates_forward/models/user_activity.dart';
import 'package:plates_forward/square/model/search_order/search_order_date_request.dart';
import 'package:plates_forward/square/model/search_order/search_order_request.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/Presentation/helpers/app_addOrder.dart';
import 'package:plates_forward/square/model/search_user/search_user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool orderState = false;
  bool isButtonEnable = false;
  bool isLoading = false;
  // String? userSquareId;
  final TextEditingController orderController = TextEditingController();
  String? customerId;
  // final GlobalKey<_AddOrderDialog> dialogKey = GlobalKey<_AddOrderDialog>();

  String errorText = '';
  var square = SquareFunction();
  List<Map<String, dynamic>> venueMasterData = [];
  List<Map<String, dynamic>> userTransactionData = [];
  List<String> locationId = [];
  // ignore: non_constant_identifier_names
  late final SearchUserModel searchUserModel;

  @override
  void initState() {
    super.initState();
    checkAndPrintMatchingData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    // squareId();
  }

  // void squareId() {
  //   try {
  //     if (searchUserModel.customers.isNotEmpty) {
  //       setState(() {
  //         userSquareId = searchUserModel.customers[0].id;
  //       });
  //     } else {
  //       setState(() {
  //         errorText = 'No user found with this email.';
  //       });
  //     }
  //   } catch (error) {
  //     setState(() {
  //       errorText = 'An error occurred: $error';
  //     });
  //   }
  // }

  Future<void> _loadCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString('customerID');
    });
  }

  Future<List<Map<String, dynamic>>> fetchVenueMasterData(
      String locationId) async {
    final CollectionReference venueMasterCollection =
        FirebaseFirestore.instance.collection('venueMaster');

    QuerySnapshot<Object?> querySnapshot = await venueMasterCollection
        .where('locationId', isEqualTo: locationId)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Future<void> checkAndPrintMatchingData() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     return;
  //   }
  //   final String userId = user.uid;

  //   final CollectionReference userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');

  //   DocumentSnapshot<Object?> userTransactionDocumentSnapshot =
  //       await userTransactionCollection.doc(userId).get();

  //   if (userTransactionDocumentSnapshot.exists) {
  //     Map<String, dynamic> userData =
  //         userTransactionDocumentSnapshot.data() as Map<String, dynamic>;

  //     List<Map<String, dynamic>> userActivityDataList =
  //         (userData['userActivityData'] as List<dynamic>)
  //             .cast<Map<String, dynamic>>()
  //             .toList();

  //     List<String?> locationIds = userActivityDataList
  //         .map((activity) => activity['locationId'] as String?)
  //         .toList()
  //         .whereType<String>()
  //         .toList();

  //     for (String? locationId in locationIds) {
  //       if (locationId != null) {
  //         final venueData = await fetchVenueMasterData(locationId);

  //         venueMasterData.addAll(venueData);
  //       } else {
  //         print('locationId is null');
  //       }
  //     }

  //     // List<Map<String, dynamic>> sorData =
  //     //     userActivityDataList.reversed.toList();

  //     // userTransactionData = sorData;
  //     List<Map<String, dynamic>> sorData =
  //         userActivityDataList.reversed.toList();
  //     userTransactionData = sorData;

  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> checkAndPrintMatchingData() async {
    setState(() {
      isLoading = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final String userId = user.uid;

    final CollectionReference userTransactionCollection =
        FirebaseFirestore.instance.collection('userTransaction');

    DocumentSnapshot<Object?> userTransactionDocumentSnapshot =
        await userTransactionCollection.doc(userId).get();

    if (userTransactionDocumentSnapshot.exists) {
      Map<String, dynamic> userData =
          userTransactionDocumentSnapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> userActivityDataList =
          (userData['userActivityData'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .toList();

      List<String?> locationIds = userActivityDataList
          .map((activity) => activity['locationId'] as String?)
          .toList()
          .whereType<String>()
          .toList();

      // Clear the data before adding new data to avoid duplication
      venueMasterData.clear();
      userTransactionData.clear();

      for (String? locationId in locationIds) {
        if (locationId != null) {
          final venueData = await fetchVenueMasterData(locationId);
          venueMasterData.addAll(venueData);
        } else {
          print('locationId is null');
        }
      }

      List<Map<String, dynamic>> sorData =
          userActivityDataList.reversed.toList();
      userTransactionData = sorData;

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  static CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  // handleTotal() {
  //   // final FirebaseAuth auth = FirebaseAuth.instance;
  //   // final User? user = auth.currentUser;

  //   // if (user == null) {
  //   //   print("User not authenticated");
  //   //   return;
  //   // }
  //   if (venueMasterData.isEmpty) {
  //     print('Venue master data is empty');
  //     return;
  //   }

  //   // Filter active venues
  //   List<String> activeLocationIds = venueMasterData
  //       .where((venue) => venue['isActive'] == true)
  //       .map((venue) => venue['locationId'] as String)
  //       .toList();

  //   // Now you have a list of active locationIds
  //   print('Active Location IDs: $activeLocationIds');

  //   final UserController userController = Get.find<UserController>();
  //   debugPrint('the id ${userController.userSquareId.value}');
  //   // print('uuuu $locationId');
  // }

  // Future<void> handleTotal() async {
  //   await _loadCustomerId();
  //   final venueMasterCollection =
  //       FirebaseFirestore.instance.collection('venueMaster');
  //   final QuerySnapshot venueMasterSnapshot = await venueMasterCollection.get();

  //   final List<Map<String, dynamic>> venueMasterData = venueMasterSnapshot.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();

  //   final List<String> activeLocationIds = venueMasterData
  //       .where((venue) => venue['isActive'] == 1)
  //       .map((venue) => venue['locationId'] as String)
  //       .toList();

  //   // locationId.addAll(activeLocationIds);
  //   print('---> $activeLocationIds');
  //   print('---><----- $customerId');

  //   if (customerId != null) {
  //     for (String location in activeLocationIds) {
  //       final resp = await searchOrders(
  //           request: SearchOrderRequest(
  //               customerId: customerId!, locationId: location));

  //       if (resp != null) {
  //         final activities = parseOrdersResponse(resp);
  //         await storeUserActivities(activities);
  //         checkAndPrintMatchingData().then((_) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         });
  //       } else {
  //         print('Error in fetching orders');
  //       }
  //     }
  //   }
  // }

  // Future<Map<String, dynamic>?> searchOrders(
  //     {required SearchOrderRequest request}) async {
  //   final res = await square.searchOrders(
  //       customerId: request, locationId: request.locationId);
  //   if (res != null) {
  //     return res;
  //   } else {
  //     print('Error in fetching orders');
  //   }
  //   return null;
  // }

  // List<UserActivityData> parseOrdersResponse(Map<String, dynamic> response) {
  //   List<UserActivityData> activities = [];
  //   if (response['orders'] != null) {
  //     for (var order in response['orders']) {
  //       List<ListItem> lineItems = [];
  //       for (var item in order['line_items']) {
  //         lineItems.add(ListItem(
  //           name: item['name'],
  //           uid: item['uid'],
  //           amount: item['total_money']['amount'],
  //           quantity: item['quantity'],
  //         ));
  //       }
  //       activities.add(UserActivityData(
  //         id: order['id'],
  //         locationId: order['location_id'],
  //         createdAt: order['created_at'],
  //         totalAmount: order['total_money']['amount'],
  //         lineItems: lineItems,
  //         type: 0
  //       ));
  //     }
  //   }
  //   return activities;
  // }

  // Future<List<UserActivityData>> fetchExistingActivities(String userId) async {
  //   final userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');
  //   final userDoc = await userTransactionCollection.doc(userId).get();

  //   if (userDoc.exists) {
  //     final data = userDoc.data();
  //     if (data != null && data['userActivityData'] != null) {
  //       return (data['userActivityData'] as List<dynamic>)
  //           .map((item) => UserActivityData.fromJson(item))
  //           .toList();
  //     }
  //   }
  //   return [];
  // }

  // Future<void> storeUserActivities(List<UserActivityData> newActivities) async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   if (user == null) {
  //     print("User not authenticated");
  //     return;
  //   }
  //   final String userUid = user.uid;

  //   final existingActivities = await fetchExistingActivities(userUid);
  //   final newUniqueActivities = newActivities.where((newActivity) {
  //     return !existingActivities
  //         .any((existingActivity) => existingActivity.id == newActivity.id);
  //   }).toList();

  //   if (newUniqueActivities.isEmpty) {
  //     print("No new activities to add.");
  //     const snackBar = SnackBar(
  //       content: Text('No new activities to add. It is upto date'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     return;
  //   }

  //   final userTransactionCollection =
  //       FirebaseFirestore.instance.collection('userTransaction');
  //   final userDoc = userTransactionCollection.doc(userUid);

  //   final userData = {
  //     'userActivityData': FieldValue.arrayUnion(
  //         newUniqueActivities.map((activity) => activity.toJson()).toList()),
  //   };

  //   await userDoc.set(userData, SetOptions(merge: true));

  //   // final duplicates = newActivities.where((activity) {
  //   //   return existingActivities
  //   //       .any((existingActivity) => existingActivity.id == activity.id);
  //   // }).toList();

  //   // if (newUniqueActivities.isEmpty) {
  //   //   const snackBar = SnackBar(
  //   //     content: Text('No new activities to add. It is upto date'),
  //   //   );
  //   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   // }
  // }

  // Future<void> handleTotal() async {
  //   await _loadCustomerId();
  //   final venueMasterCollection =
  //       FirebaseFirestore.instance.collection('venueMaster');
  //   final QuerySnapshot venueMasterSnapshot = await venueMasterCollection.get();

  //   final List<Map<String, dynamic>> venueMasterData = venueMasterSnapshot.docs
  //       .map((doc) => doc.data() as Map<String, dynamic>)
  //       .toList();

  //   final List<String> activeLocationIds = venueMasterData
  //       .where((venue) => venue['isActive'] == 1)
  //       .map((venue) => venue['locationId'] as String)
  //       .toList();

  //   // Print active locations and customer ID
  //   print('---> $activeLocationIds');
  //   print('---><----- $customerId');

  //   if (customerId != null) {
  //     // Fetch existing activities to determine the latest createdAt date
  //     final existingActivities = await fetchExistingActivities(customerId!);
  //     DateTime? latestCreatedAt;

  //     if (existingActivities.isNotEmpty) {
  //       final latestActivity = existingActivities
  //           .where((activity) => activity.type == 0)
  //           .reduce((a, b) =>
  //               DateTime.parse(a.createdAt).isAfter(DateTime.parse(b.createdAt))
  //                   ? a
  //                   : b);
  //       latestCreatedAt = DateTime.parse(latestActivity.createdAt);
  //     }

  //     for (String location in activeLocationIds) {
  //       final resp = await searchOrders(
  //         request: SearchOrderRequest(
  //           customerId: customerId!,
  //           locationId: location,
  //           startAt: latestCreatedAt
  //               !.toIso8601String(),
  //         ),
  //       );

  //       if (resp != null) {
  //         final activities = parseOrdersResponse(resp);
  //         await storeUserActivities(activities);
  //         checkAndPrintMatchingData().then((_) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         });
  //       } else {
  //         print('Error in fetching orders');
  //       }
  //     }
  //   }
  // }

  Future<void> handleTotal() async {
    await _loadCustomerId();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      print("User not authenticated");
      return;
    }

    final String userUid = user.uid;

    final venueMasterCollection =
        FirebaseFirestore.instance.collection('venueMaster');
    final QuerySnapshot venueMasterSnapshot = await venueMasterCollection.get();

    final List<Map<String, dynamic>> venueMasterData = venueMasterSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    final List<String> activeLocationIds = venueMasterData
        .where((venue) => venue['isActive'] == 1)
        .map((venue) => venue['locationId'] as String)
        .toList();

    // Print active locations and customer ID
    print('---> $activeLocationIds');
    print('---><----- $customerId');

    if (customerId != null) {
      // Fetch existing activities to determine the latest createdAt date
      final existingActivities = await fetchExistingActivities(userUid);
      DateTime? latestCreatedAt;

      if (userTransactionData.isEmpty) {
        for (String location in activeLocationIds) {
          final resp = await callSearchOrders(
            request: SearchOrderRequest(
              customerId: customerId!,
              locationId: location,
            ),
          );

          if (resp != null) {
            final activities = parseOrdersResponse(resp);
            if (activities.isEmpty) {
              _showNoOrdersSnackbar();
            } else {
              await storeUserActivities(activities);
              checkAndPrintMatchingData().then((_) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            }
          } else {
            print('Error in fetching orders');
          }
        }
      } else {
        final latestActivity = existingActivities
            .where((activity) => activity.type == 0)
            .reduce((a, b) =>
                DateTime.parse(a.createdAt).isAfter(DateTime.parse(b.createdAt))
                    ? a
                    : b);
        latestCreatedAt = DateTime.parse(latestActivity.createdAt);
        for (String location in activeLocationIds) {
          final resp = await callSearchOrdersWithDate(
            request: SearchOrderRequestWithDate(
              customerId: customerId!,
              locationId: location,
              startAt: latestCreatedAt.toIso8601String(),
            ),
          );
          if (resp != null) {
            final activities = parseOrdersResponse(resp);
            if (activities.isEmpty) {
              _showNoOrdersSnackbar();
            } else {
              await storeUserActivities(activities);
              checkAndPrintMatchingData().then((_) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            }
          } else {
            print('Error in fetching orders');
          }
        }
      }
    }
  }

  Future<Map<String, dynamic>?> callSearchOrders(
      {required SearchOrderRequest request}) async {
    final res = await square.searchOrders(
      request: request,
    );

    if (res != null) {
      return res;
    } else {
      print('Error in fetching orders');
    }
    return null;
  }

  Future<Map<String, dynamic>?> callSearchOrdersWithDate(
      {required SearchOrderRequestWithDate request}) async {
    final res = await square.searchOrdersWithDate(
      request: request,
    );

    if (res != null) {
      return res;
    } else {
      print('Error in fetching orders');
    }
    return null;
  }

  // Future<Map<String, dynamic>?> searchOrders(
  //     {required SearchOrderRequest request}) async {
  //   final res = await square.searchOrders(
  //       customerId: request, locationId: request.locationId, startAt: request);
  //   if (res != null) {
  //     return res;
  //   } else {
  //     print('Error in fetching orders');
  //   }
  //   return null;
  // }

  List<UserActivityData> parseOrdersResponse(Map<String, dynamic> response) {
    List<UserActivityData> activities = [];
    if (response['orders'] != null) {
      for (var order in response['orders']) {
        List<ListItem> lineItems = [];
        for (var item in order['line_items']) {
          lineItems.add(ListItem(
            name: item['name'],
            uid: item['uid'],
            amount: item['total_money']['amount'],
            quantity: item['quantity'],
          ));
        }
        activities.add(UserActivityData(
          id: order['id'],
          locationId: order['location_id'],
          createdAt: order['created_at'],
          totalAmount: order['total_money']['amount'],
          lineItems: lineItems,
          type: 0,
        ));
      }
    }
    return activities;
  }

  Future<List<UserActivityData>> fetchExistingActivities(String userId) async {
    final userTransactionCollection =
        FirebaseFirestore.instance.collection('userTransaction');
    final userDoc = await userTransactionCollection.doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null && data['userActivityData'] != null) {
        return (data['userActivityData'] as List<dynamic>)
            .map((item) => UserActivityData.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  Future<void> storeUserActivities(List<UserActivityData> newActivities) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      print("User not authenticated");
      return;
    }
    final String userUid = user.uid;

    final existingActivities = await fetchExistingActivities(userUid);
    final newUniqueActivities = newActivities.where((newActivity) {
      return !existingActivities
          .any((existingActivity) => existingActivity.id == newActivity.id);
    }).toList();

    if (newUniqueActivities.isEmpty) {
      print("No new activities to add.");
      const snackBar = SnackBar(
        content: Text('No new activities to add. It is up to date'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final userTransactionCollection =
        FirebaseFirestore.instance.collection('userTransaction');
    final userDoc = userTransactionCollection.doc(userUid);

    final userData = {
      'userActivityData': FieldValue.arrayUnion(
          newUniqueActivities.map((activity) => activity.toJson()).toList()),
    };

    await userDoc.set(userData, SetOptions(merge: true));
    await storeSyncData(newUniqueActivities);
  }

  Future<void> storeSyncData(List<UserActivityData> newActivities) async {
    if (customerId == null) {
      print('No customerId available for syncing data.');
      return;
    }

    final orderSyncCollection =
        FirebaseFirestore.instance.collection('orderSync');

    try {
      // Prepare the data to store
      final syncData = {
        'lastSync': FieldValue.serverTimestamp(),
        'activities':
            newActivities.map((activity) => activity.toJson()).toList(),
      };

      // Use the customerId as the document ID in the 'orderSync' collection
      await orderSyncCollection
          .doc(customerId)
          .set(syncData, SetOptions(merge: true));

      print('Data synchronized successfully for customerId: $customerId');
    } catch (e) {
      print('Failed to sync data for customerId: $customerId. Error: $e');
    }
  }

  void _showNoOrdersSnackbar() {
    const snackBar = SnackBar(
      content: Text('There are no orders made yet.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    int countCityOccurrences(
      List<Map<String, dynamic>> venueMasterData,
      String cityName,
    ) {
      return venueMasterData
          .where((doc) =>
              doc['venueCityName'] == cityName ||
              doc['secondaryCityName'] == cityName)
          .length;
    }

    int calculateTotalCount(List<Map<String, dynamic>> venueMasterData,
        List<Map<String, dynamic>> countryData) {
      int totalCount = 0;

      for (var doc in countryData) {
        totalCount += countCityOccurrences(venueMasterData, doc['countryName']);
      }
      return totalCount;
    }

    var theme = Theme.of(context);

    final NetworkController networkController = Get.find<NetworkController>();

    Future<void> refreshData() async {
      await Future.delayed(const Duration(seconds: 2));
      await checkAndPrintMatchingData();
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: AppBarScreen(title: 'Impact')),
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
                  Expanded(child: Obx(() {
                    if (!networkController.isConnected.value) {
                      return const Center(
                          child: NoDataMessage(
                        message:
                            'There is no data, kindly your check Internet Connection',
                      ));
                    } else {
                      return TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          RefreshesIndicator(
                            onRefresh: refreshData,
                            child: ListView(
                              children: [
                                Column(
                                  children: [
                                    StreamBuilder(
                                        stream:
                                            fetchStream('parameterCountryData')
                                                .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapShot) {
                                          if (!snapShot.hasData) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                              ),
                                            );
                                          } else {
                                            List<Map<String, dynamic>>
                                                countryData = snapShot
                                                    .data!.docs
                                                    .map((doc) => doc.data()
                                                        as Map<String, dynamic>)
                                                    .toList();
                                            int totalCount =
                                                calculateTotalCount(
                                                    venueMasterData,
                                                    countryData);

                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.38,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        for (int index = 0;
                                                            index <
                                                                snapShot
                                                                    .data!
                                                                    .docs
                                                                    .length;
                                                            index += 2)
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                child: Image
                                                                    .network(
                                                                  snapShot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'countryFlag'],
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
                                                                          index]
                                                                      [
                                                                      'countryName'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${countCityOccurrences(venueMasterData, snapShot.data!.docs[index]['countryName'])}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (mounted) {
                                                        setState(() {
                                                          orderState = true;
                                                          isButtonEnable = true;
                                                        });
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                              elevation: 0,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child:
                                                                  AddOrderDialog(
                                                                updateOrderState:
                                                                    (bool
                                                                        state) {
                                                                  setState(() {
                                                                    orderState =
                                                                        state;
                                                                  });
                                                                },
                                                                onSuccess: () {
                                                                  checkAndPrintMatchingData();
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 144,
                                                      height: 144,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          72)),
                                                          color: AppColor
                                                              .primaryColor),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Text(
                                                            'Meals',
                                                            style: TextStyle(
                                                                color: AppColor
                                                                    .whiteColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                ImageAssets
                                                                    .handLeft,
                                                                width: 16,
                                                                height: 45,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Text(
                                                                  totalCount
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: AppColor
                                                                          .whiteColor,
                                                                      fontSize:
                                                                          35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              Image.asset(
                                                                ImageAssets
                                                                    .handRight,
                                                                width: 16,
                                                                height: 45,
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            child: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Padding(
                                                                //   padding: EdgeInsets
                                                                //       .only(
                                                                //           right:
                                                                //               5),
                                                                //   child: Text(
                                                                //     'Donate',
                                                                //     style: TextStyle(
                                                                //         color: AppColor
                                                                //             .whiteColor,
                                                                //         fontSize:
                                                                //             14,
                                                                //         fontWeight:
                                                                //             FontWeight.w400),
                                                                //   ),
                                                                // ),
                                                                Icon(
                                                                  Icons
                                                                      .add_circle,
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  size: 22,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        for (int index = 1;
                                                            index <
                                                                snapShot
                                                                    .data!
                                                                    .docs
                                                                    .length;
                                                            index += 2)
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                child: Image
                                                                    .network(
                                                                  snapShot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'countryFlag'],
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
                                                                          index]
                                                                      [
                                                                      'countryName'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${countCityOccurrences(venueMasterData, snapShot.data!.docs[index]['countryName'])}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
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
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'My Activities'.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.primaryColor),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        handleTotal();
                                                      },
                                                      child: const Icon(
                                                        Icons.data_exploration,
                                                        color: AppColor
                                                            .primaryColor,
                                                        size: 30,
                                                      ))),
                                              Container(
                                                width: 120,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: const BoxDecoration(
                                                    color:
                                                        AppColor.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (mounted) {
                                                      setState(() {
                                                        orderState = true;
                                                        isButtonEnable = true;
                                                      });
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child:
                                                                AddOrderDialog(
                                                              updateOrderState:
                                                                  (bool state) {
                                                                setState(() {
                                                                  orderState =
                                                                      state;
                                                                });
                                                              },
                                                              onSuccess: () {
                                                                checkAndPrintMatchingData();
                                                                setState(() {});
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(
                                                        Icons.add_circle,
                                                        color:
                                                            AppColor.whiteColor,
                                                        size: 20,
                                                      ),
                                                      Text(
                                                        'Add Order',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColor
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 2),
                                            child: isLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          AppColor.primaryColor,
                                                      strokeWidth: 3,
                                                    ),
                                                  )
                                                : venueMasterData.isEmpty &&
                                                        userTransactionData
                                                            .isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                          'No orders yet made!',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .primaryColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 2,
                                                          ),
                                                        ),
                                                      )
                                                    : ExpansionTiles(
                                                        donateData:
                                                            venueMasterData,
                                                        orderData:
                                                            userTransactionData,
                                                      ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: fetchStream('parameterData').snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapShot) {
                                if (!snapShot.hasData) {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Column(
                                          children: [
                                            for (var communityData
                                                in snapShot.data!.docs)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 20),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: AppColor
                                                              .greyColor)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                      communityData[
                                                          "parameterImage"],
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              communityData[
                                                                      "parameterValue"]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: AppColor
                                                                      .primaryColor),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .65,
                                                              child: Text(
                                                                communityData[
                                                                    'parameterName'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      StreamBuilder(
                                          stream: fetchStream(
                                                  'parameterCountryData')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapShot) {
                                            if (!snapShot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColor.primaryColor,
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    for (int index = 0;
                                                        index <
                                                            snapShot.data!.docs
                                                                .length;
                                                        index += 2)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 1),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: index ==
                                                                    snapShot
                                                                            .data!
                                                                            .docs
                                                                            .length -
                                                                        2
                                                                ? BorderSide
                                                                    .none
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
                                                                          top:
                                                                              20),
                                                                  child: Image
                                                                      .network(
                                                                    snapShot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'countryFlag'],
                                                                    width: 80,
                                                                    height: 46,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          7),
                                                                  child: Text(
                                                                    snapShot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'countryName'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  snapShot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'parameterValue']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        22,
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
                                                                  border:
                                                                      Border(
                                                                    right:
                                                                        BorderSide(
                                                                      width: 1,
                                                                      color: AppColor
                                                                          .greyColor,
                                                                    ),
                                                                  ),
                                                                )),
                                                            if (index + 1 <
                                                                snapShot
                                                                    .data!
                                                                    .docs
                                                                    .length)
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                    child: Image
                                                                        .network(
                                                                      snapShot.data!
                                                                              .docs[
                                                                          index +
                                                                              1]['countryFlag'],
                                                                      width: 80,
                                                                      height:
                                                                          46,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            7),
                                                                    child: Text(
                                                                      snapShot.data!
                                                                              .docs[
                                                                          index +
                                                                              1]['countryName'],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    snapShot
                                                                        .data!
                                                                        .docs[
                                                                            index +
                                                                                1]
                                                                            [
                                                                            'parameterValue']
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          22,
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
                      );
                    }
                  })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _DialogContent extends StatefulWidget {
//   final Function(bool) updateOrderState;
//   final VoidCallback onSuccess;

//   const _DialogContent({
//     super.key,
//     required this.updateOrderState,
//     required this.onSuccess,
//   });

//   @override
//   _DialogContentState createState() => _DialogContentState();
// }

// class _DialogContentState extends State<_DialogContent> {
//   final TextEditingController _orderController = TextEditingController();

//   String errorText = '';
//   var square = SquareFunction();
//   final Scanner scanner = Scanner();

//   @override
//   void dispose() {
//     _orderController.dispose();
//     super.dispose();
//   }

//   Future<void> saveUserTransactionData(RetrieveOrderResponse result) async {
//     List<ListItem> lineItems = result.order?.lineItems?.map((item) {
//           return ListItem(
//             name: item.name ?? '',
//             uid: item.uid ?? '',
//             amount: item.basePriceMoney?.amount ?? 0,
//             quantity: item.quantity ?? '',
//           );
//         }).toList() ??
//         [];

//     num totalAmount = result.order?.netAmounts?.totalMoney?.amount ?? 0;

//     UserActivityData userActivityData = UserActivityData(
//       id: result.order?.id ?? '',
//       locationId: result.order?.locationId ?? '',
//       createdAt: result.order?.createdAt ?? '',
//       totalAmount: totalAmount,
//       lineItems: lineItems,
//     );

//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final FirebaseAuth auth = FirebaseAuth.instance;

//     final User? user = auth.currentUser;
//     if (user != null) {
//       final String userId = user.uid;

//       await firestore.collection("userTransaction").doc(userId).set({
//         'userActivityData': FieldValue.arrayUnion([userActivityData.toJson()])
//       }, SetOptions(merge: true));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Successfully added to Impact',
//             style: TextStyle(color: AppColor.whiteColor),
//           ),
//           duration: Duration(seconds: 5),
//         ),
//       );

//       Future.delayed(const Duration(seconds: 3), () {
//         widget.updateOrderState(false);
//         Navigator.pop(context);
//         // checkAndPrintMatchingData;
//       });
//     } else {
//       print("User not authenticated");
//     }
//   }

//   Future<void> handleOrder() async {
//     final String orderId = _orderController.text;
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;

//     if (user == null) {
//       print("User not authenticated");
//       return;
//     }

//     final response = await square.retrieveOrder(
//         orderId: RetrieveOrderRequest(orderId: orderId));

//     if (_orderController.text.isEmpty) {
//       setState(() {
//         errorText = 'Invalid order ID';
//       });
//       return;
//     } else if (response is RetrieveOrderResponse) {
//       if (response.errors != null) {
//         final errorDetail = response.errors![0].detail;
//         setState(() {
//           errorText = errorDetail!;
//         });
//         return;
//       } else {
//         final String userUid = user.uid;
//         final CollectionReference userTransactionCollection =
//             FirebaseFirestore.instance.collection('userTransaction');

//         DocumentSnapshot<Object?> userTransactionDocumentSnapshot =
//             await userTransactionCollection.doc(userUid).get();

//         if (userTransactionDocumentSnapshot.exists) {
//           Map<String, dynamic> userData =
//               userTransactionDocumentSnapshot.data() as Map<String, dynamic>;

//           List<Map<String, dynamic>> userActivityDataList =
//               (userData['userActivityData'] as List<dynamic>)
//                   .cast<Map<String, dynamic>>()
//                   .toList();
//           bool orderIdFound = false;
//           for (var activity in userActivityDataList) {
//             var idValue = activity['id'];
//             if (idValue == orderId) {
//               orderIdFound = true;
//               break;
//             }
//           }
//           if (orderIdFound) {
//             setState(() {
//               errorText = 'OrderId is already exists';
//             });
//           } else {
//             await saveUserTransactionData(response);
//             _orderController.text = '';
//             setState(() {
//               errorText = '';
//             });
//             widget.onSuccess();

//             // setState(() {});
//           }
//         } else {
//           await saveUserTransactionData(response);
//           _orderController.text = '';
//           setState(() {
//             errorText = '';
//           });
//           widget.onSuccess();

//           // setState(() {});
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: AppColor.navBackgroundColor,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: Text(
//                     'Add your Order'.toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: AppColor.primaryColor,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (mounted) {
//                       widget.updateOrderState(false);
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Container(
//                     width: 20,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColor.blackColor,
//                     ),
//                     child: const Icon(
//                       Icons.close,
//                       color: AppColor.whiteColor,
//                       size: 15,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   child: InputBox(
//                 labelText: 'Enter Receipt / Order Number',
//                 inputType: 'text',
//                 inputController: _orderController,
//               ),
//                 ) ,
//                 GestureDetector(
//                     onTap: () => {scanner.scan(context)},
//                     child: const Icon(
//                       Icons.camera_sharp,
//                       color: AppColor.primaryColor,
//                       size: 35,
//                     )),
//               ],
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 0),
//             //   child: InputBox(
//             //     labelText: 'Enter Receipt / Order Number',
//             //     inputType: 'text',
//             //     inputController: _orderController,
//             //   ),
//             // ),
//             // Padding(
//             //   padding: const EdgeInsets.only(right: 0),
//             //   child: GestureDetector(
//             //       onTap: () => {scanner.scan(context)},
//             //       child: const Icon(
//             //         Icons.camera_sharp,
//             //         color: AppColor.primaryColor,
//             //         size: 35,
//             //       )),
//             // ),
//             errorText.isNotEmpty
//                 ? Container(
//                     width: MediaQuery.of(context).size.width * 0.7,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 20),
//                     child: Text(
//                       errorText,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: AppColor.redColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   )
//                 : Container(),
//             const SizedBox(height: 10),
//             ButtonBox(
//               buttonText: 'Fetch Order',
//               fillColor: true,
//               onPressed: handleOrder,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
