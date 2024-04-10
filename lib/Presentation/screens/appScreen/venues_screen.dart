import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/venue_card.dart';
import 'package:plates_forward/utils/app_assets.dart';
// import 'package:plates_forward/Utils/app_colors.dart';
// import 'package:plates_forward/Utils/app_routes_path.dart';
// import 'package:plates_forward/utils/app_assets.dart';

class VenueScreen extends StatelessWidget {
  const VenueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> venuesApi = [
      {
        'id': 1,
        'image': ImageAssets.venueImgSample,
        'shopName': 'Kabul Social',
        'venue': 'MetCenter',
        'about':
            'Kabul Social’s menu features generational recipes and modern street food dishes served across three categories – dumplings, ‘Kabuli burgers’ and Kabuli Snack Packs.',
        'vision':
            'My goals when I arrived in Australia were to study English, improve my language, work, and help my family. I also wanted to prove to everyone that women are not only housewives, she can work inside and outside the house. Women are strong, I’m very strong. I’m always improving myself as a mother, a wife, and at my work. I’m very happy. I can do both with the help of Kabul Social.',
        'chefName': 'Roya, Kabul Social Head Chef',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 2,
        'image': ImageAssets.venueImgSample,
        'shopName': 'Colombo Social',
        'venue': 'Enmore, NSW',
        'about':
            'Colombo Social serves up soulful Sri Lankan food and vibrant cocktails while providing employment opportunities, practical experience and training for people seeking asylum.',
        'vision':
            'My goals when I arrived in Australia were to study English, improve my language, work, and help my family. I also wanted to prove to everyone that women are not only housewives, she can work inside and outside the house. Women are strong, I’m very strong. I’m always improving myself as a mother, a wife, and at my work. I’m very happy. I can do both with the help of Kabul Social.',
        'chefName': 'Roya, Kabul Social Head Chef',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 3,
        'image': ImageAssets.venueImgSample,
        'shopName': 'Kyiv Social',
        'venue': 'Chippendale, NSW',
        'about':
            'Kyiv Social showcases authentic and reimagined Ukrainian food and drink while providing employment and training to Ukrainian people recently displaced by the war.',
        'vision':
            'My goals when I arrived in Australia were to study English, improve my language, work, and help my family. I also wanted to prove to everyone that women are not only housewives, she can work inside and outside the house. Women are strong, I’m very strong. I’m always improving myself as a mother, a wife, and at my work. I’m very happy. I can do both with the help of Kabul Social.',
        'chefName': 'Roya, Kabul Social Head Chef',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 4,
        'image': ImageAssets.venueImgSample,
        'shopName': 'Coyoacan Social',
        'venue': 'South Eveleigh, NSW',
        'about':
            'Coyoacán Social serves up authentic Mexican street food inspired by Coyoacán – the neighbourhood where Head Chef Roman grew up. For every taco bought, we donate two.',
        'vision':
            'My goals when I arrived in Australia were to study English, improve my language, work, and help my family. I also wanted to prove to everyone that women are not only housewives, she can work inside and outside the house. Women are strong, I’m very strong. I’m always improving myself as a mother, a wife, and at my work. I’m very happy. I can do both with the help of Kabul Social.',
        'chefName': 'Roya, Kabul Social Head Chef',
        'websiteLink': 'https://www.example.com/shop1',
      },
      {
        'id': 5,
        'image': ImageAssets.venueImgSample,
        'shopName': 'Kabul Social',
        'venue': 'MetCenter',
        'about':
            'Kabul Social’s menu features generational recipes and modern street food dishes served across three categories – dumplings, ‘Kabuli burgers’ and Kabuli Snack Packs.',
        'vision':
            'My goals when I arrived in Australia were to study English, improve my language, work, and help my family. I also wanted to prove to everyone that women are not only housewives, she can work inside and outside the house. Women are strong, I’m very strong. I’m always improving myself as a mother, a wife, and at my work. I’m very happy. I can do both with the help of Kabul Social.',
        'chefName': 'Roya, Kabul Social Head Chef',
        'websiteLink': 'https://www.example.com/shop1',
      },
    ];

    return Scaffold(
      appBar: const AppBarScreen(title: 'Venues'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (var venuData in venuesApi) 
          VenueCard(id: venuData['id'], name: venuData['shopName'], image: venuData['image'], venue: venuData['venue'], about: venuData['about'], vision: venuData['vision'], chefName: venuData['chefName'], websiteLink: venuData['websiteLink'])
        ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(activeIcon: 1,),
    );
  }
}
