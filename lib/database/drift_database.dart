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

  Future<int> createSchedule(SchedulesCompanion data) => into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() => select(categoryColors).get();

  // @NOTE 06 stream을 리턴하는 메소드 생성
  Stream<List<Schedule>> watchSchedules(DateTime date) {
    // @NOTE 07-2 filter timezone 확인
    print('filter date : $date');
    final query = select(schedules)
      ..where((tbl) => tbl.date.equals(date)) // @NOTE 06-1 date로 필터링
      ..orderBy([(x) => OrderingTerm.asc(x.startTime)]); // @NOTE 06-2 날짜순 정렬

    return query.watch();
  }

  // @NOTE 09-1 delete method
  Future<int> removeSchedule(int id) => (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // @NOTE 10-1 update method
  Future<int> updateSchedule(int id, SchedulesCompanion form) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(form);

  // @NOTE 10-1 get schedule method
  Future<Schedule> getSchedule(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  @override
  int get schemaVersion => 1;
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
