import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:distraction_destruction/templates/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfilePic(
                    onTap: () async {
                      PickedFile? pic = await ImagePicker.platform.pickImage(
                          source: ImageSource.gallery);
                      if (pic != null) {
                        database.uploadProfilePic(pic);
                      }
                    }
                    ),
                const SizedBox(
                  width: 30,
                ),
                Text(database.name,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _auth.signOut();
                    },
                    icon: const Icon(Icons.logout),
                  alignment: Alignment.topRight,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
                "Sessions:",
              style: TextStyle(
                fontSize: 20.0,
              ),
            )
          ]
      ),
    );
  }
}
