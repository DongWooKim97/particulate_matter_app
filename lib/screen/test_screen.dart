import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:particulate_matter_app/main.dart';
import 'package:particulate_matter_app/screen/test2_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>( // 결국 스트림빌더와 동일하다 .
            valueListenable: Hive.box(testBox).listenable(), // 모든 박스에 존재하는 함수.
            builder: (context, box, widget) {
              // 빌드가 될 때 마다 실행됨. 즉 빌드될 때 마다 리스닝하고 있는 박스들으리 데이터들을 빌드될 때 마다 바로바로 받아볼 수 있는거임.
              print(box.values.toList());
              return Column(
                children: box.values.map((e) => Text(e.toString())).toList(),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              print('keys: ${box.keys.toList()}');
              print('values : ${box.values.toList()}');
            },
            child: Text('박스 프린트하기!!'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              // 데이터를 생성하거나
              // 업데이트할 때
              box.put(1, 100);
            },
            child: Text('데이터 넣기'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              //getAt -> 인덱스, get -> 키값으로 value도출
              print(box.getAt(3));
            },
            child: Text(
              '특정 값 가져오기!',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              box.deleteAt(0);
            },
            child: Text('삭제하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Test2Screen())
              );
            },
            child: Text(
              '다음 화면!!',
            ),
          ),
        ],
      ),
    );
  }
}
