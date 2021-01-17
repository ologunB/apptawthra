import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/change_password.dart';
import 'package:apptawthra/views/home_screen.dart';
import 'package:apptawthra/views/signin_page.dart';
import 'package:apptawthra/views/subscribed_packages.dart';
import 'package:apptawthra/widgets/authEmailInput.dart';
import 'package:apptawthra/widgets/custom_dialog.dart';
import 'package:apptawthra/widgets/network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'images_library.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email;
  String avatar = "", name = "";
  bool isLoading = true;

  void getDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('All')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    name = doc.data()["Name"];
    email = TextEditingController(text: doc.data()["Email"]);
    avatar = doc.data()["Avatar"];

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    IS_LOGGED_IN ? getDetails() : () {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IS_LOGGED_IN
        ? Scaffold(
            backgroundColor: Styles.appCanvasColor,
            appBar: AppBar(
              backgroundColor: Styles.yellowColor,
              title: Text(
                IS_LOGGED_IN ? "Subscriber".tr() : "No User Logged in!".tr(),
                style: GoogleFonts.nunito(
                    fontSize: 16.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            bottomNavigationBar: Container(height: 50),
            body: LoadingOverlay(
              isLoading: isLoading,
              progressIndicator: CupertinoActivityIndicator(radius: 15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CachedImage(size: 70, imageUrl: "kk"),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: ListView(
                          children: [
                            AuthEmailInput(
                                hintText: "Email".tr(), controller: email, enabled: false),
                            verticalSpaceSmall,
                            InkWell(
                              onTap: () {
                                moveTo(context, ImagesLibrary());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(Icons.library_add, color: Styles.colorBlack),
                                        horizontalSpaceMedium,
                                        Text(
                                          'Images Library'.tr(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Styles.colorBlack),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            verticalSpaceSmall,
                            InkWell(
                              onTap: () async {
                                moveTo(context, SubscribedPackages());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(Icons.subject, color: Styles.colorBlack),
                                        horizontalSpaceMedium,
                                        Text(
                                          'Subscribed Packages'.tr(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Styles.colorBlack),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            verticalSpaceSmall,
                            InkWell(
                              onTap: () async {
                                moveTo(context, ChangePassword());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(Icons.edit, color: Styles.colorBlack),
                                        horizontalSpaceMedium,
                                        Text(
                                          'Change Password'.tr(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Styles.colorBlack),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            verticalSpaceSmall,
                            InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                      title: "Confirmation".tr(),
                                      body: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Are you sure you want to logout?".tr(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      onClicked: () {
                                        FirebaseAuth.instance.signOut().then((a) {
                                          Hive.deleteBoxFromDisk(userDetails);
                                          moveToAndReplace(context, HomeScreen(isLoggedIn: false));
                                        });
                                      },
                                      context: context),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black12)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.logout, color: Colors.red),
                                        horizontalSpaceMedium,
                                        Text(
                                          'Logout'.tr(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        : SigninPage();
  }
}
