import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';

class UserPic extends StatelessWidget {
  final String? url;
  const UserPic({required this.url});

  @override
  Widget build(BuildContext context) {
    return url == 'null'
        ? const CircleAvatar(
      radius: 20.0,
      child: Icon(
        Icons.person,
        size: 40.0,
        color: Colors.white,
      ),
      backgroundColor: Colors.transparent,
    )
        : CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(url!)
    );
  }
}
