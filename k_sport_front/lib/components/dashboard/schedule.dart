import 'package:flutter/material.dart';

class ScheduleComponent extends StatefulWidget {
  final Function(int) onDayTapped; // Callback for when a day is tapped

  const ScheduleComponent({Key? key, required this.onDayTapped})
      : super(key: key);

  @override
  ScheduleComponentState createState() => ScheduleComponentState();
}

class ScheduleComponentState extends State<ScheduleComponent> {
  List<Status> weekStatuses = [];

  // Constant list of day names
  static const List<String> dayNames = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];

  @override
  void initState() {
    super.initState();
    int today = DateTime.now().weekday;
    weekStatuses = List.generate(7, (index) {
      if (index < today - 1) {
        return Status.checked; // or Status.crossed for past days
      } else if (index == today - 1) {
        return Status.current;
      } else {
        return Status.comming;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Planning',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('cette semaine',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekStatuses
                .asMap()
                .entries
                .map((entry) => _buildDay(entry.key, entry.value))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDay(int index, Status status) {
    String dayName = dayNames[index];

    Color bgColor;
    IconData icon = Icons.circle;
    Color textColor = Colors.white;
    BoxBorder containerBorder =
        Border.all(width: 1.0, color: const Color(0xFFFFFFFF));

    switch (status) {
      case Status.checked:
        bgColor = Colors.red;
        icon = Icons.check_circle;
        break;
      case Status.crossed:
        bgColor = Colors.blue;
        icon = Icons.cancel;
        break;
      case Status.current:
        bgColor = Colors.white;
        textColor = Colors.blue;
        containerBorder = Border.all(width: 2.0, color: Colors.blue);
        break;
      case Status.comming:
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[300]!;
        containerBorder = Border.all(width: 2.0, color: Colors.grey[200]!);
        icon = Icons.circle;
        break;
    }

    return GestureDetector(
      onTap: () => widget.onDayTapped(index),
      child: Container(
        width: 45,
        height: 55,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
            border: containerBorder),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(dayName, style: TextStyle(color: textColor)),
            const SizedBox(width: 5),
            icon != Icons.circle
                ? Icon(icon, size: 18, color: textColor)
                : Icon(icon, size: 10, color: textColor)
          ],
        ),
      ),
    );
  }
}

enum Status { checked, crossed, current, comming }
