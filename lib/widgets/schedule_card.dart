import 'package:flutter/material.dart';

import '../constants.dart';

/// 일정 목록 아이템
class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: primaryColor,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(spaceSize / 2),
        child: Row(
          children: [
            _Time(startTime: startTime, endTime: endTime),
            const SizedBox(width: spaceSize),
            Expanded(child: Text(content)),
            const SizedBox(width: spaceSize),
            _Category(color: color)
          ],
        ),
      ),
    );
  }
}

/// 분류 색상 표시
class _Category extends StatelessWidget {
  const _Category({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 16,
      height: 16,
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({
    Key? key,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: primaryColor,
      fontSize: fontSize,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timeDigit(startTime),
          style: textStyle,
        ),
        Text(
          '~ ${timeDigit(endTime)}',
          style: textStyle.copyWith(fontSize: fontSize * 0.8), // 기본 스타일 override
        ),
      ],
    );
  }

  /// 일정 시각 포멧
  String timeDigit(int time) => '${time.toString().padLeft(2, '0')}:00';
}
