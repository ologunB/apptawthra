import 'package:flutter/cupertino.dart';

void moveTo(BuildContext context, Widget view) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => view));
}

void moveToAndReplace(BuildContext context, Widget view) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => view), (route) => false);
}
