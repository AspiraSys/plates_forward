import 'package:flutter/material.dart';
import 'package:plates_forward/Utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class ExpansionTiles extends StatefulWidget {
  final List<Map<String, dynamic>> donateData;

  const ExpansionTiles({
    super.key,
    required this.donateData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTiles> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.donateData.length,
      itemBuilder: (context, int index) {
        final donation = widget.donateData[index];

        // Extracting data from the donation object
        final images = donation['image'];
        final title = donation['title'];
        final date = donation['date'];
        final country = donation['country'];
        final orders = donation['order'];

        final totalOrderIndex =
            orders.indexWhere((order) => order['item'] == 'Total');
        final totalOrder =
            totalOrderIndex != -1 ? orders[totalOrderIndex] : null;
        final totalCost = totalOrder != null ? totalOrder['cost'] : '';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: AppColor.primaryColor),
          child: ExpansionTile(
            enabled: country.length <= 1 ? false : true,
            
            iconColor: country.length <= 1 ? Colors.transparent  : AppColor.whiteColor,
            collapsedIconColor: country.length <= 1 ? Colors.transparent  : AppColor.whiteColor,
            textColor: AppColor.whiteColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: AppColor.whiteColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          images,
                          width: 20,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 2,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              title.toString(),
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.circle_rounded,
                                color: AppColor.whiteColor,
                                size: 4,
                              ),
                            ),
                            Text(
                              date.toString(),
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          if (country.length > 1)
                            Text(
                              country
                                  .map((country) => country['city'].toString())
                                  .join(', '),
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
                          if (country.length <= 1) ...[
                            Text(
                              country
                                  .map((country) => country['city'].toString())
                                  .join(', '),
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.circle_rounded,
                                color: AppColor.whiteColor,
                                size: 4,
                              ),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: '${orders.length}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.whiteColor,
                                    ),
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: ' Meals',
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1)),
                                ])),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.circle_rounded,
                                color: AppColor.whiteColor,
                                size: 4,
                              ),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'Total',
                                    style: const TextStyle(
                                        color: AppColor.whiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: ' \$$totalCost',
                                      style: const TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1)),
                                ])),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    size: 20,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheet(
                          backgroundColor: AppColor.navBackgroundColor,
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
              ],
            ),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 2, color: AppColor.whiteColor),
                        bottom:
                            BorderSide(width: 2, color: AppColor.whiteColor))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Your Order',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      for (var donationOrder in orders)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: donationOrder == orders.last
                                ? BorderSide.none
                                : const BorderSide(
                                    width: 1, color: AppColor.greyColor),
                          )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                donationOrder['item'].toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '\$${donationOrder['cost'].toString()}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   decoration: const BoxDecoration(
                      //       border: Border(
                      //           bottom: BorderSide(
                      //               width: 1, color: AppColor.greyColor))),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Saumon a la Parisienne',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColor.whiteColor,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //       Text(
                      //         '\$32.00',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColor.whiteColor,
                      //             fontWeight: FontWeight.w600),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 15),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'Total',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColor.whiteColor,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //       Text(
                      //         '\$32.00',
                      //         style: TextStyle(
                      //             fontSize: 14,
                      //             color: AppColor.whiteColor,
                      //             fontWeight: FontWeight.w600),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "You Donated Meals",
                        style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var orderCountry in country)
                          Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColor.whiteColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Image.asset(
                                      orderCountry['image'],
                                      width: 24,
                                      height: 32,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(
                                    orderCountry['city'].toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        // Container(
                        //     width: 60,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(30),
                        //         color: AppColor.whiteColor),
                        //     child: Column(
                        //       children: [
                        //         Image.asset(
                        //           ImageAssets.sydneyIcon,
                        //           width: 24,
                        //           height: 32,
                        //           fit: BoxFit.contain,
                        //         ),
                        //         const Text(
                        //           'Sydney',
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: AppColor.primaryColor,
                        //               fontWeight: FontWeight.w600),
                        //         )
                        //       ],
                        //     )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      // decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(6)),
      //     color: AppColor.primaryColor),
    );
  }
}
