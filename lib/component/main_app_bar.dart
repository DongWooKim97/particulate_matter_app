import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ts = const TextStyle(
      color: Colors.white,
      fontSize: 30.0,
    );

    return SliverAppBar(
      expandedHeight: 500,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // padding - container 내부 Gap , margin - padding처럼 컨테이너 안이 아니라 밖에.
          margin: EdgeInsets.only(top: kToolbarHeight),
          // kToolbarHeight -> 정확히 AppBar로 사용하는 공간만 떨어지는 경우를 볼 수 있음.
          child: Column(
            children: [
              Text(
                '서울',
                style: ts.copyWith(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DateTime.now().toString(),
                style: ts.copyWith(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                'asset/img/mediocre.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 20.0),
              Text(
                '보통',
                style: ts.copyWith(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '나쁘지 않네요!',
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
