// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:plates_forward/Utils/app_colors.dart';
// import 'package:plates_forward/Utils/app_routes_path.dart';
// import 'package:plates_forward/utils/app_assets.dart';

// class AppBarScreen extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool subScreen;
//   final bool isProfile;
//   final bool isMission;
//   final bool isDonatSub;

//   const AppBarScreen({
//     super.key,
//     required this.title,
//     this.subScreen = false,
//     this.isProfile = false,
//     this.isMission = false,
//     this.isDonatSub = false,
//   });

//   void initState() {
//     profileData();
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(100);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 2, bottom: 3),
//       height: 100,
//       child: AppBar(
//         title: Padding(
//           padding: subScreen
//               ? const EdgeInsets.only(left: 0)
//               : const EdgeInsets.only(left: 20),
//           child: Text(
//             isMission ? '' : title,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//           ),
//         ),
//         backgroundColor: AppColor.whiteColor,
//         leadingWidth: subScreen ? 100 : 0,
//         leading: subScreen
//             ? Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 20,
//                       ),
//                       onPressed: () {
//                         isDonatSub
//                             ? Navigator.of(context)
//                                 .pushNamed(RoutePaths.homeRoute)
//                             : Navigator.of(context).pop();
//                       },
//                     ),
//                     const SizedBox(width: 4),
//                     const Text(
//                       "Back",
//                       style: TextStyle(
//                           color: AppColor.blackColor,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500),
//                     )
//                   ],
//                 ),
//               )
//             : Container(),
//         actions: isProfile
//             ? [Container()]
//             : [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.share,
//                     size: 30,
//                     color: AppColor.primaryColor,
//                   ),
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return BottomSheet(
//                           backgroundColor: AppColor.whiteColor,
//                           onClosing: () {},
//                           builder: (BuildContext context) {
//                             return SizedBox(
//                               height: 350,
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 40, horizontal: 10),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       const Text(
//                                         'Spread the goodness!',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                       const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 42, vertical: 10),
//                                         child: Text(
//                                           'Share your donation with friends and inspire them to join in!',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           const Column(
//                                             children: [
//                                               Icon(
//                                                 Icons.facebook,
//                                                 color: AppColor.primaryColor,
//                                                 size: 24,
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 10),
//                                                 child: Text("Facebook",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500)),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             children: [
//                                               Image.asset(
//                                                 ImageAssets.threadIcon,
//                                                 width: 24,
//                                                 height: 24,
//                                               ),
//                                               const Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 10),
//                                                 child: Text("Twitter",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500)),
//                                               ),
//                                             ],
//                                           ),
//                                           const Column(
//                                             children: [
//                                               Icon(
//                                                 Icons.telegram,
//                                                 color: AppColor.primaryColor,
//                                                 size: 24,
//                                               ),
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 10),
//                                                 child: Text("Telegram",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500)),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 70),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Image.asset(
//                                                   ImageAssets.whatsappIcon,
//                                                   width: 24,
//                                                   height: 24,
//                                                 ),
//                                                 const Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                                   child: Text("WhatsApp",
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.w500)),
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Image.asset(
//                                                   ImageAssets.messageIcon,
//                                                   width: 24,
//                                                   height: 24,
//                                                 ),
//                                                 const Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                                   child: Text("Message",
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.w500)),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 GestureDetector(
//                   onTap: () =>
//                       Navigator.of(context).pushNamed(RoutePaths.profileRoute),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: CircleAvatar(
//                       backgroundImage:
//                           AssetImage(ImageAssets.placeholderProfile),
//                       radius: 45,
//                     ),
//                   ),
//                 )
//               ],
//         titleSpacing: 0,
//         centerTitle: subScreen,
//       ),
//     );
//   }

//   void profileData() async {
//     String? userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       DocumentSnapshot<Map<String, dynamic>> userDetails =
//           await FirebaseFirestore.instance
//               .collection('userSignup')
//               .doc(userId)
//               .get();

//       print('data of pp ${userDetails['profilePicture']}');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class AppBarScreen extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool subScreen;
  final bool isProfile;
  final bool isMission;
  final bool isDonatSub;

  const AppBarScreen({
    super.key,
    required this.title,
    this.subScreen = false,
    this.isProfile = false,
    this.isMission = false,
    this.isDonatSub = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AppBarScreenState createState() => _AppBarScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppBarScreenState extends State<AppBarScreen> {
  late ImageProvider<Object> profilePicture =
      const AssetImage(ImageAssets.authLogo);

  @override
  void initState() {
    super.initState();
    profileData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      height: 100,
      child: AppBar(
        title: Padding(
          padding: widget.subScreen
              ? const EdgeInsets.only(left: 0)
              : const EdgeInsets.only(left: 20),
          child: Text(
            widget.isMission ? '' : widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        
        backgroundColor: AppColor.whiteColor,
        leadingWidth: widget.subScreen ? 100 : 0,
        leading: widget.subScreen
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                      ),
                      onPressed: () {
                        /*widget.isDonatSub
                            ? Navigator.of(context)
                                .pushNamed(RoutePaths.homeRoute)*/
                          // Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Back",
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            : Container(),
        actions: widget.isProfile
            ? [Container()]
            : [
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    size: 30,
                    color: AppColor.primaryColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheet(
                          backgroundColor: AppColor.whiteColor,
                          onClosing: () {},
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 350,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        'Spread the goodness!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 42, vertical: 10),
                                        child: Text(
                                          'Share your donation with friends and inspire them to join in!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Column(
                                            children: [
                                              Icon(
                                                Icons.facebook,
                                                color: AppColor.primaryColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text("Facebook",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Image.asset(
                                                ImageAssets.threadIcon,
                                                width: 24,
                                                height: 24,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text("Twitter",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                          ),
                                          const Column(
                                            children: [
                                              Icon(
                                                Icons.telegram,
                                                color: AppColor.primaryColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text("Telegram",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 70),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Image.asset(
                                                  ImageAssets.whatsappIcon,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text("WhatsApp",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Image.asset(
                                                  ImageAssets.messageIcon,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text("Message",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(RoutePaths.profileRoute),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Container(
                      width: 45,
                      height: 45,
                      child: CircleAvatar(
                        backgroundImage: profilePicture,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              ],
        titleSpacing: 0,
        centerTitle: widget.subScreen,
      ),
    );
  }

  Future<void> profileData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection('userSignup')
              .doc(userId)
              .get();

      String? profilePictureUrl = userDetails['profilePicture'];
      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        setState(() {
          profilePicture = NetworkImage(profilePictureUrl);
        });
      }
    }
  }
}
