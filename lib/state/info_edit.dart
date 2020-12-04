import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kbgiffarine/models/user_model.dart';
import 'package:kbgiffarine/utility/normal_dialog.dart';

class InfoEdit extends StatefulWidget {
  @override
  _InfoEditState createState() => _InfoEditState();
}

class _InfoEditState extends State<InfoEdit> {
  File file;
  String urlImage, nameInfo, uid;
  bool statusProcess = true; //true คือ ไม่แสดง Process

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      appBar: AppBar(
        title: Text('Edit Information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImage(context),
            buildPostName(context),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: statusProcess ? SizedBox() : CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print('nameInfo ==>> $nameInfo');
        if (file == null) {
          normalDialog(context, 'กรุณาเลือกรูปภาพ ?');
        } else if (nameInfo == null || nameInfo.isEmpty) {
          normalDialog(context, 'มีค่าว่าง โปรดระบุ ?');
        } else {
          setState(() {
            statusProcess = false;
            uploadAndEditData();
          });
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Container buildPostName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width - 100, //ความกว้างของ Text
      child: TextField(
        onChanged: (value) => nameInfo = value.trim(),
        decoration: InputDecoration(
          labelText: 'Display Name',
          border: OutlineInputBorder(),
        ), //ใส่ Text เอาไว้กรอกข้อมูล
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    //สำหรับเลือก แหล่งกำเนิดภาพ มาจาก Camela / Gallery
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Padding buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 48,
                color: Colors.amber.shade800,
              ),
              onPressed: () {
                chooseImage(ImageSource.camera); //ภาพจาก Camela
              }),
          Container(
            width: MediaQuery.of(context).size.width - 200,
            height: MediaQuery.of(context).size.width - 200,
            child: file == null
                ? Image.asset('images/childkid.png')
                : Image.file(file),
          ),
          IconButton(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: Colors.brown.shade800,
              ),
              onPressed: () {
                chooseImage(ImageSource.gallery); //ภาพจาก Gallery
              }),
        ],
      ),
    );
  }

  Future<Null> uploadAndEditData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.userChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) async {
          UserModel userModel = UserModel.fromMap(event.data());
          String email = userModel.email;
          String lat = userModel.lat;
          String lng = userModel.lng;
          String password = userModel.password;

          int i = Random().nextInt(1000000);
          String nameFile = '$uid$i.jpg';
          print('nameFile ==>> $nameFile');

          FirebaseStorage storage = FirebaseStorage.instance;
          var refer = storage.ref().child('post/$nameFile');
          UploadTask task = refer.putFile(file);
          await task.whenComplete(() async {
            String urlImage = await refer.getDownloadURL();
            print('Upload Success urlImage ==>> $urlImage <<==');

            UserModel user = UserModel(
                name: nameInfo,
                urlAvatar: urlImage,
                email: email,
                lat: lat,
                lng: lng,
                password: password);

            Map<String, dynamic> data = user.toMap();
            await FirebaseFirestore.instance
                .collection('user')
                .doc(uid)
                .set(data)
                .then((value) => Navigator.pop(context));
          });
        });
      });
    });
  }
}
