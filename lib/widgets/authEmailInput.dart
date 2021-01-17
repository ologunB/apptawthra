import 'package:apptawthra/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthEmailInput extends StatelessWidget {
  final String hintText;
  final Function onChanged;
  final TextEditingController controller;
  bool enabled = true;

  AuthEmailInput({Key key, this.hintText, this.onChanged, this.controller, this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: onChanged,
      enabled: enabled,
      controller: controller,
      validator: validateEmail,
      style: GoogleFonts.nunito(color: Color(0xff071232), fontWeight: FontWeight.w500, fontSize: 16),
      cursorColor: Color(0xff245DE8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        fillColor: Color(0xffF3F4F8),
        labelText: hintText,
        labelStyle: GoogleFonts.nunito(color: Colors.black54, fontSize: 16),
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
    );
  }
}
