// @dart=2.9
import 'package:flutter/material.dart';
import 'package:five_guy_explo/pages/root.dart';

void main() {
  runApp(MyApp());
}

MaterialApp MyApp() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RootPage(),
  );
}
