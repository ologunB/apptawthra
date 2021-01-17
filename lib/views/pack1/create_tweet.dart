import 'package:apptawthra/models/twitter_acc.dart';
import 'package:apptawthra/widgets/custom_dialog.dart';
import 'package:apptawthra/widgets/show_exception_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptawthra/models/package.dart';
import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../error_util.dart';
import '../order_done.dart';
import 'package:apptawthra/utils/lib/oauth1.dart' as oauth1;

class CreateTweetScreen1 extends StatefulWidget {
  final int program;

  CreateTweetScreen1({Key key, this.program = 1});

  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen1> {
  TextEditingController textController = TextEditingController();
  List<File> selectedPictures = [];
  String selectedTimeDate;
  int accountType;
  List<TwitterKeys> userKeys = [];
  List<TwitterKeys> adminKeys = [];

  TwitterKeys selectedUserAccount;
  TwitterKeys selectedAdminAccount;

  getTokens() {
    offKeyboard(context);

    isLoading = true;
    setState(() {});
    var platform = new oauth1.Platform(
        'https://api.twitter.com/oauth/request_token', // temporary credentials request
        'https://api.twitter.com/oauth/authorize', // resource owner authorization
        'https://api.twitter.com/oauth/access_token', // token credentials request
        oauth1.SignatureMethods.hmacSha1 // signature method
        );

    // define client credentials (consumer keys)
    const String apiKey = '17Exv61ua6N5GrrRgHy22ltub';
    const String apiSecret = 'aizFVjFVieeolOtYqLksloKVIUGqacaJL02fzMwEw9XRlrxv68';
    final oauth1.ClientCredentials clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);

    // create Authorization object with client credentials and platform definition
    final oauth1.Authorization auth = oauth1.Authorization(clientCredentials, platform);

    // request temporary credentials (request tokens)
    auth.requestTemporaryCredentials('https://callback').then((oauth1.AuthorizationResponse res) {
      isLoading = false;
      setState(() {});
      moveTo(
          context,
          SafeArea(
            child: WebView(
              initialUrl: auth.getResourceOwnerAuthorizationURI(res.credentials.token),
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://callback')) {
                  Navigator.of(context).pop('success');
                  isLoading = true;
                  setState(() {});

                  List<String> list = request.url.split("&");
                  List<String> list2 = list[1].split("=");

                  auth.requestTokenCredentials(res.credentials, list2[1]).then((value) {
                    Map<String, Object> mData = Map();
                    mData.putIfAbsent("oauth_token", () => value.credentials.token);
                    mData.putIfAbsent("oauth_token_secret", () => value.credentials.tokenSecret);
                    mData.putIfAbsent("user_id", () => value.optionalParameters["user_id"]);
                    mData.putIfAbsent("screen_name", () => value.optionalParameters["screen_name"]);

                    FirebaseFirestore.instance
                        .collection("Utils")
                        .doc("Tokens")
                        .collection(FirebaseAuth.instance.currentUser.uid)
                        .doc(value.optionalParameters["user_id"])
                        .set(mData)
                        .then((val) {
                      showSnackBar(context, "Alert".tr(), "Account Added".tr());

                      selectedUserAccount = TwitterKeys(
                          value.credentials.token,
                          value.credentials.tokenSecret,
                          value.optionalParameters["screen_name"],
                          value.optionalParameters["user_id"]);

                      setState(() {
                        isLoading = false;
                      });
                    }).catchError((e) {
                      showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
                      setState(() {
                        isLoading = false;
                      });
                    });
                    isLoading = false;
                    setState(() {});
                  }).catchError((e) {
                    isLoading = false;
                    setState(() {});
                    print(e);
                  });

                  // <-- Handle success case
                } else {
                  Navigator.of(context).pop('cancel');
                  showSnackBar(context, "Error".tr(), "Unable to Authorize user".tr());
                }
                return NavigationDecision.navigate;
              },
            ),
          ));
    }).catchError((e) {
      isLoading = false;
      setState(() {});

      showSnackBar(context, "Error".tr(), "An error has occurred".tr());
    }).timeout(Duration(seconds: 30), onTimeout: () {
      isLoading = false;
      setState(() {});

      showSnackBar(context, "Timed out".tr(), "Internet connection is unstable".tr());
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      showSnackBar(context, "Alert".tr(), "Payment made Successfully".tr(), duration: 4);
    });
    if (widget.program == 2 || widget.program == 3) {
      getAdminImages();
    }
    super.initState();
  }

  getAdminImages() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Utils")
        .doc("Images")
        .collection("Admin")
        .get();
    query.docs.map((e) => images.add({"image": e.data()["url"]})).toList();

    isLoading = false;
    setState(() {});
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        offKeyboard(context);
      },
      child: LoadingOverlay(
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        isLoading: isLoading,
        color: Colors.grey,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Styles.appCanvasColor,
            appBar: AppBar(
              backgroundColor: Styles.appCanvasColor,
              title: Text(
                "Create a Tweet".tr(),
                style: GoogleFonts.nunito(
                    fontSize: 16.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
              ),
              bottom: AppBar(
                leading: SizedBox(),
                backgroundColor: Styles.appCanvasColor,
                title: Text(
                  "${"Package 1".tr()} - Program ${alphabets[widget.program]}",
                  style: GoogleFonts.nunito(
                      fontSize: 14.0, color: Styles.colorBlack, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 3,
              ),
              centerTitle: true,
              elevation: 3,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Choose which account you want to tweet on:".tr(),
                    style: GoogleFonts.nunito(fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Utils")
                              .doc("Tokens")
                              .collection("Admin")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Text("waiting");
                              default:
                                if (snapshot.data.documents.isNotEmpty && adminKeys.isEmpty) {
                                  snapshot.data.documents.map((document) {
                                    TwitterKeys item = TwitterKeys.map(document);
                                    adminKeys.add(item);
                                  }).toList();
                                }
                                return Expanded(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Material(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      color: accountType == 0 && selectedAdminAccount != null
                                          ? Styles.appPrimaryColor
                                          : Styles.appBackground,
                                      child: InkWell(
                                        onTap: () {
                                          if (adminKeys.isEmpty) {
                                            showSnackBar(context, "Alert", "No Admin Account");
                                            return;
                                          }
                                          addAdminAccount(context);
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 2),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[300]),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            accountType == 0 && selectedAdminAccount != null
                                                ? "@" + selectedAdminAccount.screen_name
                                                : "TAWTRHA " + "Account".tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                                ));
                            }
                          }),
                      horizontalSpaceSmall,
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Utils")
                              .doc("Tokens")
                              .collection(FirebaseAuth.instance.currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Text("Waiting".tr());
                              default:
                                if (snapshot.data.documents.isNotEmpty && userKeys.isEmpty) {
                                  snapshot.data.documents.map((document) {
                                    TwitterKeys item = TwitterKeys.map(document);
                                    userKeys.add(item);
                                  }).toList();
                                }
                                return Expanded(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Material(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      color: accountType == 1 && selectedUserAccount != null
                                          ? Styles.appPrimaryColor
                                          : Styles.appBackground,
                                      child: InkWell(
                                        onTap: () {
                                          addUserAccount(context);
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[300]),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            accountType == 1 && selectedUserAccount != null
                                                ? "@" + selectedUserAccount.screen_name
                                                : "Customer Account".tr(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                                fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                                ));
                            }
                          })
                    ],
                  ),
                  verticalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 280,
                        controller: textController,
                        maxLines: 7,
                        style: GoogleFonts.nunito(
                            color: Color(0xff071232), fontWeight: FontWeight.w500, fontSize: 16),
                        cursorColor: Color(0xff245DE8),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          fillColor: Styles.appBackground,
                          hintText: "Write your message...".tr(),
                          hintStyle: GoogleFonts.nunito(color: Color(0xff828A95), fontSize: 14),
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
                      widget.program == 2 || widget.program == 3
                          ? SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                selectedPictures.isEmpty
                                    ? SizedBox()
                                    : Expanded(
                                        child: Container(
                                          height: 150,
                                          child: ListView.builder(
                                              itemCount: selectedPictures.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          child:
                                                              Image.file(selectedPictures[index]),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            selectedPictures
                                                                .remove(selectedPictures[index]);
                                                            images.removeAt(index);
                                                            setState(() {});
                                                          },
                                                          child:
                                                              Icon(Icons.cancel, color: Colors.red),
                                                        ),
                                                        Align(
                                                            child: Container(
                                                          color: Colors.white,
                                                          padding: EdgeInsets.all(5),
                                                          child: Text(
                                                            (index + 1).toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        )),
                                                      ],
                                                    ));
                                              }),
                                        ),
                                      ),
                                selectedPictures.length == 1 && widget.program == 0
                                    ? SizedBox()
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Styles.appBackground,
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              getImageGallery(context);
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 40,
                                                ),
                                                verticalSpaceTiny,
                                                Text(
                                                  "Add Image".tr(),
                                                  style: GoogleFonts.nunito(fontSize: 12),
                                                )
                                              ],
                                            )),
                                      ),
                              ],
                            ),
                      Row(
                        children: [
                          Text("Choose Time:".tr(),
                              style: GoogleFonts.nunito(
                                  fontSize: 14.0,
                                  color: Styles.colorBlack,
                                  fontWeight: FontWeight.w600)),
                          horizontalSpaceSmall,
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Styles.appBackground),
                              child: GestureDetector(
                                onTap: () {
                                  offKeyboard(context);
                                  TimeOfDay time = TimeOfDay.now();
                                  showTimePicker(context: context, initialTime: time)
                                      .then((presentTime) {
                                    selectedTimeDate = presentTime.format(context);
                                    setState(() {});
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    selectedTimeDate ?? "Select...".tr(),
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      verticalSpaceSmall,
                    ],
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: Styles.appCanvasColor,
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 60),
              child: CustomButton(
                  color: Styles.appPrimaryColor,
                  title: "COMPLETE".tr(),
                  onPressed: () {
                    if (accountType == null) {
                      showSnackBar(context, "Error", "Choose an account");
                      return;
                    }
                    if (textController.text.isEmpty) {
                      showSnackBar(context, "Error", "Write your message");
                      return;
                    }
                    if (images.isEmpty) {
                      showSnackBar(context, "Error", "Choose an image");
                      return;
                    }

                    if (selectedTimeDate == null) {
                      showSnackBar(context, "Error", "Choose a start time/date");
                      return;
                    }
                    if (selectedPictures.length < 13 && widget.program == 1) {
                      showSnackBar(context, "Error".tr(), "You must add 12 images");
                      return;
                    }
                    TwitterKeys sele;
                    if (accountType == 0) {
                      sele = selectedAdminAccount;
                    } else {
                      sele = selectedUserAccount;
                    }
                    offKeyboard(context);
                    showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                            title: "Confirmation".tr(),
                            body: Text(
                              "Are you sure you want to create Package 1 on ${sele.screen_name}?"
                                  .tr(),
                              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            onClicked: () async {
                              completeCreateATweet(_scaffoldKey.currentContext);
                            },
                            context: context));
                  }),
            ),
            key: _scaffoldKey,
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map> images = [];

  Future getImageGallery(context) async {
    offKeyboard(context);
    String uri;
    final result = await ImagePicker().getImage(source: ImageSource.gallery);
    File file;
    if (result != null) {
      file = File(result.path);
    } else {
      return;
    }
    isLoading = true;
    setState(() {});
    await uploadImage(file).then((url) {
      uri = url;
      images.add({"image": url});
    });
    selectedPictures.add(file);
    isLoading = false;
    setState(() {});
    FirebaseFirestore.instance
        .collection("Utils")
        .doc("Images")
        .collection(FirebaseAuth.instance.currentUser.uid)
        .doc(randomString())
        .set({"url": uri});
  }

  void addUserAccount(context) async {
    offKeyboard(context);

    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, _setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  "Choose Account".tr(),
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: Container(
                  height: screenHeight(context) / 4,
                  width: screenWidth(context) / 1.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                          itemCount: userKeys.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: selectedUserAccount != null &&
                                      selectedUserAccount == userKeys[index] &&
                                      accountType == 1
                                  ? Styles.appBackground
                                  : null,
                              leading: CachedImage(size: 40, imageUrl: "kk"),
                              title: Text("@" + userKeys[index].screen_name,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                              onTap: () {
                                accountType = 1;
                                selectedUserAccount = userKeys[index];
                                setState(() {});
                                Navigator.pop(context);
                              },
                            );
                          }),
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text("Add New account".tr()),
                        onTap: () {
                          Navigator.pop(context);
                          if (userKeys.length > 2) {
                            showSnackBar(
                                context, "Alert".tr(), "You cannot add more than 2 accounts");
                            return;
                          }

                          getTokens();
                        },
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  void addAdminAccount(context) async {
    offKeyboard(context);

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, _setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  "Choose Account".tr(),
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: Container(
                  height: screenHeight(context) / 3,
                  width: screenWidth(context) / 1.3,
                  child: ListView.builder(
                      itemCount: adminKeys.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: selectedAdminAccount != null &&
                                  selectedAdminAccount == adminKeys[index] &&
                                  accountType == 0
                              ? Styles.appBackground
                              : null,
                          leading: CachedImage(size: 40, imageUrl: "kk"),
                          title: Text("@" + adminKeys[index].screen_name,
                              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                          onTap: () {
                            accountType = 0;
                            selectedAdminAccount = adminKeys[index];
                            setState(() {});
                            Navigator.pop(context);
                          },
                        );
                      }),
                ),
              );
            }));
  }

  void completeCreateATweet(context) async {
    Navigator.pop(context);
    int timeStamp = DateTime.now().microsecondsSinceEpoch;

    setState(() {
      isLoading = true;
    });
    TwitterKeys sele;
    if (accountType == 0) {
      sele = selectedAdminAccount;
    } else {
      sele = selectedUserAccount;
    }

    Map<String, dynamic> mData = Map();
    mData.putIfAbsent("account_type", () => types[accountType]);
    mData.putIfAbsent("account_details", () => sele.toJson());
    mData.putIfAbsent("message", () => textController.text);
    mData.putIfAbsent("package", () => "Package 1");
    mData.putIfAbsent("daily rate", () => 1);
    mData.putIfAbsent("program", () => "Program ${alphabets[widget.program]}");
    mData.putIfAbsent("images", () => images);
    mData.putIfAbsent("id", () => randomString());
    mData.putIfAbsent("desc", () => getPackages()[0].programDescs[widget.program]);
    mData.putIfAbsent("uid", () => FirebaseAuth.instance.currentUser.uid);
    mData.putIfAbsent("price", () => getPackages()[0].programPrices[widget.program]);
    mData.putIfAbsent("status", () => "Pending");
    mData.putIfAbsent("start_time", () => selectedTimeDate);
    mData.putIfAbsent("Timestamp", () => timeStamp);
    mData.putIfAbsent("tweet_id", () => "null");

    if (accountType == 0) {
      mData.update("status", (a) => "Awaiting Approval");
      FirebaseFirestore.instance
          .collection("Utils")
          .doc("Packages")
          .collection(FirebaseAuth.instance.currentUser.uid)
          .doc(timeStamp.toString())
          .set(mData);
      FirebaseFirestore.instance
          .collection("Utils")
          .doc("Tweets")
          .collection("Pending")
          .doc(timeStamp.toString())
          .set(mData)
          .then((val) {
        moveToAndReplace(
            _scaffoldKey.currentContext,
            OrderDonePage(
                from: selectedTimeDate,
                package: "Package 1",
                program: "Program ${alphabets[widget.program]}",
                account: sele.screen_name));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
      });
      return;
    }
    try {
      Map data = {
        "username": sele.screen_name,
        "package_name": "Package 1",
        "program": widget.program.toString(),
        "tweet_text": textController.text,
        "number_of_tweets_per_day": 1,
        "period": widget.program == 3 ? 30.toString() : 365.toString(),
        "scheduled_at": selectedTimeDate,
        "access_token": sele.token,
        "access_token_secret": sele.token_secret,
        "images": images
      };
      var dataRes = await dio.post("https://thatra.herokuapp.com/api/v1/package1/",
          options: defaultOptions, data: data);

      print(dataRes);
      switch (dataRes.statusCode) {
        case 201:
          mData.update("tweet_id", (a) => dataRes.data["id"]);
          try {
            FirebaseFirestore.instance
                .collection("Utils")
                .doc("Packages")
                .collection(FirebaseAuth.instance.currentUser.uid)
                .doc(timeStamp.toString())
                .set(mData)
                .then((val) {
              moveToAndReplace(
                  _scaffoldKey.currentContext,
                  OrderDonePage(
                      from: selectedTimeDate,
                      package: "Package 1",
                      program: "Program ${alphabets[widget.program]}",
                      account: sele.screen_name));
            }).catchError((e) {
              setState(() {
                isLoading = false;
              });
              showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
            });
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            print(e);
            throw "Server is currently under maintenance, Try again later";
          }
          break;
        default:
          setState(() {
            isLoading = false;
          });
          throw dataRes.data["message"] ?? "Unknown Error";
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      throw DioErrorUtil.handleError(e);
    }
  }
}

List<String> types = ["Admin", "Personal"];
