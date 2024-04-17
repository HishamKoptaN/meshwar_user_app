import 'package:flutter/material.dart';

extension MediaQueryHelper on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width / 100;
  double get screenHeight => MediaQuery.of(this).size.height / 100;
  double get fontSize =>
      MediaQuery.of(this).size.height * MediaQuery.of(this).size.width / 1000;
  double get screenSize =>
      MediaQuery.of(this).size.height * MediaQuery.of(this).size.width / 1000;
}
