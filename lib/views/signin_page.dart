import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/home_screen.dart';
import 'package:apptawthra/views/signup_page.dart';
import 'package:apptawthra/widgets/authEmailInput.dart';
import 'package:apptawthra/widgets/authPasswordInput.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/custom_button1.dart';
import 'package:apptawthra/widgets/show_exception_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgetPassController = TextEditingController();
  bool isLoading = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Styles.appBackground));
    return GestureDetector(
      onTap: () {
        offKeyboard(context);
      },
      child: LoadingOverlay(
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        isLoading: isLoading,
        color: Styles.appLightPrimaryColor,
        child: Scaffold(
            appBar: AppBar(elevation: 0),
            backgroundColor: Styles.whiteColor,
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 3,
                        child: SvgPicture.asset(
                          "images/login_img.svg",
                          width: 250,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Welcome Back".tr(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.colorBlack),
                            ),
                          ],
                          mainAxisSize: MainAxisSize.max,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
            resizeToAvoidBottomPadding: false,
            bottomNavigationBar: bottomSheet(context)),
      ),
    );
  }

  Widget bottomSheet(context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
              color: Styles.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Login to your Account".tr(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Styles.colorBlack,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                AuthEmailInput(
                  hintText: "Email".tr(),
                  controller: emailController,
                ),
                SizedBox(height: 8),
                AuthPasswordInput(
                  hintText: "Password".tr(),
                  controller: passwordController,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          forgetPassword(context);
                        },
                        child: Text(
                          "Forgot Password?".tr(),
                          style: TextStyle(color: Styles.colorBlack, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomButton1(
                            color: Styles.appPrimaryColor,
                            title: "LOGIN".tr(),
                            onPressed: () {
                              signIn(context);
                            }),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: CustomButton1(
                            color: Colors.green,
                            title: "SIGNUP".tr(),
                            onPressed: () {
                              moveTo(context, SignupPage());
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  forgetPassword(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: myBox30Edge,
      context: context,
      builder: (context) => Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // shrinkWrap: true,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter your email".tr(),
                  style: TextStyle(
                      fontSize: 20, color: Styles.appPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              Material(
                child: AuthEmailInput(
                  hintText: "Email".tr(),
                  controller: forgetPassController,
                ),
              ),
              SizedBox(height: 8),
              CustomButton(
                  title: "RESET PASSWORD".tr(),
                  onPressed: () {
                    resetEmail();
                  }),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  void signIn(context) async {
    _formKey.currentState.save();
    _formKey.currentState.validate();

    if (!_formKey.currentState.validate()) {
      return;
    }

    offKeyboard(context);
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) {
      User user = value.user;

      if (value.user != null) {
        if (!value.user.emailVerified) {
          setState(() {
            isLoading = false;
          });

          showSnackBar(context, "Alert".tr(), "Email not verified".tr());

          _firebaseAuth.signOut();
          return;
        }
        FirebaseFirestore.instance.collection('All').doc(user.uid).get().then((document) {

          IS_LOGGED_IN = true;
          moveToAndReplace(context, HomeScreen(isLoggedIn: IS_LOGGED_IN));
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
          showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _firebaseAuth.signOut();
      }
      return;
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      _firebaseAuth.signOut();
      showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());

      return;
    });
  }

  void putInDB(String name) async {
    final Box userDetailsBox = Hive.box(userDetails);
    userDetailsBox.put("name", name);
    setState(() {});
  }

  void resetEmail() async {
    if (forgetPassController.text.isEmpty) {
      showSnackBar(context, "Error".tr(), "Email cannot be empty".tr());
      return;
    }
    Navigator.pop(context);
    offKeyboard(context);
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth.sendPasswordResetEmail(email: forgetPassController.text).then((value) {
      setState(() {
        isLoading = false;
      });
      forgetPassController.clear();

      showSnackBar(context, "Alert".tr(), "Reset email sent, Check mail".tr());
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      showExceptionAlertDialog(context: context, title: "Error".tr(), exception: e);
    });
  }
}
