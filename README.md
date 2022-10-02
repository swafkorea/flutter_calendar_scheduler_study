# 캘린더 스케쥴러

플러터 스터디 실습

## Collaborators
  - windy
  - 핑구플리

## Dependencies
  - google_fonts
  - drift
  - intl
  - path
  - path_provider
  - sqlite3_flutter_libs
  - table_calendar

  ~~~
  google_fonts, drift, intl, path, path_provider, sqlite3_flutter_libs, table_calendar
  ~~~


### Dev dependencies
  - build_runner
  - drift_dev

  ~~~
  build_runner, drift_dev
  ~~~
  > [path, path_provider, sqlite3_flutter_libs, build_runner, drift_dev]는 drift 사용에 필요한 패키지

  > get_it 패키지 검토 : 종속성 주입

## File structures
~~~
lib/
  models/
    - schedule.model.dart
    - ...
  screens/
    - home.screen.dart
  widgets/
    - calendar.dart
    - schedule_card.dart
    - ...
  main.dart
  constants.dart
  theme.dart
~~~