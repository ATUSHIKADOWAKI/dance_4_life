import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../event_detail/event_detail_page.dart';
import 'calender_model.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalenderModel>(
      create: (_) => CalenderModel()..fetchEventsCalender(),
      child: Consumer<CalenderModel>(builder: (context, model, child) {
        final _events = LinkedHashMap<DateTime, List>(
          equals: isSameDay,
          hashCode: model.getHashCode,
        )..addAll(model.eventsList);

        List _getEventForDay(DateTime day) {
          return _events[day] ?? [];
        }

        model.selectedDay = model.focusedDay;
        return Scaffold(
          appBar: AppBar(
            title: Text('イベントカレンダー'),
          ),
          body: Column(
            children: [
              TableCalendar(
                locale: 'ja_JP',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: model.focusedDay,
                eventLoader: _getEventForDay,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(model.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(model.selectedDay, selectedDay)) {
                    model.setDayCalender(selectedDay, focusedDay);
                    _getEventForDay(selectedDay);
                    print(selectedDay);
                  }
                },
                onPageChanged: (focusedDay) {
                  model.focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return _buildEventsMarker(date, events);
                    }
                  },
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: _getEventForDay(model.selectedDay)
                    .map((event) => ListTile(
                          title: Text(event.toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetail(0),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Positioned(
      right: 5,
      bottom: 5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
