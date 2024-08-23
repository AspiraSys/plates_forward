import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/Utils/app_colors.dart';

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

  Future<void> handleTotalOrder() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      debugPrint("User not authenticated");
      return;
    }

    final UserController userController = Get.find<UserController>();
    debugPrint('the id ${userController.userSquareId.value}');
    print('uuuu $locationId');
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Select the location to fetch Order'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryColor,
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
                                                  color: selectedIndex == index
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
                                                          selectedIndex == index
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
              onPressed: handleTotalOrder,
            ),
          ],
        ),
      ),
    );
  }
}
