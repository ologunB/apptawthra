import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final Color color;
  final GestureTapCallback onPressed;

  CustomButton({
    Key key,
    @required this.title,
    this.color = const Color(0xffFFD839),
    @required this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: widget.color,
          child: InkWell(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )),
    );
  }
}
