import 'package:flutter/material.dart';

final DarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black26,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 111, 96, 83),
  textTheme: TextTheme(
      bodyMedium: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      labelLarge: const TextStyle(
        fontSize: 30,
        color: Color.fromARGB(255, 211, 211, 211),
      ),
      labelSmall: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 211, 211, 211),
      )),
  useMaterial3: true,
);
