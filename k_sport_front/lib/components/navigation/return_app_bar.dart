import 'package:flutter/material.dart';

class ReturnAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MaterialColor bgColor;
  final String barTitle;
  final Color color;
  final double elevation;

  const ReturnAppBar({
    Key? key,
    required this.bgColor,
    required this.barTitle,
    required this.color,
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: bgColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: color,
        ),
      ),
      title: Text(
        barTitle,
        style:
            TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // default height of AppBar
}
