import 'package:calendar_scheduler_study/database/drift_database.dart';
import 'package:calendar_scheduler_study/screens/home.screen.dart';
import 'package:calendar_scheduler_study/theme.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler_study/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ! 01 main을 async로 변경할 때 필수
  await initializeDateFormatting(); // ! 캘린더 다국어 지원

  // 1 - 01. main.dart에 LocalDatabase를 import
  // 데이터베이스에서 선언했던 모든 쿼리를 쓸 수 있음
  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  // 1 - 02. future return이니까 await를 작성
  final colors = await database.getCategoryColors();

  // 1 - 03. 불러운 colors라는 변수가 비었을 때 categoryColors라는
  // 리스트를 한번 순회해주면서 hexCode 값에 넣어주고 있음
  // insert를 할때 Value라는 값으로 감싸줘야 함
  if(colors.isEmpty){
    for(String hexCode in categoryColors){
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode)
        ),
      );
    }
  }

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
      theme: appTheme(context),
      home: const HomeScreen(),
    );
  }
}
