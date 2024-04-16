import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/venue_card.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/utils/app_assets.dart';

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
    List<Map<String, dynamic>> donationLocationApi = [
      {
        'id': 1,
        'image': ImageAssets.venueImgSample,
        'state': 'Kyiv',
        'country': 'Ukraine',
        'about':
            'We provide essential funds to a war-affected orphanage, supporting an increasing number of children. These funds secure fresh produce, ensuring the kids enjoy high-quality, nutritious meals.',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 2,
        'image': ImageAssets.venueImgSample,
        'state': 'Colombo Social',
        'country': 'Enmore, NSW',
        'about':
            'Weekly, we contribute 500+ nutritious meals to various Sydney community organizations and charities, aiding individuals in need across Redfern, Waterloo, Surry Hills, and the CBD.',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 3,
        'image': ImageAssets.venueImgSample,
        'state': 'Kabul',
        'country': 'Afghanistan',
        'about':
            'Through partnership Mahboba’s Promise, our initiative extends vital support to widows and children in Kabul by providing essential food items, fostering hope and well-being in their lives.',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 4,
        'image': ImageAssets.venueImgSample,
        'state': 'Colombo',
        'country': 'Sri Lanka',
        'about':
            'Coyoacán Social serves up authentic Mexican street food inspired by Coyoacán – the neighbourhood where Head Chef Roman grew up. For every taco bought, we donate two.',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 5,
        'image': ImageAssets.venueImgSample,
        'state': 'Anything But Humble',
        'country': 'Alexanderia, NSW',
        'about':
            'Kabul Social’s menu features generational recipes and modern street food dishes served across three categories – dumplings, ‘Kabuli burgers’ and Kabuli Snack Packs.',
        'websiteLink': 'https://www.example.com/shop1',
      },
    ];

    List<Map<String, dynamic>> summaryBlog = [
      {
        'id': '1',
        'image': ImageAssets.venueImgSample,
        'name': 'The Social media',
        'blog':
            'We all understand the strain the current cost of living has created, but this strain is felt hardest by those in our community who are already struggling. So, we’re doing something about it. Our meal donation program, The Social Meal, serves up to 2,000 restaurant quality meals weekly to those in our community experiencing food insecurity. It also makes use of perfectly edible food that would otherwise go straight to landfill, repurposing over 800kgs of produce each week. Lovingly cooked by our experienced chefs and our Ability Social students, The Social Meal provides dignity and equality through food. Meals are served at weekly pop-up restaurants in the community to meet people where they are. This ensures community members feel comfortable and safe to share a meal. Because no matter who, where, or why, no one should ever go hungry.'
      },
      {
        'id': '2',
        'image': ImageAssets.venueImgSample,
        'name': 'Training & Education',
        'blog':
            'We all understand the strain the current cost of living has created, but this strain is felt hardest by those in our community who are already struggling. So, we’re doing something about it. Our meal donation program, The Social Meal, serves up to 2,000 restaurant quality meals weekly to those in our community experiencing food insecurity. It also makes use of perfectly edible food that would otherwise go straight to landfill, repurposing over 800kgs of produce each week. Lovingly cooked by our experienced chefs and our Ability Social students, The Social Meal provides dignity and equality through food. Meals are served at weekly pop-up restaurants in the community to meet people where they are. This ensures community members feel comfortable and safe to share a meal. Because no matter who, where, or why, no one should ever go hungry.'
      },
      {
        'id': '3',
        'image': ImageAssets.venueImgSample,
        'name': 'Employment',
        'blog':
            'We all understand the strain the current cost of living has created, but this strain is felt hardest by those in our community who are already struggling. So, we’re doing something about it. Our meal donation program, The Social Meal, serves up to 2,000 restaurant quality meals weekly to those in our community experiencing food insecurity. It also makes use of perfectly edible food that would otherwise go straight to landfill, repurposing over 800kgs of produce each week. Lovingly cooked by our experienced chefs and our Ability Social students, The Social Meal provides dignity and equality through food. Meals are served at weekly pop-up restaurants in the community to meet people where they are. This ensures community members feel comfortable and safe to share a meal. Because no matter who, where, or why, no one should ever go hungry.'
      },
      {
        'id': '4',
        'image': ImageAssets.venueImgSample,
        'name': 'Connection',
        'blog':
            'We all understand the strain the current cost of living has created, but this strain is felt hardest by those in our community who are already struggling. So, we’re doing something about it. Our meal donation program, The Social Meal, serves up to 2,000 restaurant quality meals weekly to those in our community experiencing food insecurity. It also makes use of perfectly edible food that would otherwise go straight to landfill, repurposing over 800kgs of produce each week. Lovingly cooked by our experienced chefs and our Ability Social students, The Social Meal provides dignity and equality through food. Meals are served at weekly pop-up restaurants in the community to meet people where they are. This ensures community members feel comfortable and safe to share a meal. Because no matter who, where, or why, no one should ever go hungry.'
      },
    ];

    return Scaffold(
      appBar: const AppBarScreen(
        title: '',
        isMission: true,
        subScreen: true,
      ),
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
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        for (var summaryData in summaryBlog)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Image.asset(
                                      summaryData['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: Colors.grey)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      summaryData['name']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          letterSpacing: 0.4),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: Colors.grey)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text(
                                      summaryData['blog'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )),
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        for (var donateData in donationLocationApi)
                          VenueCard(
                            id: donateData['id'],
                            image: donateData['image'],
                            name: donateData['state'],
                            venue: donateData['country'],
                            about: donateData['about'],
                            donationScreen: true,
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
      bottomNavigationBar: const BottomNavBar(activeIcon: 3,),
    );
  }
}
