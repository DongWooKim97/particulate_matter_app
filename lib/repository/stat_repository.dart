import 'package:dio/dio.dart';

import '../constant/data.dart';
import '../model/stat_model.dart';

class StatRepository {

  static Future<List<StatModel>> fetchData() async {
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
      },
    );

    return response.data['response']['body']['items']
        .map<StatModel>(
          (item) => StatModel.fromJson(json: item),
        )
        .toList();
  }
}

// 어디서든 데이터를 가져와야할 때 StatRepository.fetchData를 사용하면 역직렬화(Json to Dart)된 코드를 얻을 수 있다.
// 또한 static 하게 선언됐기 때문에 아무데서나받을 수 있음.
