import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/models/user_activity.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_request.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'dart:io';

import 'package:plates_forward/utils/app_assets.dart';

class AddOrderDialog extends StatefulWidget {
  final Function(bool) updateOrderState;
  final VoidCallback onSuccess;

  const AddOrderDialog({
    super.key,
    required this.updateOrderState,
    required this.onSuccess,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddOrderDialogState createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final TextEditingController _orderController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String errorText = '';
  var square = SquareFunction();

  @override
  void dispose() {
    _orderController.dispose();
    super.dispose();
  }

  Future<void> saveUserTransactionData(RetrieveOrderResponse result) async {
    List<ListItem> lineItems = result.order?.lineItems?.map((item) {
          return ListItem(
            name: item.name ?? '',
            uid: item.uid ?? '',
            amount: item.basePriceMoney?.amount ?? 0,
            quantity: item.quantity ?? '',
          );
        }).toList() ??
        [];

    num totalAmount = result.order?.netAmounts?.totalMoney?.amount ?? 0;

    UserActivityData userActivityData = UserActivityData(
      id: result.order?.id ?? '',
      locationId: result.order?.locationId ?? '',
      createdAt: result.order?.createdAt ?? '',
      totalAmount: totalAmount,
      lineItems: lineItems,
      type: 0
    );

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    if (user != null) {
      final String userId = user.uid;

      await firestore.collection("userTransaction").doc(userId).set({
        'userActivityData': FieldValue.arrayUnion([userActivityData.toJson()])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully added to Impact',
            style: TextStyle(color: AppColor.whiteColor),
          ),
          duration: Duration(seconds: 5),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        widget.updateOrderState(false);
        Navigator.pop(context);
      });
    } else {
      print("User not authenticated");
    }
  }

  Future<void> handleOrder() async {
    final String orderId = _orderController.text;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      print("User not authenticated");
      return;
    }

    final response = await square.retrieveOrder(
        orderId: RetrieveOrderRequest(orderId: orderId));

    if (_orderController.text.isEmpty) {
      setState(() {
        errorText = 'Invalid order ID';
      });
      return;
    } else if (response is RetrieveOrderResponse) {
      if (response.errors != null) {
        final errorDetail = response.errors![0].detail;
        setState(() {
          errorText = errorDetail!;
        });
        return;
      } else if (response.order == null) {
        // If there is no data in the order, show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'There is no data in the orderId',
              style: TextStyle(color: AppColor.whiteColor),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      
      else {
        final String userUid = user.uid;
        final CollectionReference userTransactionCollection =
            FirebaseFirestore.instance.collection('userTransaction');

        DocumentSnapshot<Object?> userTransactionDocumentSnapshot =
            await userTransactionCollection.doc(userUid).get();

        if (userTransactionDocumentSnapshot.exists) {
          Map<String, dynamic> userData =
              userTransactionDocumentSnapshot.data() as Map<String, dynamic>;

          List<Map<String, dynamic>> userActivityDataList =
              (userData['userActivityData'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .toList();
          bool orderIdFound = false;
          for (var activity in userActivityDataList) {
            var idValue = activity['id'];
            if (idValue == orderId) {
              orderIdFound = true;
              break;
            }
          }
          if (orderIdFound) {
            setState(() {
              errorText = 'OrderId is already exists';
            });
          } else {
            await saveUserTransactionData(response);
            _orderController.text = '';
            setState(() {
              errorText = '';
            });
            widget.onSuccess();
          }
        } else {
          await saveUserTransactionData(response);
          _orderController.text = '';
          setState(() {
            errorText = '';
          });
          widget.onSuccess();
        }
      }
    }
  }

  Future<void> _scanAndSetReceipt(BuildContext context) async {
    // Show options to choose between gallery and camera
    final imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: AppColor.navBackgroundColor),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  size: 25,
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (imageSource == null) {
      return;
    }

    final XFile? image = await _picker.pickImage(source: imageSource);

    if (image == null) {
      return;
    }

    final inputImage = InputImage.fromFile(File(image.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    textRecognizer.close();
    String receiptValue = extractReceiptValue(recognizedText.text);
    setState(() {
      _orderController.text = receiptValue;
    });
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return ScannerDialog(
    //       image: FileImage(File(image.path)),
    //       recognizedText: recognizedText.text,
    //     );
    //   },
    // );
  }

  String extractReceiptValue(String text) {
    final pattern = RegExp(r'Receipt:\s*(\S+)');
    final match = pattern.firstMatch(text);
    return match != null ? match.group(1) ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.navBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Add your Order'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      widget.updateOrderState(false);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.blackColor,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.whiteColor,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InputBox(
                      labelText: 'Enter Receipt / Order Number',
                      inputType: 'text',
                      inputController: _orderController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 10),
                  child: GestureDetector(
                    onTap: () => _scanAndSetReceipt(context),
                    child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            AppColor.primaryColor, BlendMode.srcIn),
                        child: Image.asset(
                          ImageAssets.scannerIcon,
                          width: 30,
                          height: 30,
                        )),

                    // Image.asset(ImageAssets.scannerIcon, width: 30, height: 30,)
                    // const Icon(
                    //   Icons.camera_sharp,
                    //   color: AppColor.primaryColor,
                    //   size: 35,
                    // ),
                  ),
                ),
              ],
            ),
            if (errorText.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.redColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            ButtonBox(
              buttonText: 'Fetch Order',
              fillColor: true,
              onPressed: handleOrder,
            ),
          ],
        ),
      ),
    );
  }
}
