import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Utils/app_colors.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 25, right: 40),
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
                                    index < snapShot.data!.docs.length;
                                    index++)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: AppColor.primaryColor),
                                          borderRadius: const BorderRadius.all(
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
                                                snapShot.data!.docs[index]
                                                    ['venueImage'],
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                            Text(
                                              snapShot.data!.docs[index]
                                                  ['venueName'],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: selectedIndex == index
                                                      ? AppColor.whiteColor
                                                      : AppColor.primaryColor),
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
          const Spacer(),
          Center(
            child: InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(RoutePaths.donateSuccessRoute),
              child: Container(
                width: 176,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColor.primaryColor,
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
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        activeIcon: 2,
      ),
    );
  }
}
