import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class Test2Screen extends StatelessWidget {
  const Test2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test 2 Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            // Box로 가지고 있던 상태들을 글로벌하게 관리할 수 있음.
            // 결국 스트림빌더와 동일하다 .
            valueListenable: Hive.box(testBox).listenable(), // 모든 박스에 존재하는 함수.
            builder: (context, box, widget) {
              // 빌드가 될 때 마다 실행됨. 즉 빌드될 때 마다 리스닝하고 있는 박스들으리 데이터들을 빌드될 때 마다 바로바로 받아볼 수 있는거임.
              print(box.values.toList());
              return Column(
                children: box.values.map((e) => Text(e.toString())).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
