import 'package:advice_flutter_app/0_data/repositories/advice_repo_impl.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';
import 'package:advice_flutter_app/1_domain/usecases/advice_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'advice_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRepoImpl>()])
void main() {
  group(
    "AdviceUsecases",
    () {
      group(
        "should return an AdviceEntity",
        () {
          test(
            "when AdviceRepoImpl returns AdviceModel",
            () async {
              final mockAdviceRepoImpl = MockAdviceRepoImpl();
              final adviceUseCaseUnderTest =
                  AdviceUsecases(adviceRepo: mockAdviceRepoImpl);

              when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
                  (realInvocation) => Future.value(
                      const Right(AdviceEntity(advice: 'test', id: 42))));

              final result = await adviceUseCaseUnderTest.getAdvice();

              expect(result.isLeft(), false);
              expect(result.isRight(), true);
              expect(
                  result,
                  const Right<Failure, AdviceEntity>(
                      AdviceEntity(advice: 'test', id: 42)));
              verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(
                  1); // when you want to check if a method was not call use verifyNever(mock.methodCall) instead .called(0)
              verifyNoMoreInteractions(mockAdviceRepoImpl);
            },
          );
        },
      );
      group(
        "should return left",
        () {
          test(
            "When Server failure",
            () async {
              final mockAdviceRepoImpl = MockAdviceRepoImpl();
              final adviceUseCaseUnderTest =
                  AdviceUsecases(adviceRepo: mockAdviceRepoImpl);

              when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
                  (realInvocation) => Future.value(Left(ServerFailure())));

              final result = await adviceUseCaseUnderTest.getAdvice();

              expect(result.isLeft(), true);
              expect(result.isRight(), false);
              expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
              verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(1);
              verifyNoMoreInteractions(mockAdviceRepoImpl);
            },
          );
          test('when a GeneralFailure', () async {
            // arrange
            final mockAdviceRepoImpl = MockAdviceRepoImpl();
            final adviceUseCaseUnderTest =
                AdviceUsecases(adviceRepo: mockAdviceRepoImpl);

            when(mockAdviceRepoImpl.getAdviceFromDataSource()).thenAnswer(
                (realInvocation) => Future.value(Left(GeneralFailure())));

            // act
            final result = await adviceUseCaseUnderTest.getAdvice();

            // assert
            expect(result.isLeft(), true);
            expect(result.isRight(), false);
            expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
            verify(mockAdviceRepoImpl.getAdviceFromDataSource()).called(1);
            verifyNoMoreInteractions(mockAdviceRepoImpl);
          });
        },
      );
    },
  );
}
