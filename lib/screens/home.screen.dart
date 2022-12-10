import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:calendar_scheduler_study/constants.dart';
import 'package:calendar_scheduler_study/database/drift_database.dart';
import 'package:calendar_scheduler_study/widgets/calendar.dart';
import 'package:calendar_scheduler_study/widgets/schedule_card.dart';
import 'package:calendar_scheduler_study/widgets/today_banner.dart';

import '../widgets/schedule_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @NOTE 07 timezone 일치
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: spaceSize / 2),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            const SizedBox(height: spaceSize / 2),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spaceSize / 2),
                child: _ScheduleList(selectedDate: selectedDay),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _AddButton(
        selectedDay: selectedDay,
        onAddSchedule: onAddSchedule,
      ),
    );
  }

  /// table calendar 날짜 선택했을때 동작
  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  /// 일정 추가
  ///
  /// ScheduleForm을 포함한 bottomSheet을 띄운다.
  onAddSchedule() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // bottomSheet가 화면 절반높이 제한을 넘을 수 있도록 해줌
      elevation: 3,
      builder: (_) => SafeArea(
        child: ScheduleForm(
          selectedDate: selectedDay,
        ),
      ),
    );
  }
}

/// 일정을 추가하기 위한 Floating button
class _AddButton extends StatelessWidget {
  final VoidCallback onAddSchedule;

  const _AddButton({
    Key? key,
    required this.onAddSchedule,
    required this.selectedDay,
  }) : super(key: key);

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onAddSchedule,
      child: const Icon(Icons.add),
    );
  }
}

/// selectedDay에 해당하는 일정 목록
class _ScheduleList extends StatefulWidget {
  final DateTime selectedDate;

  const _ScheduleList({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<_ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<_ScheduleList> {
  List<CategoryColor> categories = [];

  @override
  void initState() {
    super.initState();
    getCategories(); // @NOTE 08 category color 바인딩을 위해 미리 목록을 불러옴.
  }

  Future<void> getCategories() async {
    categories = await GetIt.I<LocalDatabase>().getCategoryColors();
  }

  @override
  Widget build(BuildContext context) {
    // @NOTE 07-1 timezone 확인
    print('date: ${widget.selectedDate}');
    return StreamBuilder<List<Schedule>>(
        // @NOTE 06-3 stream 으로 일정 목록 읽어와 렌더링
        stream: GetIt.I<LocalDatabase>().watchSchedules(widget.selectedDate),
        builder: (context, snapshot) {
          // @NOTE 06-4 data가 없을때 예외 처리
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('일정이 없습니다.'),
            );
          }

          // print('data : ${snapshot.data}');

          return ListView.separated(
            itemBuilder: (context, index) {
              final item = snapshot.data![index]; // @NOTE 06-5 데이터 사용
              Color color = Colors.black;

              // @NOTE 08-1 category color 바인딩
              if (categories.isNotEmpty) {
                final category = categories.where((x) => x.id == item.colorId).first;
                color = Color(int.parse('FF${category.hexCode}', radix: 16));
              }

              return ScheduleCard(
                startTime: item.startTime,
                endTime: item.endTime,
                content: item.content,
                color: color,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: spaceSize / 4),
            itemCount: snapshot.data!.length, // @NOTE 06-5 데이터 사용
          );
        });
  }
}
