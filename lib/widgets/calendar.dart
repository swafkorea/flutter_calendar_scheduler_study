import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:calendar_scheduler_study/constants.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar({
    Key? key,
    this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBoxStyle = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(2000),
      lastDay: DateTime(3000),
      // calendarFormat: CalendarFormat.week,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
      daysOfWeekHeight: fontSize + spaceSize / 3,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: defaultBoxStyle,
        weekendDecoration: defaultBoxStyle,
        selectedDecoration: defaultBoxStyle.copyWith(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 1.0),
        ),
        outsideDecoration:
            const BoxDecoration(shape: BoxShape.rectangle), // @NOTE circle은 borderRadius를 가질 수 없음
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(color: primaryColor),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: onDaySelected,
      selectedDayPredicate: (day) {
        final localDay = selectedDay?.toLocal();
        return localDay?.year == day.year &&
            localDay?.month == day.month &&
            localDay?.day == day.day;
      },
    );
  }
}
