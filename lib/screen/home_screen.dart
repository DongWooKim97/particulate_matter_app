import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:particulate_matter_app/component/category_card.dart';
import 'package:particulate_matter_app/component/hourly_card.dart';
import 'package:particulate_matter_app/component/main_app_bar.dart';
import 'package:particulate_matter_app/model/stat_and_status_model.dart';
import 'package:particulate_matter_app/model/stat_model.dart';
import 'package:particulate_matter_app/repository/stat_repository.dart';
import 'package:particulate_matter_app/utils/data_utils.dart';

import '../component/main_drawer.dart';
import '../constant/regions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // initState에서 모든 Listener들을 등록한다.
    super.initState();
    scrollController.addListener((scrollListener));
  }

  @override
  void dispose() {
    scrollController.removeListener((scrollListener));
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    // Future를 리턴해주는 것은 함수가 async 함수이다 라는 것의 반증.
    List<Future> futures = []; // await하지 않은 함수들을 여기에 넣을 수 있음.

    for (ItemCode itemCode in ItemCode.values) {
      futures.add(
        StatRepository.fetchData(
          // StatRepository에서는 ItemCode에 해당하는 값들을 List로 넘겨줌.
          itemCode: itemCode,
        ),
      );
    }

    /*
      여기부터 아래 코드가 정부API를 통해 가져온 데이터들을 Hive에 넣고 그것을 이용하는 코드이다.
     */

    final results = await Future.wait(futures); // 이 리스트 안에 들어가있는 모든 Future이 끝날 떄까지 한번에 기다릴 수있다.
    // await를 하면 futures에 들어가있던 모든 값들이 순서대로 들어온다.
    // 즉 results의 순서는 futures에 넣었던 순서대로 결과값을 받는다. 또한 해당 값들을 ItemCode(PM10, PM25, .. ,)같은 것들의 순서대로 들어갔다.
    // 그랬기 떄문에 아래에서 ItemCode.values[i] 와 results[i]에서 값을 얻을 수 있다.

    // Hive에 데이터 넣기.
    for (int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i];
      final value = results[i];

      final box = Hive.box<StatModel>(key.name);
      for (StatModel stat in value) {
        box.put(stat.dataTime.toString(), stat);
      }
    }
  }

  scrollListener() {
    // 현재 스크롤하는 위치가 어딘지 정확히 알 수 있다. expandedHeight(500)에서 Appbar의 높이를 뺴야한다.
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      // 어떤 Hive의 Box를 리스닝하고 있어야할까? -> 바로 미세먼지. 미세먼지 값을 통해 색을 정하고 그러기 때문.
      valueListenable: Hive.box(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        final recentStat = box.values.toList().first as StatModel;
        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: recentStat.getLevelFromRegion(region), // 첫번째 StatModel을 가져올 수 있음
          itemCode: ItemCode.PM10,
        );

        return Scaffold(
          drawer: MainDrawer(
            darkColor: status.darkColor,
            lightColor: status.lightColor,
            selectedRegion: region,
            onRegionTap: (String region) {
              setState(() {
                this.region = region;
              });
              Navigator.of(context).pop(); // 화면에서 뒤로가기를 할 떄 사용하던 방식!
            },
          ),
          body: Container(
            color: status.primaryColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                MainAppBar(
                  isExpanded: isExpanded,
                  region: region,
                  stat: recentStat,
                  status: status,
                  dateTime: recentStat.dataTime,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryCard(
                        region: region,
                        darkColor: status.darkColor,
                        lightColor: status.lightColor,
                      ),
                      SizedBox(height: 16.0),
                      ...ItemCode.values.map((itemCode) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: HourlyCard(
                            darkColor: status.darkColor,
                            lightColor: status.lightColor,
                            itemCode: itemCode,
                            region: region,
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 16.0),
                    ],
                  ), // 안에 들어가는 위젯들은 다 Sliver화 돼서 들어감.
                ),
              ],
            ),
          ),
        );
      },
    );

    return SafeArea(
      child: ValueL<Map<ItemCode, List<StatModel>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          //에러가 있을 때
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('에러가 있습니다.'),
              ),
            );
          }

          if (!snapshot.hasData) {
            //로딩 상태 -> 데이터가 없을 떄 데이터를 받아오기 위한 로딩상태!
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // 이건 가장 최근 데이터 . 가장 최근 데이터를 기준으로 우리가 statusLevel이 어느 구간인지를 산정해야함. 맨아래참조.
          Map<ItemCode, List<StatModel>> stats = snapshot.data!;
          StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

          // 미세먼지 최근 데이터의 현재 상태
          final status = DataUtils.getStatusFromItemCodeAndValue(
            value: pm10RecentStat.seoul,
            itemCode: ItemCode.PM10,
          );

          final ssModel = stats.keys.map((key) {
            final value = stats[key]!;
            final stat = value[0];

            return StatAndStatusModel(
              itemCode: key,
              status: DataUtils.getStatusFromItemCodeAndValue(
                  value: stat.getLevelFromRegion(region), itemCode: key),
              stat: stat,
            );
          }).toList();
        },
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

// 70번쨰 줄 이해

/*
            Map<ItemCode, List<StatModel>> stats = snapshot.data!;
            // 이건 가장 최근 데이터 . 가장 최근 데이터를 기준으로 우리가 statusLevel이 어느 구간인지를 산정해야함. 맨아래참조.
            StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

 -> Map형태인데, ItemCode값들을 키값으로 넣고, 그 값들에 해당되는 데이터들을 List에 담음.
 -> 맵에다가 갖고오고 싶은 ItemCode를 값을 넣으면 해당하는 모든 통계들을 가져올 수 있느넋.
 -> 그중 0번 데이터를 가져오면 가장 최근 데이터를 가져오는 것이다.
 */

/*
statRepository는 작업을 6개를 모두 순서대로 실행하고있다.
await를 하면 다음 로직이 실행이 안됐음.
이런 요청을 아예 막는게 좋지만, 서버를 만질 수 없다면 방향을 돌려야한다.

-> 이 모든 요청들을 모두 await하지 않고, 요청을 한번에 모아서 동시에 다 보낸다음에
모든 요청에 대한 응답이 다 돌아오면 그때 다음 로직을 수행할 수 있도록 할 것.

지금 방식:
하나 요청 보내고 하나 응답 받고 x6

하고자 하는 방식 :
모든 요청을 동시에 빡 보내고
6개의 응답이 올때까지 기다릴거다.

수정 순서는
1. 모든 요청을 먼저 모으는 것부터 시작.
2. List<Future>  ~~   -> 이런식으로 선언하면 await하지 않은 함수들을 모을 수 있다.
3. Future.wait(List<Future>) --> Future.wait를 하고 파라미터에 Future들이 모여있는 리스트를 넘겨주면 해당 리스트가 한번에 모든 요청이 가고,
    모든 요청의 응답이 돌아올 때 까지 기다릴 수 있음.


★★★★★
    이해하기 편하게, await를 하면 값이 돌아올 때 까지 기다린다. 그러나 await를 하지않고 async만 사용했다면 값이 돌아오기 전에도
    for-loop를 돈다. 그래서 모든 요청을 for-loop에 의해 한번에 보내고
    await Future.wait(List<Future>)를 하면  for-loop에 의해 보내졌던 async한 응답을 여기서 모조리 기다린 후에 로직을 실행한다.
★★★★★

*/

// 하이브를 사용하는데, 굳이 fetchData를 사용해야하나?
// 하이브만 사용해도 자동으로UI가 변동되는것을 TestScreen에서 확인을 했는데도?
// 그래서 지금부터 로직을 조금은 변경할 것이다.

// 현재는 홈스크린 안에서 이 데이터를 모두 저희가 관리를 하면서 이 데이터가
// 하위 위젯으로 다 전달이 되게 설계해놓은 상태.
// 그러나 이제 모든 데이터를 전달하지는 않을 것이다.
// 어떻게 바꿀거임? -> 모든 위젯에서 공통적으로 필요한 부분만 저희가 이 홈스크린에서 제작을 해가지고 위젯들에
// 집어 넣어주고, 나머지 위젯별로 다르게 필요한 데이터들은 그 각각의 위젯 속에서 알아서
// 데이터를 가져오도록 할 것!
// 또한
