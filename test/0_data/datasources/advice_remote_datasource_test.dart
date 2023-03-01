import 'package:advice_flutter_app/0_data/exceptions/exceptions.dart';
import 'package:advice_flutter_app/0_data/models/advice_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';

import 'package:advice_flutter_app/0_data/datasources/advice_remote_datasource.dart';
import 'advice_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  group(
    "AdviceRemoteDataSource",
    () {
      group(
        "should return AdviceModel",
        () {
          test(
            "When client response was 200 and has valid data",
            () async {
              // creando las variables en base a lo que se necesia para simular el test
              final mockClient = MockClient();
              final adviceRemoteDataSourceUnderTest =
                  AdviceRemoteDatasourceImpl(client: mockClient);
              const responseBody = '{"advice": "test advice", "advice_id": 1}';

              // MockClient
              when(mockClient.get(
                  Uri.parse("https://api.flutter-community.com/api/v1/advice"),
                  headers: {
                    "content-type": 'application/json',
                    "Access-Control-Allow-Origin": "*",
                  })).thenAnswer((realInvocation) =>
                  Future.value(Response(responseBody, 200)));
              final result = await adviceRemoteDataSourceUnderTest
                  .getRandomAdviceFromApi();

              expect(result, AdviceModel(advice: "test advice", id: 1));
            },
          );
        },
      );
      group(
        "should throw",
        () {
          test(
            "A Server Exception when client response was not 200 ",
            () {
              final mockClient = MockClient();
              final adviceRemoteDataSourceUnderTest =
                  AdviceRemoteDatasourceImpl(client: mockClient);
              // doesn't matter the body response
              const responseBody = '';

              // MockClient
              when(mockClient.get(
                  Uri.parse("https://api.flutter-community.com/api/v1/advice"),
                  headers: {
                    "content-type": 'application/json',
                    "Access-Control-Allow-Origin": "*",
                  })).thenAnswer((realInvocation) =>
                  Future.value(Response(responseBody, 201)));

              expect(
                  () =>
                      adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
                  throwsA(isA<ServerException>()));
            },
          );

          test(
            "A Type Error when client response was 200 and has no valid data ",
            () {
              final mockClient = MockClient();
              final adviceRemoteDataSourceUnderTest =
                  AdviceRemoteDatasourceImpl(client: mockClient);
              // missing the advice_id
              const responseBody = '{advice:"test advice"}';

              // MockClient
              when(mockClient.get(
                  Uri.parse("https://api.flutter-community.com/api/v1/advice"),
                  headers: {
                    "content-type": 'application/json',
                    "Access-Control-Allow-Origin": "*",
                  })).thenAnswer((realInvocation) =>
                  Future.value(Response(responseBody, 201)));

              expect(
                  () =>
                      adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
                  throwsA(isA<ServerException>()));
            },
          );
        },
      );
    },
  );
}
