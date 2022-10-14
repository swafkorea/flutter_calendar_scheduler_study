import 'package:flutter/material.dart';

import 'package:calendar_scheduler_study/constants.dart';
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
  DateTime selectedDay = DateTime(
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
              scheduleCount: 4,
            ),
            const SizedBox(height: spaceSize / 2),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spaceSize / 2),
                child: _ScheduleList(),
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
      isScrollControlled: true, // @NOTE 02 bottomSheet가 화면 절반높이 제한을 넘을 수 있도록 해줌
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
class _ScheduleList extends StatelessWidget {
  const _ScheduleList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return const ScheduleCard(
          startTime: 9,
          endTime: 14,
          content: 'Test',
          color: Colors.teal,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: spaceSize / 4),
      itemCount: 8,
    );
  }
}
