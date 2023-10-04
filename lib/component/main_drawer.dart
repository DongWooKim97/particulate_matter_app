import 'package:flutter/material.dart';
import 'package:particulate_matter_app/constant/colors.dart';

const regions = [
  '서울',
  '경기',
  '대구',
  '충남',
  '인천',
  '대전',
  '경북',
  '세종',
  '광주',
  '전북',
  '강원',
  '울산',
  '전남',
  '부산',
  '제주',
  '충북',
  '경남',
];

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          const DrawerHeader(
            // 타이틀이 들어가는 헤더
            child: Text(
              '지역 선택',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          ...regions.map(
            (e) => ListTile(
              tileColor: Colors.white,
              selectedTileColor: lightColor,
              // 선택된 배경색
              selectedColor: Colors.black,
              // 선택된 글자색
              selected: e == '서울',
              onTap: () {},
              title: Text(e),
            ),
          ).toList(),
        ],
      ), // 위아래로 스크롤이 되어야하기떄문에 ListView()
    );
  }
}
