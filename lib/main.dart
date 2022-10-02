import 'package:calendar_scheduler_study/screens/home.screen.dart';
import 'package:calendar_scheduler_study/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // @NOTE 01 main을 async로 변경할 때 필수
  await initializeDateFormatting(); // @NOTE 02 캘린더 다국어 지원

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Scheduler EX',
      debugShowCheckedModeBanner: false,
      theme: appTheme(context), // @NOTE 03 기본 테마
      home: const HomeScreen(),
    );
  }
}
