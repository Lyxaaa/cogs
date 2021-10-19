import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final VoidCallback onTap;

  const ProfilePic({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: DatabaseService().currentProfilePicUrl == null
            ? const CircleAvatar(
          radius: 50.0,
          child: Icon(Icons.photo_camera),
        )
        : CircleAvatar(
      radius: 50.0,
      backgroundImage: NetworkImage(DatabaseService().currentProfilePicUrl!),
    )
    );
  }
}
