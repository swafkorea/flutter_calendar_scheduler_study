// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calendar_scheduler_study/model/category_color.dart';
import 'package:calendar_scheduler_study/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


// 데이터베이스를 연결할 코드를 작성할 drift_datgabase.dart를 생성
// part는 private 값까지 불러올 수 있다
// g는 generate라는 뜻
part 'drift_database.g.dart';

// Decorator => ex)@Override
// 어떤 클래스들을 테이블로 쓸지 불러오기
@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// _$LocalDataBase는 drift가 생성해준다. _가 붙어있기 떄문에 Private 값
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
}

// getApplicationDocumentsDirectory는
// 앱을 어떤 경로에 설치했을때 앱 전용으로 사용할 수 있는 폴더 위치를 가져올 수 있다
// dbFolder.path를 가져와 실제 경로를 가져오고 db.sqlite 파일을 생성해준다
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}