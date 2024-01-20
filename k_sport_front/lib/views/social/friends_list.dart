import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/components/social/friend_card.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:provider/provider.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  @override
  void initState() {
    super.initState();
    refreshUserData();
  }

  void refreshUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await Api.populateUserProvider(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final friends = userProvider.friends;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Mes amis'),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return FriendCard(friendData: friends[index]);
        },
      ),
    );
  }
}
