import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            print(
                'name =>> ${userModel.name}, email ==>> ${userModel.email}, lat ==>> ${userModel.lat},lng ==>> ${userModel.lng}');
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
          : Container(
              margin: EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          child: Image.asset('${userModel.urlAvatar}'),
                        ),
                        buildTextName(),
                        buildTextEmail(),
                        buildMap(context)
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[
      Marker(
          markerId: MarkerId('idUser'),
          position: LatLng(double.parse('${userModel.lat}'),
              double.parse('${userModel.lng}')),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่',
              snippet: 'lat = ${userModel.lat},lng = ${userModel.lng}')),
    ].toSet();
  }

  Expanded buildMap(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        width: MediaQuery.of(context).size.width,
        child: userModel.lat == null
            ? buildProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse('${userModel.lat}'),
                    double.parse('${userModel.lng}'),
                  ),
                  zoom: 16,
                ),
                mapType: MapType.normal,
                onMapCreated: (controller) {},
                markers: mySet(),
              ),
      ),
    );
  }

  Center buildProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Text buildTextName() => Text(
        'Name : ${userModel.name}',
        style: TextStyle(
          color: Colors.cyan,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      );

  Text buildTextEmail() => Text(
        'Email : ${userModel.email}',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      );

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoEdit(),
          )),
      child: Text('Edit'),
    );
  }
}
