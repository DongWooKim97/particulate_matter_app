import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/card_title.dart';
import 'package:particulate_matter_app/component/category_card.dart';
import 'package:particulate_matter_app/component/hourly_card.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/component/main_card.dart';
import 'package:particulate_matter_app/constant/colors.dart';
import 'package:particulate_matter_app/constant/data.dart';
import 'package:particulate_matter_app/model/stat_model.dart';

import '../component/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    //get이면 GET요청, post면 POST요청
    final response = await Dio().get(
        'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
        queryParameters: {
          'serviceKey': serviceKey,
          'returnType': 'json',
          'numOfRows': 30,
          'pageNo': 1,
          'itemCode': 'PM10',
          'dataGubun': 'HOUR',
          'searchCondition': 'WEEK',
        });

    print(
      response.data['response']['body']['items'].map(
        (item) => StatModel.fromJson(json: item),
      ),
    );
  }

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
                  HourlyCard(),
                ],
              ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
            ),
          ],
        ),
      ),
    );
  }
}
