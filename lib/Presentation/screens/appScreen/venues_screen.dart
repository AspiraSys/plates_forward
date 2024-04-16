import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
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
    return Scaffold(
      appBar: const AppBarScreen(title: 'Venues'),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: fetchStream('venueData').snapshots(),
            builder: (context, snapShot) {
              if (!snapShot.hasData) {
                return Center(
                  child: Container(
                    width: 100,
                    color: AppColor.whiteColor,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.primaryColor,),
                    ),
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
                      chefName: venueData['chefName'],
                      websiteLink: venueData['websiteLink'],
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        activeIcon: 1,
      ),
    );
  }
}
