import 'dart:convert';

import 'package:advice_flutter_app/0_data/exceptions/exceptions.dart';
import "package:http/http.dart" as http;

import '../models/advice_model.dart';

abstract class AdviceRemoteDatasource {
  /// request random advice from api
  /// returns [AdviceModel] if successfull
  /// throws a server-exception if status code is not  200
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDatasourceImpl implements AdviceRemoteDatasource {
  final http.Client client;
  AdviceRemoteDatasourceImpl({required this.client});

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final response = await client.get(
        Uri.parse("https://api.flutter-community.com/api/v1/advice"),
        headers: {
          "content-type": 'application/json',
          "Access-Control-Allow-Origin": "*",
        });
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final responseBody = json.decode(response.body);
      return AdviceModel.fromJson(responseBody);
    }
  }
}
