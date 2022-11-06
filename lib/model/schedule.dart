import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성날짜
  //clientDefault => Flutter Framework에서 Column의 기본값으로 지정해주는 것
  //값을 안넣어줬을떄만 실행이 된다

  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
  )();
}