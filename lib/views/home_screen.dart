import 'package:apptawthra/models/package.dart';
import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/round_clipper.dart';
import 'package:apptawthra/views/signin_page.dart';
import 'package:apptawthra/views/signup_page.dart';
import 'package:apptawthra/views/user_profile.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:translator/translator.dart';

class HomeScreen extends StatefulWidget {
  bool isLoggedIn = IS_LOGGED_IN;

  HomeScreen({this.isLoggedIn});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int presentLang;
  //final translator = GoogleTranslator();

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  String appDesc = "";

  void getDetails() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("Utils").doc("Details").get();
    String de = doc.data()["App Description"];

    appDesc = de;
    setState(() {});

  /*  await translator
        .translate(de, to: EasyLocalization.of(context).locale.languageCode)
        .then((value) {
      appDesc = value.text;
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("images/logo.png", height: 50),
            horizontalSpaceSmall,
            Text(
              "TWATRHA",
              style: GoogleFonts.nunito(
                  fontSize: 20.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Styles.yellowColor,
        actions: [
          GestureDetector(
              onTap: () {
                moveTo(context, UserProfileScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CachedImage(size: 40, imageUrl: "ll"),
              )),
          horizontalSpaceSmall,
          GestureDetector(
            onTap: () {
              selectLng(context);
            },
            child: Row(
              children: [
                Text(
                  EasyLocalization.of(context).locale.languageCode.toUpperCase(),
                  style: GoogleFonts.nunito(
                      fontSize: 14.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          )
        ],
        bottom: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Styles.yellowColor,
          title: Text(
            "selectSub".tr(),
            style: GoogleFonts.nunito(
                fontSize: 16.0, color: Styles.colorBlack, fontWeight: FontWeight.w600),
          ),
        ),
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
                flex: 8,
              )
            ],
          ),
          GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.2),
              itemBuilder: (context, index) {
                return packageItem(context, index);
              }),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Description".tr() + "\n" + appDesc,
                      style: TextStyle(
                          fontSize: 13.0, color: Styles.colorBlack, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            widget.isLoggedIn
                ? SizedBox()
                : Row(
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Styles.yellowColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                moveTo(context, SigninPage());
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 2),
                                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "LOGIN".tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )),
                      )),
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Styles.yellowColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                moveTo(context, SignupPage());
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 2),
                                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "SIGNUP".tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )),
                      )),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget packageItem(context, index) {
    return GestureDetector(
      onTap: () {
        showPackageDesc(context, index);
      },
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(getPackages()[index].imageUrl, height: 60, width: 60),
              ),
              verticalSpaceSmall,
              Text(
                getPackages()[index].packageTitle.tr(),
                style: TextStyle(
                    fontSize: 16.0, color: Styles.colorBlack, fontWeight: FontWeight.w600),
              )
            ],
          )),
    );
  }

  String packDes = "";

  getDescTrans(int i, _setState) async {
    String de = getPackages()[i].packageDesc;
    packDes = de;
    _setState(() {});

 /*   await translator
        .translate(de, from: 'en', to: EasyLocalization.of(context).locale.languageCode)
        .then((value) {
      packDes = value.text;
      _setState(() {});
    });*/
  }

  showPackageDesc(context, index) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSnackBar(context, "Error", "You have to log in to purchase a package");
      return;
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, _setState) {
          getDescTrans(index, _setState);

          return ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getPackages()[index].packageTitle.tr(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey, height: 0),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Description".tr(),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      packDes,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomButton(
                        title: "PROCEED".tr(),
                        onPressed: () {
                          Navigator.pop(context);
                          moveTo(context, getPackages()[index].typeWidget);
                        }),
                  ),
                  Container(height: 50)
                ],
              );
            }));
  }

  selectLng(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Choose Language".tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(builder: (context, _setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpaceSmall,
                  GestureDetector(
                    onTap: () {
                      EasyLocalization.of(context).locale = Locale('en', 'US');
                      presentLang = 0;
                      getDetails();
                      _setState(() {});
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: presentLang == 0 ? Colors.grey[300] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "English",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Styles.colorBlack,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  GestureDetector(
                    onTap: () {
                      presentLang = 1;
                      getDetails();
                      EasyLocalization.of(context).locale = Locale('ar', 'DZ');
                      _setState(() {});
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: presentLang == 1 ? Colors.grey[300] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Arabic",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Styles.colorBlack,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))
                    ],
                  )
                ],
              );
            }),
          );
        });
  }
}
