import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calendar_scheduler_study/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: primaryColor),
        ),
        isTime ? renderTextField() : Expanded(child: renderTextField()),
      ],
    );
  }

  Widget renderTextField() {
    return TextField(
      // @NOTE 06-1 keyboard layout을 선택, 사용자의 입력값은 제약할 수 없음
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // @NOTE 06-2 사용자 입력값 제약
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      // @NOTE 07 multiline 관련 속성
      maxLines: isTime ? 1 : null,
      expands: !isTime,
    );
  }
}
