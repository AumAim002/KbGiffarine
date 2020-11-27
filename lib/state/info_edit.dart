import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
        title: Text('Info Edit Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImage(context),
            buildPostName(context),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: statusProcess ? SizedBox() :CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'กรุณาเลือกรูปภาพ ?');
        } else if (nameInfo == null || nameInfo.isEmpty) {
          print('nameInfo ==>> $nameInfo');
          //normalDialog(context, 'มีค่าว่าง โปรดระบุ ?');
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
        onChanged: (value) => nameInfo = nameInfo.trim(),
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
                ? Image.asset('images/avartar.png')
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

  Future<Null> uploadAndEditData() async {}
}
