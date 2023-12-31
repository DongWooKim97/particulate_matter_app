import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/card_title.dart';
import 'package:particulate_matter_app/component/main_card.dart';
import 'package:particulate_matter_app/model/stat_and_status_model.dart';
import 'package:particulate_matter_app/utils/data_utils.dart';

import 'main_stat.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color darkColor;
  final Color lightColor;

  const CategoryCard({
    required this.region,
    required this.darkColor,
    required this.lightColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        backgroundColor: lightColor,
        // 카드를 컴포넌트로 뺴고 외부에서 child값을 받음.
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류별 통계',
                backgroundColor: darkColor,
              ),
              Expanded(
                //스크롤 가능한 위젯들은 Column안에서 썼을때 무조건 Expanded안에 넣어줘야한다 무조건!!!!
                child: ListView(
                  // 디폴트는 수직 vertical // 처음에 이렇게만 설정하면 아래와 같은 오류 발생
                  // Horizontal viewport was given unbounded height. -> 리스트뷰의 높이가 무한정으로 늘어났다.unbounded
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  // 일일이 넘기는 스크롤이 아닌 페이지형식으로 넘기는 스크롤로 만듬.
                  children: models
                      .map(
                        (model) => MainStat(
                          width: constraint.maxWidth / 3,
                          category: DataUtils.getItemCodeKoreanString(itemCode: model.itemCode),
                          imgPath: model.status.imagePath,
                          level: model.status.label,
                          stat:
                              '${model.stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItemCode(itemCode: model.itemCode)}',
                        ),
                      )
                      .toList(),
                  // List.generate(
                  //   20,
                  //   (index) => MainStat(
                  //     category: '미세먼지$index',
                  //     imgPath: 'asset/img/best.png',
                  //     level: '최고',
                  //     stat: '0㎍/m³',
                  //     width:
                  //   ),
                  // ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

/*
스크린 사이즈는 핸드폰 혹은 기종별로 사이즈가 다 다르다. 그렇기 때문에 해당 기종에 스크린 사이즈에 맞출 수 있는 위젯이 있다.
>> LayoutBuilder
Context말고도 Constraint라는 것을줌

constraint에는 maxHeight + minHeight / minWidth + minWidth가 있음.
최대/소 높이 너비 제공
이 레이아웃 빌더가 차지하고 있는 공간을 기준으로 사용할 수 있다.
우리 코드에서는 Card가 LayoutBuilder를 차지하고 있기 때문에 LayoutBuilder에서 constraint.maxHeight를 사용하면
기종별로 달라지는 width, height값을 사용할 수 있다.

 */
