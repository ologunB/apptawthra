import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/widgets/authPasswordInput.dart';
import 'package:apptawthra/widgets/custom_button1.dart';
import 'package:apptawthra/widgets/show_exception_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController old = TextEditingController();
  TextEditingController new1 = TextEditingController();
  TextEditingController new2 = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;

  Future _changePassword(String former, String password) async {
    setState(() {
      isLoading = true;
    });

    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    await _firebaseAuth.signInWithEmailAndPassword(email: FirebaseAuth.instance.currentUser.email, password: former).then((user) {
      user.user.updatePassword(password).then((_) {
        showSnackBar(
            context, "Alert".tr(), "Password successfully changed. Don't forget your password!".tr());

        old.clear();
        new1.clear();
        new2.clear();
        setState(() {
          isLoading = false;
        });
        return true;
      }).catchError((e) {
        showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
        setState(() {
          isLoading = false;
        });
        return true;
      });
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
      setState(() {
        isLoading = false;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Change Password".tr(),
          style: GoogleFonts.nunito(
              fontSize: 18.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
        ),
      ),
      body: LoadingOverlay(
          isLoading: isLoading,
          progressIndicator: CupertinoActivityIndicator(radius: 15),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  AuthPasswordInput(
                    hintText: "Old Password".tr(),
                    controller: old,
                  ),
                  SizedBox(height: 8),
                  AuthPasswordInput(
                    hintText: "New Password".tr(),
                    controller: new1,
                  ),
                  SizedBox(height: 8),
                  AuthPasswordInput(
                    hintText: "Repeat Password".tr(),
                    controller: new2,
                  ),
                  SizedBox(height: 20),
                  CustomButton1(
                    title: "UPDATE".tr(),
                    color: Styles.appPrimaryColor,
                    onPressed: isLoading
                        ? null
                        : () async {
                            _formKey.currentState.save();
                            _formKey.currentState.validate();

                            if (_formKey.currentState.validate()) {
                              _changePassword(old.text, new1.text);
                            }
                          },
                  ),
                  Container(height: 50)
                ],
              ),
            ),
          )),
    );
  }
}
