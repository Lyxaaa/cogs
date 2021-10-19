import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';

class DatabaseService {
  final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://distraction-destruction.appspot.com');

  String? _uid;
  String? _name;
  String? _profilePicUrl;

  bool _lock = false;
  bool _lockName = false;

  static final DatabaseService _databaseService = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService({String? uid}) {
    if (!_databaseService._lock) {
      _databaseService._uid = uid;
      _databaseService._lock = true;
    }

    return _databaseService;
  }

  String get uid => _uid!;
  String get name => _name!;
  String? get profilePicUrl => _profilePicUrl;

  int uidHash(String s1, String s2) =>
      (<String>[s1, s2]..sort()).join().hashCode;

  //Do not use this method, it should only ever be touched upon signout
  void unlockDatabase() {
    _lock = false;
    _lockName = false;
  }

  void setName(String name) {
    if (!_databaseService._lockName) {
      _databaseService._name = name;
      _databaseService._lockName = true;
    }
  }

  void setPic(String url) {
      _databaseService._profilePicUrl = url;
  }

  String? get currentProfilePicUrl {
    return _profilePicUrl;
  }

  Future<void> updateProfilePicUrl() async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var downloadTask = storageReference.getDownloadURL();
    _profilePicUrl = await downloadTask;
  }

  Future<String> findProfilePicUrl(String uid) async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var downloadTask = storageReference.getDownloadURL();
    return await downloadTask;
  }

  Future<void> uploadProfilePic(PickedFile file) async {
    var storageReference = storage.ref().child('user/pics/${uid}');
    var uploadTask = storageReference.putData(await file.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
    uploadTask.whenComplete(() async {
      _profilePicUrl = await storageReference.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
  }
  //DatabaseService({this.uid});
  
  // Get reference to a collection in the database
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('session');

  Future createUser(String uid, String name) async {
    await userCollection.doc(uid).set({
      'name': name,
      'session_active': false,
      'session_uid': ''
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

  Future<DocumentSnapshot> getUserDocFuture(String uid) {
    return userCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> getUserDocStream(String uid) {
    return userCollection.doc(uid).snapshots();
  }


  Future<DocumentSnapshot<Object?>> get userDataFuture {
    return userCollection.doc(uid).get();
  }

  Future<DocumentSnapshot<Object?>> getSpecificUserDataFuture(String? uid) {
    return userCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> getSessionStream(String uid) {
    return sessionCollection.doc(uidHash(this.uid, uid).toString()).snapshots();
  }

  void addFriend(String uid) {
    userCollection.doc(this.uid).collection('friends').doc(uid).set({
      //'name': userCollection.doc(uid).snapshots().map((event) => event.data()),
      'score': 0,
      'last_session': Timestamp.now(),
    });
    userCollection.doc(uid).collection('friends').doc(this.uid).set({
      'score': 0,
      'last_session': Timestamp.now(),
    });
  }

  void modifySessionHistory(String uid, Timestamp startTime, Timestamp endTime, int hours, int minutes, int breaks) {
    sessionCollection.doc(uidHash(this.uid, uid).toString())
        .collection('history')
        .doc(startTime.toString())
        .update({

    });
  }


  void startSession(String uid, String name, Timestamp endTime, int hours, int minutes, int breaks) {
    //var otherUser = (await userCollection.doc(uid).snapshots().first).data() as Map<String?, dynamic>;
    //bool? active = otherUser['session_active'];
    //print("Active: " + active.toString() + ' : ' + uid);
    //if (active != null && !active) {
    Timestamp now = Timestamp.now();
    setSessionState(this.uid, true, uid);
    setSessionState(uid, true, this.uid);
    startSessionGlobal(uid, name, endTime, hours, minutes, breaks);
    //}
    //return false;
    //TODO need to make sure the other user isn't already in a session
    //If user's session_active is false, display reg page
    //If user's session_active is true:
    //    if sessions other uid is true: display time remaining & stop button
    //    if sessions other uid is false: display "waiting for friend to accept session"
  }

  void endSession(String uid) {
    setSessionState(this.uid, false, uid);
    setSessionState(uid, false, this.uid);
    endSessionGlobal(uid, true);
  }

  void acceptSession(String uid) {
    sessionCollection.doc(uidHash(this.uid, uid).toString()).update({
      this.uid: true,
      'start': Timestamp.now(),
    });
  }

  void startSessionGlobal(String uid, String name, Timestamp endTime, int hours, int minutes, int breaks) async {
    await sessionCollection.doc(uidHash(this.uid, uid).toString()).set({
      //'name': userCollection.doc(uid).snapshots().map((event) => event.data()),
      this.uid.toString(): true,
      uid.toString(): false,
      'start': Timestamp.now(),
      'end' : endTime,
      'hours': hours,
      'minutes': minutes,
      'breaks': breaks,
      'name': name,
    });
  }

  void endSessionGlobal(String uid, bool endEarly) {
    sessionCollection.doc(uidHash(this.uid, uid).toString()).update({
      'end': Timestamp.now()
    });
  }

  Future setSessionState(String modifyUid, bool state, String otherUid) async {
    await userCollection.doc(modifyUid).update({
      'session_active': state,
      'session_uid': otherUid,
    });
  }

}