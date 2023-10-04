import 'dart:convert';

enum ItemCode {
  //미세먼지
  PM10,
  //초미세먼지
  PM25,
  //이산화질소
  NO2,
  //오존
  O3,
  //일산화탄소
  CO,
  // 이황산가스
  SO2,
}

class StatModel {
  // 키-값 전부 매핑!!
  final double daegu;
  final double chungnam;
  final double incheon;
  final double daejeon;
  final double gyeongbuk;
  final double sejong;
  final double gwangju;
  final double jeonbuk;
  final double gangwon;
  final double ulsan;
  final double jeonnam;
  final double seoul;
  final double busan;
  final double jeju;
  final double chungbuk;
  final double gyeongnam;
  final DateTime dataTime;
  final ItemCode itemCode;
  final double gyeonggi;

  //JSON형태에서부터 데이터를 받아온다.
  //json이라는 named 파라미터에다가 값만 넣어주면 바로 StatModel을 만들어낼 수 있따.
  //response값에서 우리가 원하는 값만 넣어주면 된다.
  // 개발자들의 약속임. json으로 부터 데이터를 받아서 이러한 형태를 형성할거면, 아래와 같이 사용해야한다.
  StatModel.fromJson({required Map<String, dynamic> json})
      : daegu = double.parse(json['daegu'] ?? '0'),
        chungnam = double.parse(json['chungnam'] ?? '0'),
        incheon = double.parse(json['incheon'] ?? '0'),
        daejeon = double.parse(json['daejeon'] ?? '0'),
        gyeongbuk = double.parse(json['gyeongbuk'] ?? '0'),
        jeonbuk = double.parse(json['jeonbuk'] ?? '0'),
        sejong = double.parse(json['sejong'] ?? '0'),
        gwangju = double.parse(json['gwangju'] ?? '0'),
        gangwon = double.parse(json['gangwon'] ?? '0'),
        ulsan = double.parse(json['ulsan'] ?? '0'),
        jeonnam = double.parse(json['jeonnam'] ?? '0'),
        seoul = double.parse(json['seoul'] ?? '0'),
        busan = double.parse(json['busan'] ?? '0'),
        jeju = double.parse(json['jeju'] ?? '0'),
        chungbuk = double.parse(json['chungbuk'] ?? '0'),
        gyeongnam = double.parse(json['gyeongnam'] ?? '0'),
        dataTime = DateTime.parse(json['dataTime']),
        itemCode = parseItemCode(json['itemCode']),
        gyeonggi = double.parse(json['gyeonggi'] ?? '0');

  //ItemCode.NO2.toString() ->'ItemCode.NO2.toString()'
  //ItemCode.NO2.name => 'NO2'
  static ItemCode parseItemCode(String raw) {
    if (raw == 'PM2.5') return ItemCode.PM25;

    return ItemCode.values.firstWhere((element) => element.name == raw);
  }
}

// 왜 Constructor에 저런식으로 넣어줬냐?
// 앞으로도 자주 사용되기 떄문에 ~~.fromJson이라고 작성하면 손쉽게 ~~클래스의 인스턴스를 만들 수 있기 때문이다.

// 만약 null값이 들어오면 0이라고 가정하자(앱 별로 정책이 다름) -> 우리가 정하는것.
