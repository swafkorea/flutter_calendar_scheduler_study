import 'package:calendar_scheduler_study/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int scheduleCount;

  const TodayBanner({
    Key? key,
    required this.selectedDay,
    required this.scheduleCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd'); // intl 사용한 포멧 정의
    const textStyle = TextStyle(
      color: Colors.white,
      // fontSize: 16.0,
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spaceSize, vertical: spaceSize / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateFormat.format(selectedDay), // 포멧 적용
              style: textStyle,
            ),
            Text(
              '$scheduleCount개',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
