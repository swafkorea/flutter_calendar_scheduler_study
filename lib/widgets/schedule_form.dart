import 'package:calendar_scheduler_study/database/drift_database.dart';
import 'package:calendar_scheduler_study/model/category_color.dart';
import 'package:flutter/material.dart';

import 'package:calendar_scheduler_study/constants.dart';
import 'package:calendar_scheduler_study/widgets/custom_text_field.dart';
import 'package:calendar_scheduler_study/database/drift_database.dart';
import 'package:get_it/get_it.dart';

/// 일정 입력 폼
class ScheduleForm extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleForm({
    Key? key,
    required this.selectedDate,
  }) : super(
          key: key,
        );

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
          ),
        ),
        SizedBox(width: spaceSize),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({
    required this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

class _ScheduleFormState extends State<ScheduleForm> {

  // 2 - 03. Form의 상태를 갖고있는 키(컨트롤러)
  final GlobalKey<FormState> formKey = GlobalKey();

  // 4 -03. 세 개의 값들을 관리하기 위한 변수
  // 저장을 안했을 때는 null 이 될 수 있기 떄문에 ? 붙여줌
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // @NOTE 01 키패드가 차지하는 높이

    return GestureDetector(
      onTap: () {
        // @NOTE 05 text field 밖으로 포커스가 이동될 때 키보드 숨김
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
          color: Colors.white, // @NOTE 05-1 지정 안했을때 focus out 동작 확인
          height: MediaQuery.of(context).size.height / 2 +
              bottomInset,  // @NOTE 01-1 키패드 만큼 사이즈를 늘여줌.
          child: Padding(
            padding: const EdgeInsets.all(spaceSize / 2)
                .copyWith(bottom: bottomInset), // @NOTE 01-2 하단 여백
            // 2 - 02. 입력값의 상위 컴포넌트에 Form 필드로 감싸준다
            // key 값을 지정해줌 form안에 있는 모든 텍스트 필드들이 어덯게
            // 동작하는지 컨트롤해주는 값
            child: Form(
              // 2 - 04. key에 formKey를 넣어준다
              key: formKey,
              // 3 - 02. 자동으로 검증한다
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 4 - 02. onStartSaved, onEndSaved 등 저장할 때 String 값을 받는다
                  _Time(
                    onStartSaved: (String? val) {
                      startTime = int.parse(val!);
                    },
                    onEndSaved: (String? val) {
                      endTime = int.parse(val!);
                    },
                  ),
                  const SizedBox(height: spaceSize),
                  _Content(onSaved: (String? val) {
                    content = val;
                  }),
                  const SizedBox(height: spaceSize),
                  FutureBuilder<List<CategoryColor>>(
                      future: GetIt.I<LocalDatabase>().getCategoryColors(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return _ColorPicker(
                          colors: snapshot.hasData
                              ? snapshot.data!.map((e) => Color(int.parse(
                                    'FF${e.hexCode}',
                                    radix: 16,
                                  ),
                            ),
                          ).toList()
                              : [],
                        );
                      }),
                  const SizedBox(height: spaceSize),
                  SizedBox(
                    width: double.infinity,
                    child: _SaveButton(
                      onPressed: onSavePressed,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 2 - 05. 저장 버튼을 눌렀을 떄 작동하는 코드
  void onSavePressed() {
    // formKey는 생성을 했는데
    // Form 위젯과 결합을 안했을때
    if (formKey.currentState == null) {
      return;
    }
    // validate가 null을 반환할 경우 에러가 없음
    if (formKey.currentState!.validate()) { // true 리턴했을 떄
      formKey.currentState!.save();

      print('-------------');
      print('startTime : $startTime');
      print('endTime : $endTime');
      print('content : $content');
    } else { // false
      print('에러가 있습니다');
    }
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('저장'),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Color> colors;

  const _ColorPicker({
    required this.colors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @NOTE 04 item들 사이에 간격을 주기 위해서 wrap widget 사용
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colors
          .map(
            (e) => _ColorPickerItem(
              colorCode: e.toString(),
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
    print('Color: $colorCode');
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
