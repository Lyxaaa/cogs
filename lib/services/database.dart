import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final String? uid;
  final User? user;
  DatabaseService({this.user, this.uid});
  
  // Get reference to a collection in the database
  final CollectionReference userPreferencesCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference timelineCollection = FirebaseFirestore.instance.collection('timeline');

  Future updateUserPreferences(String? name) async {
    return await userPreferencesCollection.doc(uid).set({
      'name': name,
    });
  }

  //get userPreferences Stream
  Stream<QuerySnapshot> get userPreferences {
    return userPreferencesCollection.snapshots();
  }

  DocumentReference get userInfo {
    return userPreferencesCollection.doc(uid);
  }

}