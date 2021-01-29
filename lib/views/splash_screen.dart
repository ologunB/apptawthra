import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BannerAd _bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: admobID);
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
    userDetailsBox = Hive.box(userDetails);

    User user = FirebaseAuth.instance.currentUser;
    IS_LOGGED_IN = user != null;
    Future.delayed(Duration(seconds: 2)).then((value) {
      moveToAndReplace(context, HomeScreen(isLoggedIn: IS_LOGGED_IN));
    });
    super.initState();
  }

  Box userDetailsBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.whiteColor,
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("images/logo.png", height: 120),
          verticalSpaceMedium,
          TypewriterAnimatedTextKit(
            speed: Duration(milliseconds: 500),
            text: ["TWATRHA"],
            textStyle: GoogleFonts.nunito(
                fontSize: 25.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
