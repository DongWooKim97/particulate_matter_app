import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:particulate_matter_app/model/stat_model.dart';
import 'package:particulate_matter_app/screen/test_screen.dart';

const testBox = 'test';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<StatModel>(StatModelAdapter()); // Adapter 등록
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

  await Hive.openBox(testBox);

  // 아이템코드별로 박스를 열면 SQL의 테이블처럼 관리하고 사용할 수 있다.
  for (ItemCode itemCode in ItemCode.values) {
    await Hive.openBox(itemCode.name); // 스트링으로 바꾼 형태의 박스이름을 넣을 것이다. 아이템코드별로 박스를 하나씩 연다.
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunFlower',
      ),
      home: TestScreen(),
    ),
  );
}
