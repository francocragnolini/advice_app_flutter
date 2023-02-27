import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:advice_flutter_app/3_application/core/services/theme_service.dart';

import 'package:advice_flutter_app/3_application/pages/advice/bloc/advicer_bloc.dart';

import 'package:advice_flutter_app/3_application/pages/advice/widgets/advice_field.dart';
import 'package:advice_flutter_app/3_application/pages/advice/widgets/custom_button.dart';
import 'package:advice_flutter_app/3_application/pages/advice/widgets/error_message.dart';

import '../../../injection.dart';

class AdvicerPageWrapperProvider extends StatelessWidget {
  const AdvicerPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdvicerBloc>(),
      child: const AdvicerPage(),
    );
  }
}

class AdvicerPage extends StatelessWidget {
  const AdvicerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advice",
          style: themeData.textTheme.headline1,
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: Provider.of<ThemeService>(context).isDarkModeOn,
            onChanged: (_) {
              Provider.of<ThemeService>(context, listen: false).toggleTheme();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<AdvicerBloc, AdvicerState>(
                  builder: (context, state) {
                    if (state is AdvicerInitial) {
                      return Text(
                        "Your Advice is waiting for you",
                        style: themeData.textTheme.headline1,
                      );
                    } else if (state is AdvicerStateLoading) {
                      return CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                      );
                    } else if (state is AdvicerStateLoaded) {
                      return AdviceField(advice: state.advice);
                    } else if (state is AdvicerStateError) {
                      return ErrorMessage(message: state.message);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            /*ErrorMessage(message: "Uupss Something went wrong")*/
            /*AdviceField(
                      advice: "example advice - your day will be good")*/
            /*CircularProgressIndicator(
                color: themeData.colorScheme.secondary,
              )*/
            /*Text(
                  "Your Advice is waiting for you",
                  style: themeData.textTheme.headline1,
                ),*/
            const SizedBox(height: 200, child: Center(child: CustomButton())),
          ],
        ),
      ),
    );
  }
}
