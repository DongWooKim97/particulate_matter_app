import 'package:flutter/material.dart';
import 'package:particulate_matter_app/constant/colors.dart';

import '../constant/regions.dart';

typedef OnRegionTap = void Function(String region);

class MainDrawer extends StatelessWidget {
  final OnRegionTap onRegionTap;
  final String selectedRegion;

  const MainDrawer({required this.onRegionTap,required this.selectedRegion,  Key? key}) : super(key: key);

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
          ...regions
              .map(
                (e) => ListTile(
                  tileColor: Colors.white,
                  selectedTileColor: lightColor,
                  // 선택된 배경색
                  selectedColor: Colors.black,
                  // 선택된 글자색
                  selected: e == selectedRegion,
                  onTap: () {
                    onRegionTap(e);
                  },
                  title: Text(e),
                ),
              )
              .toList(),
        ],
      ), // 위아래로 스크롤이 되어야하기떄문에 ListView()
    );
  }
}
