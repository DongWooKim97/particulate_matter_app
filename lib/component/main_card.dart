import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MainCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const MainCard({
    required this.backgroundColor,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      // 양쪽에 다 설정할 수 있는게 symnetric
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(// 카드를 한번에 깎기
            Radius.circular(16.0) // 카드를 한번에 깎기
            ),
      ),
      color: backgroundColor,
      child: child,
    );
  }
}
