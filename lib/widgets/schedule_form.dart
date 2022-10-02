import 'package:flutter/material.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
    );
  }
}
