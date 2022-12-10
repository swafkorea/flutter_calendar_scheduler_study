import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calendar_scheduler_study/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue; // @NOTE 10-4 전달 받을 초기값
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.initialValue,
    this.isTime = false,
    required this.onSaved,
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
    // 2 - 01. TextFomrField 위젯은 validator 프로퍼티를 활용한 검증 기능을 사용한다
    // 모든 입력폼의 내용을 검증할 수 있다
    return TextFormField(
      // 4 - 01. 저장할때 실행되는 함수 onSaved 외부에서 받는다
      onSaved: onSaved,
      //null이 return되면 에러가 없다
      //에러가 있으면 에러를 String 값으로 리턴해준다

      // 3 - 01. Validation 모드
      // inputFormatter로 무조건 숫자로 들어갈 수 있음
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }

        if (isTime) {
          int time = int.parse(val);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          if (val.length > 500) {
            return '500자 이하의 글자를 입력해주세요';
          }
        }

        return null;
      },
      initialValue: initialValue, // @NOTE 10-4 초기값 설정
      // keyboard layout을 선택, 사용자의 입력값은 제약할 수 없음
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 사용자 입력값 제약
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      // multiline 관련 속성
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      decoration: InputDecoration(
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
