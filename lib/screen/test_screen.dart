import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:particulate_matter_app/main.dart';

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
          Text(
            'Test Screen',
            textAlign: TextAlign.center,
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
              box.add('테스트1');
            },
            child: Text('데이터 넣기'),
          ),
        ],
      ),
    );
  }
}
