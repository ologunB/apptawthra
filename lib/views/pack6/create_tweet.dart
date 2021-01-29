import 'package:apptawthra/models/package.dart';
import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
 import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/custom_dialog.dart';
import 'package:apptawthra/widgets/network_image.dart';
 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../order_done.dart';

class CreateTweetScreen6 extends StatefulWidget {
  final int program;
  final String packageType;

  CreateTweetScreen6({Key key, this.program=6, this.packageType=""});

  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen6> {
  List<File> selectedPictures = [];
  String selectedTimeDate;
  int accountType;
  int program;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      showSnackBar(context, "Alert", "Payment made Successfully", duration: 4);
      Map arguments = ModalRoute.of(context).settings.arguments;
      program = arguments["program"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appCanvasColor,
      appBar: AppBar(
        backgroundColor: Styles.appCanvasColor,
        title: Text(
          "Create a Tweet",
          style: GoogleFonts.nunito(
              fontSize: 18.0,
              color: Styles.colorBlack,
              fontWeight: FontWeight.bold),
        ),
        bottom: AppBar(
          leading: SizedBox(),
          backgroundColor: Styles.appCanvasColor,
          title: Text(
            "${widget.packageType} - Program ${alphabets[widget.program]}",
            style: GoogleFonts.nunito(
                fontSize: 14.0,
                color: Styles.colorBlack,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose which account you want to tweet on:",
              style: GoogleFonts.nunito(
                  fontSize: 16.0,
                  color: Styles.colorBlack,
                  fontWeight: FontWeight.w600),
            ),
            verticalSpaceSmall,
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: accountType == 1
                      ? Styles.appPrimaryColor
                      : Styles.appBackground,
                  child: InkWell(
                    onTap: () {
                      accountType = 1;
                      addAccount(context);
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      padding:
                          EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Styles.colorBlack),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "From Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: accountType == 1
                                ? Colors.white
                                : Styles.colorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text(
                  "Maximum number of retweets:",
                  style: GoogleFonts.nunito(
                      fontSize: 16.0,
                      color: Styles.colorBlack,
                      fontWeight: FontWeight.w600),
                ),
                horizontalSpaceSmall,
                Container(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff071232),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    maxLength: 3,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Styles.appBackground,
                      hintText: "??",
                      counter: SizedBox(),
                      hintStyle:
                          TextStyle(color: Color(0xff828A95), fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xff245DE8),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Start Date:",
                  style: GoogleFonts.nunito(
                      fontSize: 16.0,
                      color: Styles.colorBlack,
                      fontWeight: FontWeight.w600),
                ),
                horizontalSpaceMedium,
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Styles.appBackground),
                    child: GestureDetector(
                      onTap: () {
                        DateTime initialDate = DateTime.now();
                        DateTime lastDate = DateTime(initialDate.year + 1,
                            initialDate.month, initialDate.day);
                        TimeOfDay time = TimeOfDay.now();
                        showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: initialDate,
                                lastDate: lastDate)
                            .then((date) {
                          print(date);
                          if (date == null) {
                            return;
                          }
                          showTimePicker(context: context, initialTime: time)
                              .then((presentTime) {
                            print(presentTime);
                            selectedTimeDate = formatDateTime(date);
                            setState(() {});
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          selectedTimeDate ?? "Select...",
                          style: GoogleFonts.nunito(
                              fontSize: 14.0,
                              color: Styles.colorBlack,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ))
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text(
                  "End Date:",
                  style: GoogleFonts.nunito(
                      fontSize: 16.0,
                      color: Styles.colorBlack,
                      fontWeight: FontWeight.w600),
                ),
                horizontalSpaceMedium,
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Styles.appBackground),
                    child: GestureDetector(
                      onTap: () {
                        DateTime initialDate = DateTime.now();
                        DateTime lastDate = DateTime(initialDate.year + 1,
                            initialDate.month, initialDate.day);
                        TimeOfDay time = TimeOfDay.now();
                        showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: initialDate,
                                lastDate: lastDate)
                            .then((date) {
                          print(date);
                          if (date == null) {
                            return;
                          }
                          showTimePicker(context: context, initialTime: time)
                              .then((presentTime) {
                            print(presentTime);
                            selectedTimeDate = formatDateTime(date);
                            setState(() {});
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          selectedTimeDate ?? "Select...",
                          style: GoogleFonts.nunito(
                              fontSize: 14.0,
                              color: Styles.colorBlack,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Styles.appCanvasColor,
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, bottom: 60, top: 15),
        child: CustomButton(
            color: selectedTimeDate == null
                ? Colors.grey
                : Styles.appPrimaryColor,
            title: "COMPLETE",
            onPressed: () {
              moveToAndReplace(context, OrderDonePage());
            }),
      ),
    );
  }


  void addAccount(context) async {
    await showDialog(
        context: context,
        builder: (context) => CustomDialog(
            title: "Choose Account",
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CachedImage(size: 40, imageUrl: "kk"),
                  title: Text("@Mastertope_",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Add New account"),
                  onTap: () {},
                ),
              ],
            ),
            onClicked: () async {
              Navigator.pop(context);
            },
            context: context));
  }
}
