import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbgiffarine/models/user_model.dart';
import 'package:kbgiffarine/state/info_edit.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UserModel userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readUser();
  }

  Future<Null> readUser() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid Login ==>> $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Text(userModel.name),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoEdit(),
            )),
        child: Text('Edit'),
      ),
    );
  }
}
