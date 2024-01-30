import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/training_service.dart';

class FriendCard extends StatefulWidget {
  final Map<String, dynamic> friendData;

  const FriendCard({Key? key, required this.friendData}) : super(key: key);
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: widget.friendData['profileImage'] != null
                  ? CustomImage(
                      imagePath: FriendCard.baseUrl +
                          widget.friendData['profileImage'])
                  : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(widget.friendData['username'] ?? 'Unknown'),
              subtitle: Text(
                  'Compte crée le: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.friendData['dateJoined']))}'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      "Il s'est entraîné ${widget.friendData['numberOfTrainings'] ?? '0'} fois",
                      style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: _getTrainingDetails(widget.friendData['trainings']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Liste de ses entraînements",
                                style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 130,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                var training = snapshot.data?[index];
                                return Card(
                                  color: theme.colorScheme.background,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(training!.name,
                                                  style: theme
                                                      .textTheme.headlineSmall),
                                              const SizedBox(height: 10),
                                              Text(
                                                training.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () => _addTrainingToUser(
                                              context, training),
                                          child: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Training>> _getTrainingDetails(dynamic trainings) async {
    List<Training> trainingDetails = [];
    for (var trainingId in trainings) {
      var training = await TrainingService.fetchTraining(trainingId);
      if (training != null) {
        trainingDetails.add(Training(
            id: training.id,
            name: training.name,
            description: training.description,
            exercises: training.exercises,
            goal: training.goal));
      }
    }
    return trainingDetails;
  }

  Future<void> _addTrainingToUser(
      BuildContext context, Training training) async {
    final TrainingService trainingService = TrainingService();
    final theme = Theme.of(context);

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Copier l'entraînement"),
          content:
              Text("Voulez vous ajouter ${training.name} à vos entraînements"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('non', style: theme.textTheme.bodyLarge),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('oui', style: theme.textTheme.bodyLarge),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        Map<String, dynamic> data = {
          'name': training.name,
          'description': training.description,
          'goal': training.goal,
          'exercises': training.exercises,
        };

        final response = await trainingService.saveTraining(data, null);
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            showCustomSnackBar(
                context, "copié avec succès", SnackBarType.success);
            Navigator.pop(context);
          }
        } else {
          Log.logger.e(
              'Error saving the training in training_form: ${response.body}');
        }
      } catch (e) {
        Log.logger.e('Error saving the training in training_form -> error: $e');
      }
    }
  }
}
