import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/component/main_stat.dart';
import 'package:particulate_matter_app/constant/colors.dart';

import '../component/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            MainAppBar(),
            SliverToBoxAdapter(
              // Sliver안에 Sliver화 해서 넣을 수 있게 해주는 위젯
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0), // 양쪽에 다 설정할 수 있는게 symnetric
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all( // 카드를 한번에 깎기
                        Radius.circular(16.0)          // 카드를 한번에 깎기
                      ),
                    ) , // ShapeBorder --> Abstract Class , extend하는 애들만 사용가능
                    color: lightColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '종류별 통계',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/m³',
                            ),
                            MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/m³',
                            ),
                            MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/m³',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
            ),
          ],
        ),
      ),
    );
  }
}
