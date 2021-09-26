import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final String uid;
  final User user;
  DatabaseService({required this.user, required this.uid});
  
  // Get reference to a collection in the database
  final CollectionReference userPreferences = FirebaseFirestore.instance.collection('user');
  final CollectionReference timelineCollection = FirebaseFirestore.instance.collection('timeline');

  Future updateUserPreferences(String? name) async {
    return await userPreferences.doc(uid).set({
      'name': name,
    });
}

}