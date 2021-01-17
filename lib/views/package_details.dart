import 'package:apptawthra/models/subscribed.dart';
import 'package:apptawthra/models/tweeted_model.dart';
import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/custom_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class PackageItemDetails extends StatefulWidget {
  final Subscribed model;

  const PackageItemDetails({Key key, this.model}) : super(key: key);

  @override
  _PackageItemDetailsState createState() => _PackageItemDetailsState();
}

class _PackageItemDetailsState extends State<PackageItemDetails> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.model.message);
    getCount();
    super.initState();
  }

  String count = "-";
  String total = "--";

  getCount() async {
    try {
      var dataRes = await dio.get(
          "https://thatra.herokuapp.com/api/v1/package1/${widget.model.tweetId}",
          options: defaultOptions);
      print(dataRes.statusCode);
      if (dataRes.statusCode == 200) {
        TweetedResponse response = TweetedResponse.fromJson(dataRes.data);
        count = response.noOfSentTweets.toString();
        total = (response.period * response.numberOfTweetsPerDay).toString();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;

  onDoneEditing(context) async {
    Navigator.pop(context);

    isLoading = true;
    setState(() {});

    Map data = {
      "id": 3,
      "username": widget.model.account["screen_name"],
      "package_name": widget.model.package,
      "program": widget.model.program,
      "tweet_text": controller.text,
      "scheduled_at": widget.model.startTime,
      "access_token": widget.model.account["oauth_token"],
      "access_token_secret": widget.model.account["oauth_token_secret"],
      "images": widget.model.images
    };
    try {
      var dataRes = await dio.patch(
          "https://thatra.herokuapp.com/api/v1/package1/${widget.model.tweetId}",
          data: data,
          options: defaultOptions);
      print(dataRes);

      showSnackBar(context, "Alert", dataRes.statusMessage);
      if (dataRes.statusCode == 200) {
        isLoading = false;
        setState(() {});
        FirebaseFirestore.instance
            .collection("Utils")
            .doc("Packages")
            .collection(FirebaseAuth.instance.currentUser.uid)
            .doc(widget.model.timeStamp)
            .update({"message": controller.text});
      } else {
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      showSnackBar(context, "Alert", e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "Packages Details",
            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 2),
      bottomNavigationBar: Container(
        color: Styles.appCanvasColor,
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 60),
        child: CustomButton(
            color: Styles.appPrimaryColor,
            title: "UPDATE".tr(),
            onPressed: () {
              offKeyboard(context);
              showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                      title: "Confirmation".tr(),
                      body: Text(
                        "Are you sure you want to update the Package?".tr(),
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onClicked: () {
                        onDoneEditing(context);
                      },
                      context: context));
            }),
      ),
      body: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      widget.model.package,
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    horizontalSpaceSmall,
                    Text(
                      widget.model.program,
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      "Price: #${widget.model.price ?? "#300"}",
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            verticalSpaceTiny,
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      "Account: ",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        moveTo(
                            context,
                            SafeArea(
                              child: WebView(
                                initialUrl:
                                    "https://twitter.com/" + widget.model.account["screen_name"],
                                javascriptMode: JavascriptMode.unrestricted,
                                navigationDelegate: (NavigationRequest request) {
                                  return NavigationDecision.navigate;
                                },
                              ),
                            ));
                      },
                      child: Text(
                        "@${widget.model.account["screen_name"]}",
                        style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                )),
            verticalSpaceTiny,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Text(
                "Description: ${widget.model.desc.tr() ?? "blah blah blah"}",
                style: GoogleFonts.nunito(
                    fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total",
                              style: GoogleFonts.nunito(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                          Text("$count / $total Tweets" ,
                              style: GoogleFonts.nunito(
                                  fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                        ],
                      ),
                      horizontalSpaceMedium,
                      Icon(
                        Icons.radio_button_checked,
                        color: Colors.green,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text("Start Date",
                              style: GoogleFonts.nunito(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                          Text(widget.model.startTime,
                              style: GoogleFonts.nunito(
                                  fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black))
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      horizontalSpaceMedium,

                      Column(
                        children: [
                          Text("Daily Tweet",
                              style: GoogleFonts.nunito(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                          Text(widget.model.noOftweets + " Tweet(s)",
                              style: GoogleFonts.nunito(
                                  fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black))
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Text",
                              style: GoogleFonts.nunito(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                          total == "--"
                              ? SizedBox()
                              : isLoading
                                  ? CupertinoActivityIndicator()
                                  : InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                title: "Edit Message",
                                                body: TextFormField(
                                                  keyboardType: TextInputType.text,
                                                  maxLength: 280,
                                                  controller: controller,
                                                  maxLines: 7,
                                                  style: GoogleFonts.nunito(
                                                      color: Color(0xff071232),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16),
                                                  cursorColor: Color(0xff245DE8),
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10, horizontal: 10),
                                                    fillColor: Styles.appBackground,
                                                    hintText: "Write your message...".tr(),
                                                    hintStyle: GoogleFonts.nunito(
                                                        color: Color(0xff828A95), fontSize: 14),
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
                                                onClicked: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                      child: Icon(Icons.edit, size: 20)),
                        ],
                      ),
                      verticalSpaceTiny,
                      Text(controller.text,
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Images",
                      style: GoogleFonts.nunito(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      itemCount: widget.model.images.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: CachedNetworkImage(
                            imageUrl: widget.model.images[index]["image"],
                            height: 100,
                            width: 100,
                            placeholder: (context, url) => Container(
                                height: 20, width: 20, child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Container(
                              height: 100,
                              width: 100,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("images/placeholder.png"),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium
          ],
        ),
      ),
    );
  }
}
