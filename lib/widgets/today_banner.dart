import 'package:calendar_scheduler_study/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../database/drift_database.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner({
    Key? key,
    required this.selectedDay,
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
            // @NOTE 06-6 stream 으로 일정 목록 읽어와 렌더링
            StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
              builder: (context, snapshot) {
                int count = 0;

                if (snapshot.hasData) count = snapshot.data!.length;

                return Text(
                  '$count개',
                  style: textStyle,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
