import 'package:flutter/material.dart';

import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
        dividerColor: Colors.white70,
        dialogBackgroundColor: CustomColors.backgroundColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: CustomColors.backgroundColor,
        ),
        appBarTheme: AppBarTheme(
          color: CustomColors.backgroundColor,
          iconTheme: IconThemeData(
            color: CustomColors.white87,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: CustomColors.accentColor, //thereby
        ),
        // textSelectionHandleColor: CustomColors.accentColor,
        // textSelectionColor: CustomColors.accentColor,
        primarySwatch: MaterialColor(
          0xFF242729,
          <int, Color>{
            50: CustomColors.cardColor,
            100: CustomColors.cardColor,
            200: CustomColors.cardColor,
            300: CustomColors.cardColor,
            400: CustomColors.cardColor,
            500: CustomColors.backgroundColor,
            600: CustomColors.backgroundColor,
            700: CustomColors.backgroundColor,
            800: CustomColors.backgroundColor,
            900: CustomColors.backgroundColor,
          },
        ),
        errorColor: CustomColors.errorColor,
        secondaryHeaderColor: CustomColors.secondaryAccent,
        cardColor: CustomColors.cardColor,
        accentColor: CustomColors.accentColor,
        canvasColor: CustomColors.accentColor,
        scaffoldBackgroundColor: CustomColors.backgroundColor,
        backgroundColor: CustomColors.backgroundColor,
        hintColor: Colors.white38,
        textTheme: getMainTextTheme(),
        iconTheme: IconThemeData(
          size: 16,
          color: CustomColors.accentColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.white38,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.accentColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.backgroundColor,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: CustomColors.chipBackgroundColor,
          labelStyle: TextStyle(
            color: Colors.white38,
          ),
          secondaryLabelStyle: TextStyle(
            color: CustomColors.accentColor,
          ),
          secondarySelectedColor: CustomColors.accentColor,
          padding: EdgeInsets.zero,
          shape: StadiumBorder(),
          selectedColor: CustomColors.accentColor,
          labelPadding: EdgeInsets.symmetric(horizontal: 8),
          brightness: Brightness.dark,
          disabledColor: Colors.grey,
        ),
        tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(
          color: CustomColors.accentColor,
        )));
  }

  TextTheme getMainTextTheme() {
    return GoogleFonts.playTextTheme(
      ThemeData.dark().textTheme.copyWith(
            headline1: TextStyle(
              color: CustomColors.white87,
            ),
            headline2: TextStyle(
              color: CustomColors.white87,
            ),
            headline3: TextStyle(
              color: CustomColors.white87,
            ),
            headline4: TextStyle(
              color: CustomColors.white87,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            headline5: TextStyle(
              color: CustomColors.white87,
            ),
            headline6: TextStyle(
              color: CustomColors.white87,
            ),
            subtitle2: TextStyle(
              color: CustomColors.white87,
            ),
            subtitle1: TextStyle(
              color: CustomColors.white87,
            ),
            caption: TextStyle(
              color: CustomColors.white60,
            ),
            button: TextStyle(
              color: CustomColors.backgroundColor,
            ),
            bodyText2: TextStyle(
              color: CustomColors.white87,
            ),
          ),
    );
  }
}
