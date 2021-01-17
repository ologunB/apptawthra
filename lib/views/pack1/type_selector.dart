import 'dart:convert';
import 'dart:io';

import 'package:apptawthra/models/package.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/checkoutpage.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/custom_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';
import '../error_util.dart';
import '../round_clipper.dart';
import 'create_tweet.dart';

class TypeSelector1 extends StatefulWidget {
  @override
  _TypeSelectorState createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector1> {
  String programSelected;
  bool isLoading = false;
  int selectedProgram;

  @override
  Widget build(BuildContext context) {
    selectedProgram =
        getPackages()[0].programTitles.indexWhere((element) => element == programSelected);
    return Scaffold(
      backgroundColor: Styles.appCanvasColor,
      appBar: AppBar(
        backgroundColor: Styles.yellowColor,
        elevation: 0,
        title: Text(
          getPackages()[0].packageTitle.tr(),
          style: GoogleFonts.nunito(
              fontSize: 18.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 3,
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      color: Styles.yellowColor,
                    ),
                  )),
              Expanded(
                child: Container(),
                flex: 10,
              )
            ],
          ),
          LoadingOverlay(
              progressIndicator: CupertinoActivityIndicator(radius: 15),
              isLoading: isLoading,
              color: Colors.grey,
              child: Center(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Styles.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)
                              ],
                            ),
                            child: Image.asset(
                              getPackages()[0].imageUrl,
                              height: 70,
                              width: 70,
                            ))
                      ],
                    ),
                    verticalSpaceMedium,
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 25,
                              spreadRadius: 5,
                              offset: Offset(0.0, 2.0)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "Choose a program that suits you".tr(),
                              style: GoogleFonts.nunito(
                                  fontSize: 16.0,
                                  color: Styles.colorBlack,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Styles.appBackground,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                hint: Text(
                                  "Select...".tr(),
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.0,
                                      color: Styles.colorBlack,
                                      fontWeight: FontWeight.w600),
                                ),
                                value: programSelected,
                                underline: SizedBox(),
                                iconEnabledColor: Colors.blueAccent,
                                dropdownColor: Styles.whiteColor,
                                items: getPackages()[0].programTitles.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  programSelected = value;

                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: programSelected == null
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Program $programSelected".tr() + ": ",
                                                style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: getPackages()[0]
                                                        .programDescs[selectedProgram]
                                                        .tr(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Styles.appBackground,
                                          ),
                                          padding: EdgeInsets.all(12),
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Price: ".tr(),
                                                style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: "\$" +
                                                        getPackages()[0]
                                                            .programPrices[selectedProgram],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
      bottomNavigationBar: Container(
        color: Styles.appCanvasColor,
        padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 60, top: 15),
        child: CustomButton(
            color: programSelected == null ? Colors.grey : Styles.appPrimaryColor,
            title: "PAY NOW".tr(),
            onPressed: programSelected == null
                ? null
                : isLoading
                    ? null
                    : () async {
                        moveTo(context, CreateTweetScreen1(program: selectedProgram));
                        /*    showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                                title: "Confirmation".tr(),
                                body: Text(
                                  "Are you sure you want to pay for the program?".tr(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                onClicked: () async {
                                  await payNow(selectedProgram);
                                },
                                context: context));*/
                      }),
      ),
    );
  }

  Future payNow(int program) async {
    Navigator.pop(context);
    await createCheckout().then((sessionId) {
      isLoading = false;
      setState(() {});
      moveTo(context,
          CheckoutPage(sessionId: sessionId, successView: CreateTweetScreen1(program: program)));
    }).catchError((e) {
      print(e);
      print(e.message);
    });
  }

  Future<String> createCheckout() async {
    final auth = 'Basic ' +
        base64Encode(utf8.encode(
            'sk_test_51Hzo6FLaLQ9qavQZ9keJeT43ngEvesPUAda0FvlSxcgD2vnukSHFmqlj4DtoagIMrefNaxST4LWnDudZCJTKCz1e00BflFym5l'));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          'price': "price_1Hzo7iLaLQ9qavQZMhroeHEo",
          'quantity': 1,
        }
      ],
      'mode': 'payment',
      'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
      'cancel_url': 'https://cancel.com/',
    };

    try {
      isLoading = true;
      setState(() {});
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      print(result);
      isLoading = false;
      setState(() {});
      return result.data['id'];
    } catch (e) {
      isLoading = false;
      setState(() {});

      print(e);
      await showDialog(
          context: context,
          builder: (context) => CustomDialog(
                title: "Error".tr(),
                onClicked: () {
                  Navigator.pop(context);
                },
                body: Text(
                  DioErrorUtil.handleError(e) + "\n" + "Close".tr() + "?",
                  style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ));
      print(e.response);
      throw e;
    }
  }
}
