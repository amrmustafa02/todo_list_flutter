import 'package:flutter/material.dart';

class MyTheme {
  static var btrolColor = const Color(0xFF0E335A);
  static var lightPrimaryColor = const Color(0xFF0E335A);


  static var lightTheme = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 14
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        color: Colors.black
      ),
        bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 16
        )
    ),
    primaryColorDark: Colors.white,
    appBarTheme: AppBarTheme(
      color: btrolColor,
    ),
    primaryColorLight: lightPrimaryColor,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF4F6F6),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedIconTheme: const IconThemeData(size: 20),
        selectedIconTheme: const IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
        selectedItemColor: lightPrimaryColor,
        unselectedItemColor: Colors.grey),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),
  );

  static var darkTheme = ThemeData(
    bottomSheetTheme:  const BottomSheetThemeData(
      backgroundColor: Color(0xFF141922),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
    ),
    textTheme: const TextTheme(
        headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 14
        ),
        headlineMedium: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 16
      )
    ),
    appBarTheme: AppBarTheme(
      color: btrolColor,
    ),
    primaryColor: const Color(0xFF141922),
    primaryColorLight: const Color(0xFF141922),
    scaffoldBackgroundColor: const Color(0xFF060E1E),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedIconTheme: IconThemeData(size: 20),
        selectedIconTheme: IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey),
    bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFF141922)),
  );
}
