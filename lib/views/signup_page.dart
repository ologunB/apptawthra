import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/widgets/authEmailInput.dart';
import 'package:apptawthra/widgets/authNameInput.dart';
import 'package:apptawthra/widgets/authPasswordInput.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/show_exception_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Styles.tintColor2));
    return GestureDetector(
      onTap: () {
        offKeyboard(context);
      },
      child: LoadingOverlay(
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        isLoading: isLoading,
        color: Styles.appLightPrimaryColor,
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Styles.whiteColor,
            appBar: AppBar(elevation: 0),
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 5,
                    child: SvgPicture.asset(
                      "images/signup.svg",
                      width: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Get Started".tr(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: Styles.colorBlack),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                  SizedBox(height: 8),
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
                    "Create a new Account".tr(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Styles.colorBlack,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                AuthNameInput(
                  hintText: "Name".tr(),
                  controller: nameController,
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
                SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Have Account? Sign In".tr(),
                          style: TextStyle(color: Styles.colorBlack, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomButton(
                        title: "SIGNUP".tr(),
                        onPressed: () {
                          signUp();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    _formKey.currentState.save();
    _formKey.currentState.validate();

    if (!_formKey.currentState.validate()) {
      return;
    }
    offKeyboard(context);

    setState(() {
      isLoading = true;
    });
    await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      User user = value.user;

      if (value.user != null) {
        user.sendEmailVerification().then((v) {
          Map<String, Object> mData = Map();
          mData.putIfAbsent("Name", () => nameController.text);
          mData.putIfAbsent("Email", () => emailController.text);
          mData.putIfAbsent("Uid", () => user.uid);
          mData.putIfAbsent("Timestamp", () => DateTime.now().millisecondsSinceEpoch);

          FirebaseFirestore.instance.collection("All").doc(user.uid).set(mData).then((val) {
            emailController.clear();
            passwordController.clear();
            nameController.clear();

            showSnackBar(context, "ALERT".tr(), "User created, Check email for verification.".tr());

            setState(() {
              isLoading = false;
            });
            offKeyboard(context);
          }).catchError((e) {
            showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
            setState(() {
              isLoading = false;
            });
          });
        }).catchError((e) {
          showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
      setState(() {
        isLoading = false;
      });
      return;
    });
  }
}
