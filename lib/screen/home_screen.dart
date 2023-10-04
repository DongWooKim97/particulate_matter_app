import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/card_title.dart';
import 'package:particulate_matter_app/component/category_card.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/component/main_card.dart';
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
              // Sliver안 위젯 위치 배정 -> 그대로 Stay
              // Sliver안에 Sliver화 해서 넣을 수 있게 해주는 위젯
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryCard(),
                  SizedBox(height: 16.0),
                  MainCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CardTitle(
                          title: '시간별 미세먼지',
                        ),
                        Column(
                          children: List.generate(
                            24,
                            (index) {
                              final now = DateTime.now();
                              final hour = now.hour;
                              int currentHour = hour - index;

                              if (currentHour < 0) {
                                currentHour += 24;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('$currentHour시')),
                                    Expanded(
                                      child: Image.asset(
                                        'asset/img/good.png',
                                        height: 20.0,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        '좋음',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
            ),
          ],
        ),
      ),
    );
  }
}
