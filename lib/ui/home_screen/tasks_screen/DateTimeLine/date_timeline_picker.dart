import 'package:date_picker_timetable/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:flutter_timeline_calendar/timeline/model/calendar_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/day_options.dart';
import 'package:flutter_timeline_calendar/timeline/model/headers_options.dart';
import 'package:flutter_timeline_calendar/timeline/utils/calendar_types.dart';
import 'package:flutter_timeline_calendar/timeline/widget/timeline_calendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do/controllers/TasksProvider.dart';
import 'package:to_do/controllers/Utils.dart';
import 'package:to_do/ui/theming/m_them.dart';

class DateTimeLineScreen extends StatefulWidget {
  @override
  State<DateTimeLineScreen> createState() => _DateTimeLineScreenState();
}

class _DateTimeLineScreenState extends State<DateTimeLineScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: MyTheme.btrolColor,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
      ),
      child: TableCalendar(
        locale: provider.local == Locale("en") ? "en" : "ar",
        weekendDays: const [],
        headerStyle: const HeaderStyle(
            rightChevronIcon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            leftChevronIcon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
        daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.white),
            weekdayStyle: TextStyle(color: Colors.white)),
        calendarStyle: const CalendarStyle(
          outsideTextStyle: TextStyle(color: Colors.white),
          defaultTextStyle: TextStyle(color: Colors.white),
          disabledTextStyle: TextStyle(color: Colors.white),
        ),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime(DateTime.now().year+5),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            var d = Utils.dateIgnoreMilliseconds(selectedDay);
            provider.getTasksTime(d);
            setState(() {
              Utils.selectedDate = selectedDay;
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  TextStyle getStyle() {
    return const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
  }
}
