import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/views/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: admobID);
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(userDetails);
/*
  Admob.initialize();
 ;*/

  runApp(EasyLocalization(
    child: MyApp(),
    saveLocale: true,
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
    ],
    path: "lang",
  ));
}

const userDetails = 'user_details';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale("en", "US"),
        Locale("ar", "DZ"),
      ],
      locale: Locale("en", "US"),
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
