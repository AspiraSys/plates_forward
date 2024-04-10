import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_expanded_box.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
// import 'package:plates_forward/Presentation/helpers/app_expanded_box.dart';
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

  final TextEditingController orderController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> communityImpactApi = [
      {
        'id': "1",
        "count": "342, 893",
        "message": "Meals provided",
        "icon": ImageAssets.mealIcon,
      },
      {
        'id': "2",
        "count": "342, 893",
        "message": "Hours of paid training and employment",
        "icon": ImageAssets.clockIcon,
      },
      {
        'id': "3",
        "count": "342, 893",
        "message": "Marginalised community members employed",
        "icon": ImageAssets.peopleIcon,
      },
    ];

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
          {"id": 1, "item": "Saumon a la Parisienne", "cost": "32.00"},
          {"id": 2, "item": "Croque Monsieur", "cost": "13.00"},
          {"id": 3, "item": "Total", "cost": "61.00"},
        ],
        "title": "Meal Donation",
        "date": "06/12/2023"
      },
    ];

      void handleOrder() {
        Navigator.of(context).pop();
      }

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
                            ? const EdgeInsets.only(top: 6)
                            : const EdgeInsets.all(0),
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
                            ? const EdgeInsets.only(top: 6)
                            : const EdgeInsets.all(0),
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
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
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
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
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
                                'My Actvities',
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
                                                color: AppColor.navBackgroundColor,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Add your Order'
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          AppColor.primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  const Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    child: InputBox(
                                                      labelText:
                                                          'Enter Receipt Number / order Number',
                                                      inputType: 'number',
                                                      inputController: '',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  ButtonBox(
                                                    buttonText: 'Order',
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // ExpansionTileControllerApp()
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 2),
                                  child: ExpansionTiles(
                                    donateData: totalDonationApi,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              for (var communityData in communityImpactApi)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: AppColor.greyColor)),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        communityData["icon"],
                                        width: 50,
                                        height: 50,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              communityData["count"],
                                              style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.primaryColor),
                                            ),
                                            Text(
                                              communityData['message'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int index = 0;
                                  index < countryImpactApi.length;
                                  index += 2)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          index == countryImpactApi.length - 2
                                              ? BorderSide.none
                                              : const BorderSide(
                                                  width: 1,
                                                  color: AppColor.greyColor,
                                                ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              countryImpactApi[index]
                                                  ['country'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            countryImpactApi[index]['count'],
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                          height: 150,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: AppColor.greyColor,
                                              ),
                                            ),
                                          )),
                                      if (index + 1 < countryImpactApi.length)
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Image.asset(
                                                countryImpactApi[index + 1]
                                                    ['flag'],
                                                width: 80,
                                                height: 46,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7),
                                              child: Text(
                                                countryImpactApi[index + 1]
                                                    ['country'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              countryImpactApi[index + 1]
                                                  ['count'],
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
                                ),
                            ],
                          ),
                        )
                      ],
                    ))
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
