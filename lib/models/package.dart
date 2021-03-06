import 'package:apptawthra/utils/constants.dart';
import 'package:apptawthra/views/pack1/type_selector.dart';
import 'package:apptawthra/views/pack2/type_selector.dart';
import 'package:apptawthra/views/pack3/type_selector.dart';
import 'package:apptawthra/views/pack4/type_selector.dart';
import 'package:apptawthra/views/pack5/type_selector.dart';
import 'package:apptawthra/views/pack6/type_selector.dart';
import 'package:flutter/cupertino.dart';

class Package {
  List<String> programDescs;
  List<String> programTitles;
  List<String> programPrices;
  List<String> ids;
  String packageTitle;
  String packageDesc;
  String imageUrl;
  Widget typeWidget;

  Package(
      {this.programDescs,
      this.programTitles,
      this.packageTitle,
      this.imageUrl,
      this.packageDesc,
      this.ids,
      this.typeWidget,
      this.programPrices});
}

Package samplePackage1 = Package(
  packageTitle: "Package 1",
  imageUrl: "images/pack1.png",
  programTitles: ["A", "B", "C", "D"],
  ids: ["1", "2", "3", "4"],
  typeWidget: TypeSelector1(),
);

Package samplePackage2 = Package(
    packageTitle: "Package 2",
    imageUrl: "images/pack2.png",
    programDescs: ["1 Week", "1 Month", "3 Months", "6 Months", "12 Months"],
    programTitles: ["1", "12", "24", "48", "96"],
    typeWidget: TypeSelector2());

Package samplePackage3 = Package(
  packageTitle: "Package 3",
  imageUrl: "images/pack3.png",
  programDescs: ["1 Week", "1 Month", "3 Months", "6 Months", "12 Months"],
  programTitles: ["1", "12", "24", "48", "96"],
  typeWidget: TypeSelector3(),
);

Package samplePackage4 = Package(
    packageTitle: "Package 4",
    imageUrl: "images/pack4.png",
    programDescs: ["1 Week", "1 Month", "3 Months", "6 Months", "12 Months"],
    programTitles: ["1", "4", "8", "12", "24"],
    typeWidget: TypeSelector4());

Package samplePackage5 = Package(
    packageTitle: "Package 5",
    imageUrl: "images/pack5.png",
    programDescs: ["Once", "Daily", "Weekly", "Monthly", "Annual"],
    programTitles: ["1 Month", "3 Months", "6 Months", "12 Months"],
    typeWidget: TypeSelector5());

Package samplePackage6 = Package(
    packageTitle: "Package 6",
    imageUrl: "images/pack6.png",
    programDescs: ["1 Week", "1 Month", "3 Months", "6 Months", "12 Months"],
    typeWidget: TypeSelector6(),
    programTitles: ["Account", "Hashtag", "Word"]);

List<Package> getPackages() {
  return [
    samplePackage1,
    samplePackage2,
    samplePackage3,
    samplePackage4,
    samplePackage5,
    samplePackage6,
  ];
}

List<String> alphabets = ["A", "B", "C", "D", "E", "F", "G"];

int convertToDays(String a) {
  if (a == "Once" || a == "Daily") {
    return 7;
  } else if (a == "1 Week") {
    return 7;
  } else if (a == "1 Month") {
    return 31;
  } else if (a == "3 Months") {
    return 93;
  } else if (a == "6 Months") {
    return 186;
  } else if (a == "12 Months") {
    return 365;
  } else {
    return 30;
  }
}
