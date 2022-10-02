import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData appTheme(BuildContext context) => ThemeData(
      primarySwatch: primaryColor,
      // @NOTE 04 google_fonts 사용
      // @NOTE 04-1 간단하게는 다음처럼...
      // fontFamily: GoogleFonts.nanumPenScript().fontFamily,
      // 참고: https://api.flutter.dev/flutter/material/TextTheme-class.html
      textTheme: GoogleFonts.nanumPenScriptTextTheme(
        Theme.of(context).textTheme.copyWith(
              headline1: const TextStyle(fontSize: fontSize * 6.0),
              headline2: const TextStyle(fontSize: fontSize * 3.75),
              headline3: const TextStyle(fontSize: fontSize * 3.0),
              headline4: const TextStyle(fontSize: fontSize * 2.125),
              headline5: const TextStyle(fontSize: fontSize * 1.5),
              headline6: const TextStyle(fontSize: fontSize * 1.25),
              subtitle1: const TextStyle(fontSize: fontSize * 1.0),
              subtitle2: const TextStyle(fontSize: fontSize * 0.875),
              bodyText1: const TextStyle(fontSize: fontSize * 1.0),
              bodyText2: const TextStyle(fontSize: fontSize * 0.875),
              button: const TextStyle(fontSize: fontSize * 0.875),
              caption: const TextStyle(fontSize: fontSize * 0.75),
              overline: const TextStyle(fontSize: fontSize * 0.625),
            ),
      ),
    );
