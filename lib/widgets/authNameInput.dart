import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
class AuthNameInput extends StatelessWidget {
  final String hintText;
  final Function onChanged;
  final TextEditingController controller;

  const AuthNameInput({Key key, this.hintText, this.onChanged, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: onChanged,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter your'.tr() + hintText;
        } else
          return null;
      },
      style: GoogleFonts.nunito(
          color: Color(0xff071232),
          fontWeight: FontWeight.w500,
          fontSize: 16),
      cursorColor: Color(0xff245DE8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10),
        fillColor: Color(0xffF3F4F8),
        labelText: hintText,
        labelStyle: GoogleFonts.nunito(
            color: Colors.black54, fontSize:16),
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
