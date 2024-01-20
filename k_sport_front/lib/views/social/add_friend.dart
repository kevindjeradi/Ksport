import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/services/user_service.dart';

class AddFriend extends StatefulWidget {
  final String scannedUserId;
  final String username;
  final String profileImage;

  const AddFriend({
    Key? key,
    required this.scannedUserId,
    required this.username,
    required this.profileImage,
  }) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
              child: Text(
            'Code Ami: ${widget.scannedUserId}',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          )),
          Column(
            children: [
              if (widget.profileImage.isNotEmpty)
                CustomImage(
                    imagePath: baseUrl + widget.profileImage,
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15),
              const SizedBox(height: 10),
              Text(widget.username, style: theme.textTheme.headlineSmall),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              bool isFriendAdded =
                  await userService.addFriend(widget.scannedUserId);
              if (isFriendAdded) {
                if (mounted) {
                  showCustomSnackBar(
                      context,
                      "${widget.username} a bien été ajoutée à votre liste d'ami !",
                      SnackBarType.success);
                  Navigator.of(context).pop();
                }
              } else {
                if (mounted) {
                  showCustomSnackBar(
                      context,
                      "${widget.username} n'a pas pu être ajouté à votre liste d'ami. Réessayez plus tard.",
                      SnackBarType.success);
                }
              }
            },
            child: const Text("Ajouter à ma liste d'ami"),
          ),
        ],
      ),
    );
  }
}
