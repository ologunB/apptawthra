import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  CachedImage({this.size, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: Colors.black, width: 2)),
        child:ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? "ere",
            height: size,
            width: size,
            fit: BoxFit.fill,
            placeholder: (context, url) => Image(
                image: AssetImage("images/person.png"),
                height: size,
                width: size,
                fit: BoxFit.contain),
            errorWidget: (context, url, error) => Image(
                image: AssetImage("images/person.png"),
                height: size,
                width: size,
                fit: BoxFit.contain),
          ),
        ));
  }
}
