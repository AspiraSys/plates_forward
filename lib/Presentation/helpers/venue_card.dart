import 'package:flutter/material.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';
class VenueCard extends StatelessWidget {
  final num id;
  final String name;
  final String image;
  final String venue;
  final String about;
  final String vision;
  final String chefName;
  final String websiteLink;
  final bool donationScreen;

  const VenueCard(
      {super.key,
      required this.id,
      this.name = '',
      this.image = '',
      this.venue = '',
      this.about = '',
      this.vision = '',
      this.chefName = '',
      this.websiteLink = '',
      this.donationScreen = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Container(
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColor.greyColor, width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          image,
                          width: 140,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              ImageAssets.venueImgSample,
                              width: 140,
                              height: 150,
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                                //  color: AppColor.primaryColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColor.primaryColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          venue,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blackColor),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            about,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              donationScreen
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '~ ${chefName.toUpperCase()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColor.blackColor),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch(websiteLink)) {
                                await launch(websiteLink);
                              } else {
                                throw 'Could not launch $websiteLink';
                              }
                            },
                            child: Container(
                              width: 160,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.primaryColor,
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'website & booking'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
