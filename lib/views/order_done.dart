import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/home_screen.dart';
import 'package:apptawthra/widgets/custom_button1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDonePage extends StatelessWidget {
  final String package;
  final String program;
  final String from;
  final String account;

  const OrderDonePage(
      {Key key, this.package = "", this.program = "", this.from = "", this.account = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToAndReplace(context, HomeScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Styles.appCanvasColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Styles.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 20, spreadRadius: 5)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "TWEET SCHEDULED",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      "images/description.png",
                      height: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        package,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        program,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "From: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                      Text(
                        from,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Account Type: ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        account,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Styles.appPrimaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(18.0),
              child: CustomButton1(
                  color: Styles.yellowColor,
                  title: "DONE",
                  onPressed: () {
                    moveToAndReplace(context, HomeScreen(isLoggedIn: true));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
