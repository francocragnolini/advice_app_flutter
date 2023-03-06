import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:advice_flutter_app/3_application/core/services/theme_service.dart';
import 'package:advice_flutter_app/3_application/pages/advice/bloc/advicer_bloc.dart';

import 'package:advice_flutter_app/3_application/pages/advice/advicer_page.dart';
import 'package:advice_flutter_app/3_application/pages/advice/widgets/advice_field.dart';
import 'package:advice_flutter_app/3_application/pages/advice/widgets/error_message.dart';

class MockAdvicerBloc extends MockCubit<AdvicerState> implements AdvicerBloc {}

void main() {
  Widget widgetUnderTest({required AdvicerBloc bloc}) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ThemeService(),
        child: BlocProvider<AdvicerBloc>(
          create: (context) => bloc,
          child: const AdvicerPage(),
        ),
      ),
    );
  }

  group(
    'AdvicerPage',
    () {
      late AdvicerBloc mockAdvicerBloc;

      setUp(
        () {
          mockAdvicerBloc = MockAdvicerBloc();
        },
      );
      group(
        'should be displayed in ViewState',
        () {
          testWidgets(
            'Initial when cubits emits AdvicerInitial()',
            (widgetTester) async {
              whenListen(
                mockAdvicerBloc,
                Stream.fromIterable([AdvicerInitial()]),
                initialState: AdvicerInitial(),
              );

              await widgetTester
                  .pumpWidget(widgetUnderTest(bloc: mockAdvicerBloc));

              final advicerInitalTextFinder =
                  find.text('Your Advice is waiting for you');

              expect(advicerInitalTextFinder, findsOneWidget);
            },
          );

          testWidgets(
            'Loading when cubits emits AdvicerStateLoading()',
            (widgetTester) async {
              whenListen(
                mockAdvicerBloc,
                Stream.fromIterable([AdvicerStateLoading()]),
                initialState: AdvicerInitial(),
              );

              await widgetTester
                  .pumpWidget(widgetUnderTest(bloc: mockAdvicerBloc));
              await widgetTester.pump();

              final advicerLoadingFinder =
                  find.byType(CircularProgressIndicator);

              expect(advicerLoadingFinder, findsOneWidget);
            },
          );

          testWidgets(
            'advice text when cubits emits AdvicerStateLoaded()',
            (widgetTester) async {
              whenListen(
                mockAdvicerBloc,
                Stream.fromIterable([AdvicerStateLoaded(advice: '42')]),
                initialState: AdvicerInitial(),
              );

              await widgetTester
                  .pumpWidget(widgetUnderTest(bloc: mockAdvicerBloc));
              await widgetTester.pump();

              final advicerLoadedStateFinder = find.byType(AdviceField);
              final adviceText = widgetTester
                  .widget<AdviceField>(advicerLoadedStateFinder)
                  .advice;

              expect(advicerLoadedStateFinder, findsOneWidget);
              expect(adviceText, '42');
            },
          );

          testWidgets(
            'Error when cubits emits AdvicerStateError()',
            (widgetTester) async {
              whenListen(
                mockAdvicerBloc,
                Stream.fromIterable([AdvicerStateError(message: 'error')]),
                initialState: AdvicerInitial(),
              );

              await widgetTester
                  .pumpWidget(widgetUnderTest(bloc: mockAdvicerBloc));
              await widgetTester.pump();

              final advicerErrorFinder = find.byType(ErrorMessage);

              expect(advicerErrorFinder, findsOneWidget);
            },
          );
        },
      );
    },
  );
}
