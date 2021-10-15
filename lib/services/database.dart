import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_time_patterns.dart';

class DatabaseService {
  String? uid;
  bool _lock = false;
  static final DatabaseService _databaseService = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService({String? uid}) {
    if (!_databaseService._lock) {
      _databaseService.uid = uid;
      _databaseService._lock = true;
    }
    return _databaseService;
  }

  int uidHash(String s1, String s2) =>
      (<String>[s1, s2]..sort()).join().hashCode;

  //Do not use this method, it should only ever be touched upon signout
  void unlockDatabase() {
    _lock = false;
  }

  //DatabaseService({this.uid});
  
  // Get reference to a collection in the database
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference timelineCollection = FirebaseFirestore.instance.collection('timeline');
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('sessions');

  Future createUser(String uid, String name) async {
    await userCollection.doc(uid).set({
      'name': name,
    });
  }

  //get userPreferences Stream
  Stream<DocumentSnapshot> get userDetailsStream {
    return userCollection.doc(uid).snapshots();

    //return userPreferencesCollection.doc(uid).snapshots().map((DocumentSnapshot documentSnapshot) => AppUser(name: documentSnapshot.data()['name']))
    //return userPreferencesCollection.snapshots().map((QuerySnapshot querySnapshot) => querySnapshot.docs.map((e) => ));
  }

  Stream<QuerySnapshot> get userCollectionStream {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get friendsCollectionStream {
    return userCollection.doc(uid).collection('friends').snapshots();
  }

  Future<DocumentSnapshot> getUserDocStream(String uid) {
    return userCollection.doc(uid).get();
  }

  Future<DocumentSnapshot<Object?>> get userDataFuture {
    return userCollection.doc(uid).get();
  }

  Future<DocumentSnapshot<Object?>> getSpecificUserDataFuture(String? uid) {
    return userCollection.doc(uid).get();
  }

  void addFriend(String uid) {
    userCollection.doc(this.uid).collection('friends').doc(uid).set({
      //'name': userCollection.doc(uid).snapshots().map((event) => event.data()),
      'score': 0,
      'last_session': 'none'
    });
  }

  void modifySessionHistory(String uid, Timestamp startTime, Timestamp endTime, int hours, int minutes, int breaks) {
    sessionCollection.doc(uidHash(this.uid!, uid).toString())
        .collection('history')
        .doc(startTime.toString())
        .set({

    });
  }

  void acceptSession(String uid) {
    sessionCollection.doc(uidHash(this.uid!, uid).toString()).set({
      //'name': userCollection.doc(uid).snapshots().map((event) => event.data()),
      this.uid: true,
    });
  }

  void startSession(String uid, Timestamp endTime, int hours, int minutes, int breaks) {
    Timestamp now = Timestamp.now();
    sessionCollection.doc(uidHash(this.uid!, uid).toString()).set({
      //'name': userCollection.doc(uid).snapshots().map((event) => event.data()),
      this.uid: true,
      uid: false,
      'start': now,
      'end' : endTime,
      'hours': hours,
      'minutes': minutes,
      'breaks': breaks,
    });
    modifySessionHistory(uid, now, endTime, hours, minutes, breaks);
    //TODO need to make sure the other user isn't already in a session
  }

  void setSessionState(String uid, bool state, String sessionId) {
    userCollection.doc(uid).set({
      'session_active': state,
      'session_id': sessionId,
    });
  }

}