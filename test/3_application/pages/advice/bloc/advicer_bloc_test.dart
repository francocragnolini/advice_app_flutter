import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';
import 'package:advice_flutter_app/1_domain/usecases/advice_usecases.dart';
import 'package:advice_flutter_app/3_application/pages/advice/bloc/advicer_bloc.dart';

class MockAdviceUseCases extends Mock implements AdviceUsecases {}

void main() {
  group('AdvicerBloc', () {
    group('should emits', () {
      MockAdviceUseCases mockAdviceUseCases = MockAdviceUseCases();
      blocTest(
        'nothing when no method is called',
        build: () => AdvicerBloc(mockAdviceUseCases),
        expect: () => const <AdvicerState>[],
      );

      blocTest(
        '[AdvicerStateLoading, AdvicerStateLoaded] when AdviceRequestedEvent() is called',
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
          (invocation) => Future.value(
            const Right<Failure, AdviceEntity>(
              AdviceEntity(advice: 'advice', id: 1),
            ),
          ),
        ),
        build: () => AdvicerBloc(mockAdviceUseCases),
        act: (bloc) => bloc.add(AdviceRequestedEvent()),
        // wait: const Duration(seconds: 3),
        expect: () => <AdvicerState>[
          AdvicerStateLoading(),
          AdvicerStateLoaded(advice: "advice")
        ],
      );
      group(
        "AdvicerStateLoading, AdvicerStateError when adviceRequested() is called",
        () {
          blocTest(
            'and a ServerFailure occors',
            setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
              (invocation) => Future.value(
                Left<Failure, AdviceEntity>(
                  ServerFailure(),
                ),
              ),
            ),
            build: () => AdvicerBloc(mockAdviceUseCases),
            act: (bloc) => bloc.add(AdviceRequestedEvent()),
            expect: () => <AdvicerState>[
              AdvicerStateLoading(),
              AdvicerStateError(message: serverFailure),
            ],
          );

          blocTest(
            "A Cache failure occors",
            setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
              (invocation) => Future.value(
                Left<Failure, AdviceEntity>(
                  CacheFailure(),
                ),
              ),
            ),
            build: () => AdvicerBloc(mockAdviceUseCases),
            act: (bloc) => bloc.add(AdviceRequestedEvent()),
            expect: () => <AdvicerState>[
              AdvicerStateLoading(),
              AdvicerStateError(message: cacheFailure),
            ],
          );
          blocTest(
            "A General failure occors",
            setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
              (invocation) => Future.value(
                Left<Failure, AdviceEntity>(
                  GeneralFailure(),
                ),
              ),
            ),
            build: () => AdvicerBloc(mockAdviceUseCases),
            act: (bloc) => bloc.add(AdviceRequestedEvent()),
            expect: () => <AdvicerState>[
              AdvicerStateLoading(),
              AdvicerStateError(message: generalFailure),
            ],
          );
        },
      );
    });
  });
}
