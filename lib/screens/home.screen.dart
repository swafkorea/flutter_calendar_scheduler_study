import 'package:calendar_scheduler_study/constants.dart';
import 'package:calendar_scheduler_study/widgets/calendar.dart';
import 'package:calendar_scheduler_study/widgets/schedule_card.dart';
import 'package:calendar_scheduler_study/widgets/today_banner.dart';
import 'package:flutter/material.dart';

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
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

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
