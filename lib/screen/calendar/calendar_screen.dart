import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        header(),
        TableCalendar(
          locale: 'ko_KR',
          focusedDay: _focusedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 100)),
          headerVisible: false,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          selectedDayPredicate: (selectedDay) {
            return _selectedDay == selectedDay;
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
      ],
    );
  }

  Widget header() {
    return Container(
      height: 30,
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_focusedDay.month}월',
            style: const TextStyle(fontSize: 18),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 100,
                  color: Colors.amber,
                  child: Center(child: Text('운동시작!')),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 100,
                  color: Colors.blue,
                  child: Center(child: Text('식단 등록')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
