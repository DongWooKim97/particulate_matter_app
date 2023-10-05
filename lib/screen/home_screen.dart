import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/card_title.dart';
import 'package:particulate_matter_app/component/category_card.dart';
import 'package:particulate_matter_app/component/hourly_card.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/component/main_card.dart';
import 'package:particulate_matter_app/constant/colors.dart';
import 'package:particulate_matter_app/constant/data.dart';
import 'package:particulate_matter_app/constant/status_level.dart';
import 'package:particulate_matter_app/model/stat_model.dart';
import 'package:particulate_matter_app/repository/stat_repository.dart';

import '../component/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<StatModel>> fetchData() async {
    final statModels =
        await StatRepository.fetchData(); // 레포지토리를 통해 List로 받게끔 해놨음 .

    return statModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: SafeArea(
        child: FutureBuilder<List<StatModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            //에러가 있을 때
            if (snapshot.hasError) {
              return const Center(
                child: Text('에러가 있습니다.'),
              );
            }

            if (!snapshot.hasData) {
              //로딩 상태 -> 데이터가 없을 떄 데이터를 받아오기 위한 로딩상태!
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<StatModel> stats = snapshot.data!;
            // 이건 가장 최근 데이터 . 가장 최근 데이터를 기준으로 우리가 statusLevel이 어느 구간인지를 산정해야함. 맨아래참조.
            StatModel recentStat = stats[0];

            final status = statusLevel.where((element) =>
                element.minFineDust <= recentStat.seoul).last; // where = > 모든 것을 필터링. 서울의 미세먼지값보다 작은 애들만 필터링.

            print(recentStat.seoul);

            return CustomScrollView(
              slivers: [
                MainAppBar(
                  stat: recentStat,
                  status: status,
                ),
                const SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryCard(),
                      SizedBox(height: 16.0),
                      HourlyCard(),
                    ],
                  ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Sliver안 위젯 위치 배정 -> 그대로 Stay
// Sliver안에 Sliver화 해서 넣을 수 있게 해주는 위젯

//  처음에 AppBar를 null이 아닐때만 렌더링 하도록 해놨는데, 앱을 실행시키자마자는 렌더링이 안됨. 왜냐 통신 완료까지의 시간으로 인해 tempModel이 null값이 들어와있기 때문.
// 그 뒤로 통신이 완료되면 appBar가 렌더링 되는 모습을 확인
// 우리가 Stat이라는 값을 실제로 보여줘야하는 값을 넣어준다면 우리가 예상하는대로 구현할 수 있다 ...!!!

// FutureBuilder를 사용할 때 Connection State를 통해 로딩 상태를 정하면 안된다. 요청이 들어갈 떄 마다 로딩바가 매번 돈다.

// 1-5 6-10 11-15
// 7 , 우리는 최솟값만 들고있는데, 최솟값 하나하나가 리스트에 들어있는 값이라고 했을 떄, [ 1, 6, 11, 16, .. ]
// 최솟값보다 작은 애들만 필터링했을 때 그 중 가장 높은 숫자를 가져오면 현재 우리가 들고있는 숫자의 range를 알 수 있따.
