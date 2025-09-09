import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reachify_app/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final darkTheme = ThemeData(
    iconTheme: const IconThemeData(color: Colors.black),
    primarySwatch: Colors.grey,
    useMaterial3: false,
    brightness: Brightness.light,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.primary,
      selectionColor: AppColors.primary.withAlpha(30),
      cursorColor: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(color: AppColors.lightPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    ),
  );

  static List<BoxShadow> get boxShadow => <BoxShadow>[
    BoxShadow(
      color: AppColors.primary.withAlpha(50), //shadow for button
      blurRadius: 5,
      offset: const Offset(0, 2),
    ), //blur radius of shadow
  ];

  static const Gradient gradient = LinearGradient(
    colors: appGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const List<Color> appGradient = [
    Color.fromRGBO(73, 96, 249, 1),
    Color.fromRGBO(20, 51, 255, 1),
  ];
}
