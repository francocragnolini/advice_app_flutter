import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';
import 'package:advice_flutter_app/1_domain/usecases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";

part 'advicer_event.dart';
part 'advicer_state.dart';

const serverFailure = 'Ups, Api Error, please try again!';
const cacheFailure = 'Ups, cache failed, please try again!';
const generalFailure = "Ups, something went wrong, please try again!";

class AdvicerBloc extends Bloc<AdvicerEvent, AdvicerState> {
  AdvicerBloc() : super(AdvicerInitial()) {
    // usecases
    final AdviceUsecases adviceUsecases = AdviceUsecases();
    // you can also use other usecases in this place for example: authentication

    on<AdviceRequestedEvent>((event, emit) async {
      emit(AdvicerStateLoading());
      // getting the advice or a failure from the adviceUsecases
      final faliureOrAdvice = await adviceUsecases.getAdvice();
      faliureOrAdvice.fold(
        (failure) =>
            emit(AdvicerStateError(message: _mapFailureToMessage(failure))),
        (advice) => emit(AdvicerStateLoaded(advice: advice.advice)),
      );
    });

    // on<AdviceRequestedEvent>((event, emit) async {
    //   // when the user press the button
    //   //1- start loading spinner
    //   emit(AdvicerStateLoading());
    //   //2- execute some business logic
    //   // for example get an advice
    //   debugPrint("fake get advice triggered");
    //   await Future.delayed(const Duration(seconds: 3), (() {}));
    //   debugPrint("got advice");
    //   emit(AdvicerStateLoaded(advice: "fake advice to test bloc"));
    //   // emit(AdvicerStateError(message: "error message"));
    // });
  }

  String _mapFailureToMessage(Failure failure) {
    // with runtimeType we get the type of the failure
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailure;
      case CacheFailure:
        return cacheFailure;
      default:
        return generalFailure;
    }
  }
}
