import 'package:drift/drift.dart' show Value; // @NOTE 05-2 Column 충돌을 막기 위해 Value만 가져옴.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:calendar_scheduler_study/constants.dart';
import 'package:calendar_scheduler_study/database/drift_database.dart';
import 'package:calendar_scheduler_study/widgets/custom_text_field.dart';

/// 일정 입력 폼
class ScheduleForm extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId; // @NOTE 10-2 기존 폼에서 일정 정보를 가져오기 위한 id 값을 받도록 함.

  const ScheduleForm({
    Key? key,
    required this.selectedDate,
    this.scheduleId,
  }) : super(
          key: key,
        );

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  // 2 - 03. Form의 상태를 갖고있는 키(컨트롤러)
  final GlobalKey<FormState> formKey = GlobalKey();

  // 4 -03. 세 개의 값들을 관리하기 위한 변수
  // 저장을 안했을 때는 null 이 될 수 있기 떄문에 ? 붙여줌
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId; // @NOTE 03 선택된 색깔을 구분하기 위한 변수 추가

  // @NOTE 01 최초 autovalidateMode는 꺼둔 상태
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 키패드가 차지하는 높이

    return GestureDetector(
      onTap: () {
        // text field 밖으로 포커스가 이동될 때 키보드 숨김
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        color: Colors.white, // 지정 안했을때 focus out 동작 확인
        height: MediaQuery.of(context).size.height / 2 + bottomInset, // 키패드 만큼 사이즈를 늘여줌.
        child: Padding(
          padding: const EdgeInsets.all(spaceSize / 2)
              .copyWith(bottom: bottomInset + spaceSize / 2), // 하단 여백
          // 2 - 02. 입력값의 상위 컴포넌트에 Form 필드로 감싸준다
          // key 값을 지정해줌 form안에 있는 모든 텍스트 필드들이 어덯게
          // 동작하는지 컨트롤해주는 값
          child: Form(
            // 2 - 04. key에 formKey를 넣어준다
            key: formKey,
            // 3 - 02. 자동으로 검증한다
            autovalidateMode: autovalidateMode,
            child: FutureBuilder<Schedule>(
                // @NOTE 10-5 scheduleId로 조회
                future: widget.scheduleId == null
                    ? null
                    : GetIt.I<LocalDatabase>().getSchedule(widget.scheduleId!),
                builder: (context, scheduleSnapshot) {
                  // @NOTE 10-5 예외 처리
                  if (scheduleSnapshot.hasError) {
                    return const Center(
                      child: Text('일정을 불러올 수 없습니다.'),
                    );
                  }

                  if (scheduleSnapshot.connectionState != ConnectionState.none &&
                      !scheduleSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (scheduleSnapshot.hasData && startTime == null) {
                    startTime = scheduleSnapshot.data!.startTime;
                    endTime = scheduleSnapshot.data!.endTime;
                    content = scheduleSnapshot.data!.content;
                    selectedColorId = scheduleSnapshot.data!.colorId;
                  }

                  return Column(
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
                        // @NOTE 10-4 초기값 전달
                        initialStartTime: startTime?.toString() ?? '',
                        initialEndTime: endTime?.toString() ?? '',
                      ),
                      const SizedBox(height: spaceSize),
                      _Content(
                        onSaved: (String? val) {
                          content = val;
                        },
                        initialValue: content ?? '',
                      ),
                      const SizedBox(height: spaceSize),
                      FutureBuilder<List<CategoryColor>>(
                          future: GetIt.I<LocalDatabase>().getCategoryColors(),
                          builder: (context, colorSnapshot) {
                            // @NOTE 03-1 selectedColorId가 지정되지 않았으면 첫번째 색상으로 지정
                            if (colorSnapshot.hasData &&
                                selectedColorId == null &&
                                colorSnapshot.data!.isNotEmpty) {
                              selectedColorId = colorSnapshot.data![0].id;
                            }

                            return _ColorPicker(
                              colors: colorSnapshot.hasData ? colorSnapshot.data! : [],
                              selectedColorId: selectedColorId,
                              // @NOTE 04-2 callback 함수, setState를 하기 위해 인자로 함수를 전달
                              colorSetter: (id) {
                                setState(() {
                                  selectedColorId = id;
                                });
                              },
                            );
                          }),
                      const SizedBox(height: spaceSize),
                      SizedBox(
                        width: double.infinity,
                        child: _SaveButton(
                          onPressed: onSavePressed,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  // 2 - 05. 저장 버튼을 눌렀을 떄 작동하는 코드
  void onSavePressed() async {
    // formKey는 생성을 했는데
    // Form 위젯과 결합을 안했을때
    if (formKey.currentState == null) {
      return;
    }

    // @NOTE 01-1 저장 버튼을 누른 후 autovalidateMode를 활성화
    autovalidateMode = AutovalidateMode.always;

    // validate가 null을 반환할 경우 에러가 없음
    if (formKey.currentState!.validate()) {
      // true 리턴했을 떄
      formKey.currentState!.save();

      // @NOTE 05 form 정보 저장
      final form = SchedulesCompanion(
        date: Value(widget.selectedDate),
        startTime: Value(startTime!),
        endTime: Value(endTime!),
        content: Value(content!),
        colorId: Value(selectedColorId!),
      );

      // @NOTE 10-6 update와 create 구분
      if (widget.scheduleId == null) {
        // @NOTE 05 schedule 생성
        await GetIt.I<LocalDatabase>().createSchedule(form);
      } else {
        // @NOTE 10-6 update
        await GetIt.I<LocalDatabase>().updateSchedule(widget.scheduleId!, form);
      }

      Navigator.of(context).pop(); // @NOTE 05-1 저장 후 bottomSheet 닫기
    } else {
      // false
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String initialStartTime;
  final String initialEndTime;

  const _Time({
    Key? key,
    required this.onStartSaved,
    required this.onEndSaved,
    required this.initialStartTime,
    required this.initialEndTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // @NOTE 02 validation error 가 표시될때 정렬을 위해서 start align
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
            initialValue: initialStartTime,
          ),
        ),
        const SizedBox(width: spaceSize),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
            initialValue: initialEndTime,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({
    Key? key,
    required this.onSaved,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('저장'),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ValueChanged<int> colorSetter;

  const _ColorPicker({
    Key? key,
    required this.colors,
    required this.selectedColorId,
    required this.colorSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // item들 사이에 간격을 주기 위해서 wrap widget 사용
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colors
          .map(
            // @NOTE 04 GestureDetector로 색깔선택 이벤트 연결
            (e) => GestureDetector(
              onTap: () {
                colorSetter(e.id); // @NOTE 04-1 인자로 추가한 callback 호출
              },
              child: _ColorPickerItem(
                categoryColor: e,
                isSelected: selectedColorId == e.id, // @NOTE 03-2 selectedColorId와 같은 id 인지 비교
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ColorPickerItem extends StatelessWidget {
  final CategoryColor categoryColor;
  final bool isSelected;

  const _ColorPickerItem({
    Key? key,
    required this.categoryColor,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.parse(
        'FF${categoryColor.hexCode}',
        radix: 16,
      ),
    );
    final counterColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        // @NOTE 03-3 isSelected 일때만 border 표시
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4,
              )
            : null,
      ),
      width: 32,
      height: 32,
      // @NOTE 03-4 isSelected 일때만 icon 표시
      child: isSelected
          ? Icon(
              Icons.check,
              color: counterColor,
            )
          : null,
    );
  }
}
