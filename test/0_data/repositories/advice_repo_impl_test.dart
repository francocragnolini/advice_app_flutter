import 'package:advice_flutter_app/0_data/exceptions/exceptions.dart';
import 'package:advice_flutter_app/0_data/models/advice_model.dart';
import 'package:advice_flutter_app/0_data/repositories/advice_repo_impl.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'package:advice_flutter_app/0_data/datasources/advice_remote_datasource.dart';
import 'advice_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRemoteDatasourceImpl>()])
void main() {
  group(
    "AdviceRepoImpl",
    () {
      group(
        "Should return AdviceEntity",
        () {
          test(
            "When AdviceRemoteDataSource returns a AdviceModel",
            () async {
              final mockAdviceRemoteDatasource =
                  MockAdviceRemoteDatasourceImpl();
              final adviceRepoImplUnderTest = AdviceRepoImpl(
                  adviceRemoteDatasource: mockAdviceRemoteDatasource);

              when(mockAdviceRemoteDatasource.getRandomAdviceFromApi())
                  .thenAnswer((realInvocation) =>
                      Future.value(AdviceModel(advice: 'test', id: 42)));

              final result =
                  await adviceRepoImplUnderTest.getAdviceFromDataSource();

              expect(result.isLeft(), false);
              expect(result.isRight(), true);
              expect(
                  result,
                  Right<Failure, AdviceModel>(
                      AdviceModel(advice: 'test', id: 42)));
              verify(mockAdviceRemoteDatasource.getRandomAdviceFromApi())
                  .called(1);
              verifyNoMoreInteractions(mockAdviceRemoteDatasource);
            },
          );
        },
      );
      group(
        "should return left",
        () {
          test('a ServerFailure when a ServerException occurs', () async {
            final mockAdviceRemoteDatasource = MockAdviceRemoteDatasourceImpl();
            final adviceRepoImplUnderTest = AdviceRepoImpl(
                adviceRemoteDatasource: mockAdviceRemoteDatasource);

            when(mockAdviceRemoteDatasource.getRandomAdviceFromApi())
                .thenThrow(ServerException());

            final result =
                await adviceRepoImplUnderTest.getAdviceFromDataSource();

            expect(result.isLeft(), true);
            expect(result.isRight(), false);
            expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
          });

          test('a GeneralFailure on all other Exceptions', () async {
            final mockAdviceRemoteDatasource = MockAdviceRemoteDatasourceImpl();
            final adviceRepoImplUnderTest = AdviceRepoImpl(
                adviceRemoteDatasource: mockAdviceRemoteDatasource);

            when(mockAdviceRemoteDatasource.getRandomAdviceFromApi())
                .thenThrow(ServerException());

            final result =
                await adviceRepoImplUnderTest.getAdviceFromDataSource();

            expect(result.isLeft(), true);
            expect(result.isRight(), false);
            expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
          });
        },
      );
    },
  );
}
