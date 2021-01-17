import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/utils/spacing.dart';
import 'package:apptawthra/widgets/custom_button.dart';
import 'package:apptawthra/widgets/custom_button1.dart';
import 'package:apptawthra/widgets/show_exception_alert_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ImagesLibrary extends StatefulWidget {
  @override
  _ImagesLibraryState createState() => _ImagesLibraryState();
}

class _ImagesLibraryState extends State<ImagesLibrary> {
  List<String> images = [];
  List<String> ids = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        isLoading: isLoading,
        color: Colors.grey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text(
                "Image Library".tr(),
                style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              elevation: 2),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Utils")
                  .doc("Images")
                  .collection(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CupertinoActivityIndicator());
                  default:
                    if (snapshot.data.documents.isNotEmpty) {
                      images = [];
                      snapshot.data.documents.map((document) {
                        String item = document["url"];
                        images.add(item);
                        ids.add(document.id);
                      }).toList();
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: StaggeredGridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          children: images.map<Widget>((item) {
                            return Builder(builder: (context) {
                              return Center(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: item ?? "k",
                                        height: 180,
                                        width: screenWidth(context) / 2.2,
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) => Container(
                                            height: 20,
                                            width: 20,
                                            child: CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) => Container(
                                          height: 180,
                                          width: screenWidth(context) / 2.2,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage("images/placeholder.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        int index = images.indexWhere((element) => element == item);
                                        FirebaseFirestore.instance
                                            .collection("Utils")
                                            .doc("Images")
                                            .collection(FirebaseAuth.instance.currentUser.uid)
                                            .doc(ids[index])
                                            .delete();
                                        images.removeAt(index);
                                        ids.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Icon(Icons.cancel, color: Colors.red),
                                    )
                                  ],
                                ),
                              );
                            });
                          }).toList(),
                          staggeredTiles:
                              images.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                      );
                    } else {
                      return Center(child: Text("Library is Empty, Add Images").tr());
                    }
                }
              }),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(10),
            child: CustomButton(
                title: "Add Image",
                onPressed: () {
                  getImageGallery(context);
                }),
          ),
        ));
  }

  Future getImageGallery(context) async {
    final result = await ImagePicker().getImage(source: ImageSource.gallery);
    File file;
    if (result != null) {
      file = File(result.path);
    } else {
      showSnackBar(context, "Error".tr(), "Unable to get Image".tr());
      return;
    }

    isLoading = true;
    setState(() {});

    await uploadImage(file).then((url) {
      FirebaseFirestore.instance
          .collection("Utils")
          .doc("Images")
          .collection(FirebaseAuth.instance.currentUser.uid)
          .doc(randomString())
          .set({"url": url}).then((val) {
        showSnackBar(context, "Alert".tr(), "Image Added".tr());

        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        showExceptionAlertDialog(context: context, exception: e, title: "Error".tr());
        setState(() {
          isLoading = false;
        });
      });
    });
  }
}
