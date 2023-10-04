import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/category_card.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/component/main_stat.dart';
import 'package:particulate_matter_app/constant/colors.dart';

import '../component/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
                ],
              ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
            ),
          ],
        ),
      ),
    );
  }
}
