import 'package:flutter/material.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
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
          ],
        ),
      ),
    );
  }
}
