import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_networkError.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Presentation/helpers/venue_card.dart';
import 'package:plates_forward/Utils/app_colors.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference<Object?> fetchStream(String collection) {
      final CollectionReference collections =
          FirebaseFirestore.instance.collection(collection);

      return collections;
    }

    var theme = Theme.of(context);

    final NetworkController networkController = Get.find<NetworkController>();

    return Scaffold(
        appBar: const AppBarScreen(
          title: '',
          isMission: true,
          subScreen: true,
        ),
        body: Obx(() {
          if (!networkController.isConnected.value) {
            return const Center(
              child: NoDataMessage(
                  message:
                      'There is no data, kindly your check Internet Connection'),
            );
          } else {
            return Padding(
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
                          },
                          tabs: [
                            Tab(
                              child: Padding(
                                padding: selectedIndex == 0
                                    ? const EdgeInsets.only(top: 4)
                                    : const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: selectedIndex != 0
                                        ? AppColor.primaryColor
                                        : AppColor.whiteColor,
                                    border: const Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                      left: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                      right: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Summary'.toUpperCase(),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: selectedIndex != 1
                                        ? AppColor.primaryColor
                                        : AppColor.whiteColor,
                                    border: const Border(
                                      top: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                      left: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                      right: BorderSide(
                                          width: 1,
                                          color: AppColor.primaryColor),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Donation Location'.toUpperCase(),
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
                          SingleChildScrollView(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream:
                                      fetchStream('missionSummary').snapshots(),
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
                                      return Column(
                                        children: [
                                          for (var summaryData
                                              in snapShot.data!.docs)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  SizedBox(
                                                    height: 250,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      child: Image.network(
                                                        summaryData[
                                                            'restaurantimage'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Text(
                                                        summaryData['title']
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 20,
                                                            letterSpacing: 0.4),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15),
                                                      child: Text(
                                                        summaryData[
                                                            'description'],
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      );
                                    }
                                  })),
                          SingleChildScrollView(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: fetchStream('missionDonationLocation')
                                      .snapshots(),
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
                                      return Column(
                                        children: [
                                          for (var donateData
                                              in snapShot.data!.docs)
                                            VenueCard(
                                              id: donateData['id'],
                                              image: donateData['image'],
                                              name: donateData['city'],
                                              venue: donateData['country'],
                                              about: donateData['description'],
                                              donationScreen: true,
                                            )
                                        ],
                                      );
                                    }
                                  }))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }));
  }
}
