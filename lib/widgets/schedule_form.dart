import 'package:flutter/material.dart';

import 'package:calendar_scheduler_study/constants.dart';
import 'package:calendar_scheduler_study/widgets/custom_text_field.dart';

/// 일정 입력 폼
class ScheduleForm extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleForm({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // @NOTE 01 키패드가 차지하는 높이

    return GestureDetector(
      onTap: () {
        // @NOTE 05 text field 밖으로 포커스가 이동될 때 키보드 숨김
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
          color: Colors.white, // @NOTE 05-1 지정 안했을때 focus out 동작 확인
          height:
              MediaQuery.of(context).size.height / 2 + bottomInset, // @NOTE 01-1 키패드 만큼 사이즈를 늘여줌.
          child: Padding(
            padding: const EdgeInsets.all(spaceSize / 2)
                .copyWith(bottom: bottomInset), // @NOTE 01-2 하단 여백
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: CustomTextField(label: '시작 시간', isTime: true),
                    ),
                    SizedBox(width: spaceSize),
                    Expanded(
                      child: CustomTextField(label: '마감 시간', isTime: true),
                    ),
                  ],
                ),
                const SizedBox(height: spaceSize),
                const Expanded(child: CustomTextField(label: '내용')),
                const SizedBox(height: spaceSize),
                const _ColorPicker(),
                const SizedBox(height: spaceSize),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('저장'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @NOTE 04 item들 사이에 간격을 주기 위해서 wrap widget 사용
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: categoryColors
          .map(
            (e) => _ColorPickerItem(
              colorCode: e,
            ),
          )
          .toList(),
    );
  }
}

class _ColorPickerItem extends StatelessWidget {
  final String colorCode;

  const _ColorPickerItem({
    Key? key,
    required this.colorCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse('FF$colorCode', radix: 16),
        ),
      ),
      width: 32,
      height: 32,
    );
  }
}
