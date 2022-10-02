import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:calendar_scheduler_study/constants.dart';

class Calendar extends StatelessWidget {
  /// 선택한 날짜
  final DateTime? selectedDay;

  /// 캘린더가 테이블에 날짜를 렌더링할 때 기준이 되는 날짜
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
    /// default cell style
    final defaultBoxStyle = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    );

    /// default text style
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR', // @NOTE 11 한국어 로케일 지정 (main.dart에서 initializeDateFormatting() 필요함)
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
        outsideDecoration: const BoxDecoration(
            shape: BoxShape.rectangle), // @NOTE 12 circle은 borderRadius를 가질 수 없음
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(color: primaryColor),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: onDaySelected,
      selectedDayPredicate: (day) {
        // @NOTE 13 day가 선택한 날짜와 같은 조건인지 판별하여 bool을 리턴
        final localDay = selectedDay?.toLocal();
        return localDay?.year == day.year &&
            localDay?.month == day.month &&
            localDay?.day == day.day;
      },
    );
  }
}
