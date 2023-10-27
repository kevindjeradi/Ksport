import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:provider/provider.dart';

class ScheduleComponent extends StatefulWidget {
  final Function(int) onDayTapped;
  final Function(int, Training?) onTrainingAssigned;

  const ScheduleComponent(
      {Key? key, required this.onDayTapped, required this.onTrainingAssigned})
      : super(key: key);

  @override
  ScheduleComponentState createState() => ScheduleComponentState();
}

class ScheduleComponentState extends State<ScheduleComponent> {
  List<Status> weekStatuses = List.filled(7, Status.comming);

  @override
  void initState() {
    super.initState();
    int today = DateTime.now().weekday;
    weekStatuses = List.generate(7, (index) {
      if (index < today - 1) {
        return Status.checked;
      } else if (index == today - 1) {
        return Status.current;
      } else {
        return Status.comming;
      }
    });

    final trainingProvider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    trainingProvider.fetchTrainings();
    trainingProvider.fetchAllTrainingsForTheWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleTrainingProvider>(
        builder: (context, trainingProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Planning',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('cette semaine',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 10),
            trainingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekStatuses
                        .asMap()
                        .entries
                        .map((entry) =>
                            _buildDay(entry.key, entry.value, trainingProvider))
                        .toList(),
                  ),
            if (trainingProvider.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(trainingProvider.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14)),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildDay(
      int index, Status status, ScheduleTrainingProvider trainingProvider) {
    String dayName = ScheduleTrainingProvider.dayNames[index];
    Training? currentTraining = trainingProvider.weekTrainings[index];
    bool isEmpty = currentTraining?.name.isEmpty ?? true;
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
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.blueGrey[50],
              title: Row(
                children: [
                  const Icon(
                    Icons.assignment,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dayName,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: trainingProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : trainingProvider.errorMessage.isNotEmpty
                      ? Text(trainingProvider.errorMessage)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isEmpty
                                ? const Text(
                                    'Aucun entrainement selectionné',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text: 'Aujourd\'hui, c\'est '),
                                        TextSpan(
                                          text: currentTraining?.name
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<Training>(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                labelText: 'Modifier l\'entrainement du jour',
                                border: OutlineInputBorder(),
                              ),
                              items: trainingProvider.trainings
                                  .map((Training training) {
                                return DropdownMenuItem<Training>(
                                  value: training,
                                  child: Text(training.name),
                                );
                              }).toList(),
                              onChanged: (Training? newValue) {
                                setState(() {
                                  trainingProvider.weekTrainings[index] =
                                      newValue;
                                });
                                widget.onTrainingAssigned(index + 1, newValue);
                              },
                            )
                          ],
                        ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                ),
              ],
              contentPadding: const EdgeInsets.all(20),
              insetPadding: const EdgeInsets.all(20),
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
            Text(dayName.substring(0, 3), style: TextStyle(color: textColor)),
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
