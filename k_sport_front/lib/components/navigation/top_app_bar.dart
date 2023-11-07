import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/views/auth/login_page.dart';
import 'package:k_sport_front/views/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const CustomImage(
          imagePath: 'https://via.placeholder.com/100x30',
          fit: BoxFit.cover,
          height: 30), // placeholder logo
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          CustomNavigation.push(context, const ProfilePage());
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            CustomNavigation.pushReplacement(context, const LoginPage());
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // default height of AppBar
}
