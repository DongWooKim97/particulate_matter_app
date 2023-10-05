import 'package:flutter/material.dart';
import 'package:particulate_matter_app/screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:particulate_matter_app/screen/test2_screen.dart';
import 'package:particulate_matter_app/screen/test_screen.dart';

const testBox = 'test';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(testBox);

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunFlower',
      ),
      home: TestScreen(),
    ),
  );
}
