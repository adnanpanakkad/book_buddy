import 'package:book_buddy/core/presentation/widgets/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTextStyle {
  static const TextStyle buttonTextStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, fontFamily: "Urbanist");

  static const TextStyle highboldTxtStyle = TextStyle(
      fontSize: 29,
      fontWeight: FontWeight.w600,
      fontFamily: 'Urbanist',
      color: Color.fromARGB(255, 53, 53, 53));

  static const TextStyle swipeTextStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontFamily: "Urbanist",
      color: Appcolor.primaryColor);

  static const TextStyle ultraBoldTextstyle = TextStyle(
      fontSize: 35, fontFamily: 'Urbanist', fontWeight: FontWeight.bold);

  static const TextStyle textFieldstyle = TextStyle(
      color: Color.fromARGB(255, 157, 157, 157),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: "Urbanist");
       static TextStyle poppinsText(Color clr, double size, FontWeight weight) {
  //  return GoogleFonts.poppins(
    return GoogleFonts.raleway(
      color: clr,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle robotoText(Color clr, double size, FontWeight weight) {
  //  return GoogleFonts.roboto(
    return GoogleFonts.varta(
      color: clr,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle SoraText(Color clr, double size, FontWeight weight) {
    return GoogleFonts.sora(
      color: clr,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle RubicText(Color clr, double size, FontWeight weight) {
    return GoogleFonts.dancingScript(
      color: clr,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle NunitoText(Color clr, double size, FontWeight weight) {
    return GoogleFonts.nunito(
      color: clr,
      fontSize: size,
      fontWeight: weight,
    );
  }
}