import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/api.dart';

class ScheduleComponent extends StatefulWidget {
  final Function(int) onDayTapped; // Callback for when a day is tapped
  final Function(int, Training?) onTrainingAssigned;

  const ScheduleComponent(
      {Key? key, required this.onDayTapped, required this.onTrainingAssigned})
      : super(key: key);

  @override
  ScheduleComponentState createState() => ScheduleComponentState();
}

class ScheduleComponentState extends State<ScheduleComponent> {
  List<Status> weekStatuses = [];
  List<Training> trainings = [];
  List<Training?> weekTrainings = List.filled(7, null);

  _fetchTrainings() async {
    final response = await Api.get('http://10.0.2.2:3000/trainings');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        trainings = data.map((item) => Training.fromJson(item)).toList();
      });
    } else {
      print('Error fetching trainings');
    }
  }

  _fetchTrainingForDay(int day) async {
    try {
      final trainingData = await Api.fetchTrainingForDay(day.toString());
      setState(() {
        weekTrainings[day - 1] = Training.fromJson(trainingData);
      });
    } catch (e) {
      print("Error fetching training for day $day: $e");
    }
  }

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
    _fetchTrainings();
    int today = DateTime.now().weekday;
    weekStatuses = List.generate(7, (index) {
      _fetchTrainingForDay(index + 1);
      if (index < today - 1) {
        return Status.checked;
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
    Training? currentTraining = weekTrainings[index];
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

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Set rounded corners
              ),
              backgroundColor:
                  Colors.blueGrey[50], // Set a custom background color
              title: Row(
                children: [
                  const Icon(Icons.assignment),
                  const SizedBox(width: 10),
                  Text(
                    dayName,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: DropdownButtonFormField<Training>(
                decoration: const InputDecoration(
                  labelText: 'Choisir un entraînement',
                  border: OutlineInputBorder(),
                ),
                value: currentTraining,
                items: trainings.map((Training training) {
                  return DropdownMenuItem<Training>(
                    value: training,
                    child: Text(training.name),
                  );
                }).toList(),
                onChanged: (Training? newValue) {
                  setState(() {
                    weekTrainings[index] = newValue;
                  });
                  widget.onTrainingAssigned(index + 1, newValue);
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
        widget.onDayTapped(index + 1);
      },
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

enum Status { checked, current, comming }
