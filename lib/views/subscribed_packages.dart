import 'package:apptawthra/models/subscribed.dart';
import 'package:apptawthra/utils/functions.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/utils/styles.dart';
import 'package:apptawthra/views/package_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscribedPackages extends StatefulWidget {
  @override
  _SubscribedPackagesState createState() => _SubscribedPackagesState();
}

class _SubscribedPackagesState extends State<SubscribedPackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "Subscribed Packages",
            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 2),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Utils")
            .doc("Packages")
            .collection(FirebaseAuth.instance.currentUser.uid)
            .orderBy("Timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 30),
                    Text(
                      "Getting Data",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 30)
                  ],
                ),
              );
            default:
              return snapshot.data.docs.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "No subscriptions yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: snapshot.data.docs.map((document) {
                        Subscribed model = Subscribed.map(document);
                        return InkWell(
                          onTap: () {
                            moveTo(context, PackageItemDetails(model: model));
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      horizontalSpaceSmall,
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${model.package}  | ${model.program}",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            verticalSpaceTiny,
                                            Row(
                                              children: [
                                          /*      Text(
                                                  "${model.count} / ${model.total}",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  "  |  ",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      color: Styles.appBackground,
                                                      fontWeight: FontWeight.w600),
                                                ),*/
                                                Text(
                                                  model.status,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: model.status == "Finished"
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Styles.appBackground, size: 20)
                                    ],
                                  ),
                                  verticalSpaceSmall,
                                  Divider(
                                    height: 0,
                                  )
                                ],
                                mainAxisSize: MainAxisSize.min,
                              )),
                        );
                      }).toList(),
                    );
          }
        },
      ),
    );
  }
}
