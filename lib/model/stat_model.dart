import 'package:hive_flutter/hive_flutter.dart';

part 'stat_model.g.dart';

@HiveType(typeId: 2)
enum ItemCode {
  @HiveField(0)
  PM10,

  @HiveField(1)
  PM25,

  @HiveField(2)
  NO2,

  @HiveField(3)
  O3,

  @HiveField(4)
  CO,

  @HiveField(5)
  SO2,
}

// 숫자 중복을 시키면 같은 타입이라고 인식하기 때문에 말도 안되는 상황이 펼쳐진다.
// 속성들을 다 decoration해줘야함. @HiveField(Index)
// 그러나 HiveType이 같은 곳에서만 HiveField또한 중복되면 안된다.
@HiveType(typeId: 1) // 타입Id에 숫자(Int)를 넣어줘야함. -> 절대로 중복되면 안됨
class StatModel {
  // 키-값 전부 매핑!!
  @HiveField(0)
  final double daegu;

  @HiveField(1)
  final double chungnam;

  @HiveField(2)
  final double incheon;

  @HiveField(3)
  final double daejeon;

  @HiveField(4)
  final double gyeongbuk;

  @HiveField(5)
  final double sejong;

  @HiveField(6)
  final double gwangju;

  @HiveField(7)
  final double jeonbuk;

  @HiveField(8)
  final double gangwon;

  @HiveField(9)
  final double ulsan;

  @HiveField(10)
  final double jeonnam;

  @HiveField(11)
  final double seoul;

  @HiveField(12)
  final double busan;

  @HiveField(13)
  final double jeju;

  @HiveField(14)
  final double chungbuk;

  @HiveField(15)
  final double gyeongnam;

  @HiveField(16)
  final double gyeonggi;

  @HiveField(17)
  final DateTime dataTime;

  @HiveField(18)
  final ItemCode itemCode;

  // 한번 등록하면 절대 HiveField의 Index숫자를 바꾸어선 안된다.
  // 만약 바꾸면 Hive안에서 혼동이 일어나서, 필드를 생성하거나 지웠다고 치면 그 인덱스는 없는 값이라고 생각해야함.
  // 만약, Hive를 사용한다면 기본 생성자가 있어야한다. 대부분의 Code Generation을 지원하는 라이브러리들의 필수적인 기능이다.
  StatModel({
    required this.daegu,
    required this.chungnam,
    required this.incheon,
    required this.daejeon,
    required this.gyeongbuk,
    required this.sejong,
    required this.gwangju,
    required this.jeonbuk,
    required this.gangwon,
    required this.ulsan,
    required this.jeonnam,
    required this.seoul,
    required this.busan,
    required this.jeju,
    required this.chungbuk,
    required this.gyeongnam,
    required this.gyeonggi,
    required this.dataTime,
    required this.itemCode,
  });

  //JSON형태에서부터 데이터를 받아온다.
  //json이라는 named 파라미터에다가 값만 넣어주면 바로 StatModel을 만들어낼 수 있따.
  //response값에서 우리가 원하는 값만 넣어주면 된다.
  // 개발자들의 약속임. json으로 부터 데이터를 받아서 이러한 형태를 형성할거면, 아래와 같이 사용해야한다.
  // 근데 이게 지금보니 Json화 시키는게 아니라, 클래스의 인스턴스를 생성하는 한마디로 Named Constructor이다.
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

  double getLevelFromRegion(String region) {
    if (region == '서울') {
      return seoul;
    } else if (region == '경기') {
      return gyeonggi;
    } else if (region == '대구') {
      return daegu;
    } else if (region == '충남') {
      return chungnam;
    } else if (region == '인천') {
      return incheon;
    } else if (region == '대전') {
      return daejeon;
    } else if (region == '경북') {
      return gyeongbuk;
    } else if (region == '세종') {
      return sejong;
    } else if (region == '광주') {
      return gwangju;
    } else if (region == '전북') {
      return jeonbuk;
    } else if (region == '강원') {
      return gangwon;
    } else if (region == '울산') {
      return ulsan;
    } else if (region == '전남') {
      return jeonnam;
    } else if (region == '부산') {
      return busan;
    } else if (region == '제주') {
      return jeju;
    } else if (region == '충북') {
      return chungbuk;
    } else if (region == '경남') {
      return gyeongnam;
    } else {
      throw Exception('알 수 없는 지역입니다.');
    }
  }
}

// 왜 Constructor에 저런식으로 넣어줬냐?
// 앞으로도 자주 사용되기 떄문에 ~~.fromJson이라고 작성하면 손쉽게 ~~클래스의 인스턴스를 만들 수 있기 때문이다.

// 만약 null값이 들어오면 0이라고 가정하자(앱 별로 정책이 다름) -> 우리가 정하는것.

// 굳이 클래스를 써서 OOP를 해야하는 건가?에 대한 의문.
// 우선 Map을 쓰면 키값이 뭐가 들어있는지 알 수 없다.
// 클래스로 정의해놓으면 어떤 값이 들어가고 어떤 값이 들어갈 수 없는지 명확하기 때문에 좋다.
// 따라서 클래스로 정의해놓는게 협업에도 좋다. 직관적이여서!
