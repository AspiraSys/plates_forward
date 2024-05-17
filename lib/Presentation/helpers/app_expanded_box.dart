import 'package:flutter/material.dart';
import 'package:plates_forward/Utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:intl/intl.dart';

class ExpansionTiles extends StatefulWidget {
  final List<Map<String, dynamic>> donateData;
  final List<Map<String, dynamic>> orderData;

  const ExpansionTiles({
    super.key,
    required this.donateData,
    required this.orderData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTiles> {
  @override
  Widget build(BuildContext context) {
    String formatDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yy').format(dateTime);
    }


    if (widget.donateData.isEmpty || widget.orderData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
          strokeWidth: 3,
        ),
      );
    }

    int itemCount = widget.donateData.length < widget.orderData.length
        ? widget.donateData.length
        : widget.orderData.length;

    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, int index) {
        final donation = widget.donateData[index];
        final ordering = widget.orderData[index];

        final images = donation['venueImage'];
        final secondaryImages = donation['secondaryVenueImage'];
        final title = donation['venueName'];
        final title2 = donation['secondaryVenueName'];
        final date = formatDate(ordering['createdAt'].toString());
        final orders = ordering['lineItems'];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: AppColor.primaryColor),
          child: ExpansionTile(
            trailing: orders.length <= 1 ? const SizedBox.shrink() : null,
            enabled: orders.length <= 1 ? false : true,
            iconColor:
                orders.length < 1 ? AppColor.primaryColor : AppColor.whiteColor,
            collapsedIconColor:
                orders.length < 1 ? AppColor.primaryColor : AppColor.whiteColor,
            textColor: AppColor.whiteColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Image.network(
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
                              '${title.toString()} Social',
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
                              date,
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      if (orders != null && orders.length <= 1)
                        for (var donationOrder in orders)
                          Row(
                            children: [
                              Text(
                                title,
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
                                      text: int.parse(donationOrder['quantity'])
                                          .toString(),
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
                                      text: 'Total ',
                                      style: const TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'A\$ ${(donationOrder['amount'] * int.parse(donationOrder['quantity'])).toString()}',
                                        style: const TextStyle(
                                            color: AppColor.whiteColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1)),
                                  ])),
                            ],
                          )
                      else
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
                            Text(
                              ' , $title2',
                              style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1),
                            ),
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
              if (ordering != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 2, color: AppColor.whiteColor),
                          bottom: BorderSide(
                              width: 2, color: AppColor.whiteColor))),
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
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1, color: AppColor.greyColor),
                            )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      donationOrder['name'].toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'A\$ ${(donationOrder['amount'] * int.parse(donationOrder['quantity'])).toString()}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'A\$ ${ordering['totalAmount'].toString()}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
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
                                  child: Image.network(
                                    images,
                                    width: 24,
                                    height: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )),
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
                                  child: Image.network(
                                    secondaryImages,
                                    width: 24,
                                    height: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  title2,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
