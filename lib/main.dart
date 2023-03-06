import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'injection.dart' as di; // dependency injection
import '3_application/core/services/theme_service.dart';
import 'package:advice_flutter_app/theme.dart';

import 'package:advice_flutter_app/3_application/pages/advice/advicer_page.dart';

void main() async {
  // ! dependecy injection
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  // ! dependecy injection
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, themeService, child) {
      return MaterialApp(
        themeMode: themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const AdvicerPageWrapperProvider(),
      );
    });
  }
}
