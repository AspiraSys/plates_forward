import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_networkError.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Presentation/helpers/venue_card.dart';
import 'package:plates_forward/utils/app_colors.dart';

class VenueScreen extends StatelessWidget {
  const VenueScreen({super.key});

  CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();
    return Scaffold(
        appBar: const AppBarScreen(title: 'Venues'),
        body: Obx(() {
          if (!networkController.isConnected.value) {
            return const Center(
              child: NoDataMessage(
                message:
                    'There is no data, kindly your check Internet Connection',
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: fetchStream('venueData').snapshots(),
                  builder: (context, snapShot) {
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: snapShot.data!.docs.map((venueData) {
                          return VenueCard(
                            id: venueData['id'],
                            name: venueData['venue'],
                            image: venueData['image'],
                            venue: venueData['city'],
                            about: venueData['description'],
                            // vision: venueData['vision'],
                            // chefName: venueData['chefName'],
                            websiteLink: venueData['websiteLink'],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            );
          }
        }));
  }
}
