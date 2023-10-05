import 'package:flutter/material.dart';
import 'package:particulate_matter_app/model/stat_model.dart';

import '../constant/colors.dart';
import '../model/status_model.dart';
import '../utils/data_utils.dart';

class MainAppBar extends StatelessWidget {
  final String region;
  final StatusModel status; // 가져온 Statmodel을 기준으로 단계를 나누는 기준을 정의해놓은것.
  final StatModel stat; // 실제값. API에서 요청해서 받아오는 값들을 다트 언어 클래스로 만들어놓은 것.

  const MainAppBar({
    required this.region,
    required this.status,
    required this.stat,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
    );

    return SliverAppBar(
      expandedHeight: 500,
      backgroundColor: status.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // padding - container 내부 Gap , margin - padding처럼 컨테이너 안이 아니라 밖에.
          margin: EdgeInsets.only(top: kToolbarHeight),
          // kToolbarHeight -> 정확히 AppBar로 사용하는 공간만 떨어지는 경우를 볼 수 있음.
          child: Column(
            children: [
              Text(
                region, // 따로 관리해줘야함.
                style: ts.copyWith(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DataUtils.getTimeFromDateTime(dateTime: stat.dataTime),
                style: ts.copyWith(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                status.imagePath,
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 20.0),
              Text(
                status.label,
                style: ts.copyWith(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                status.comment,
                style: ts.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
