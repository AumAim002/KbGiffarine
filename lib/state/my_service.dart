import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbgiffarine/models/user_model.dart';
import 'package:kbgiffarine/state/authen.dart';
import 'package:kbgiffarine/state/information.dart';
import 'package:kbgiffarine/state/show_list_post.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  UserModel userModel;
  Widget currentWidget = ShowListPost();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
            print('name ==> ${userModel.name}, email ==> ${userModel.email}');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: buildDrawer(),
      body: currentWidget,
     
    );
  }

  Drawer buildDrawer() => Drawer(
          child: Stack(
        children: [
          buildSignOut(),
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildListTileListPost(),
              Divider(
                thickness: 1,
              ),
              buildListTileInformation(),
              Divider(
                thickness: 1,
                color: Colors.blue.shade900,
              ),
            ],
          ),
        ],
      ));

  ListTile buildListTileListPost() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36,
        color: Colors.orange,
      ),
      title: Text('Show List Post'),
      subtitle: Text('แสดง Post ทั้งหมดที่มีในฐานข้อมูล'),
      onTap: () {
        setState(() {
          currentWidget = ShowListPost();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileInformation() {
    return ListTile(
      leading: Icon(
        Icons.face,
        size: 36,
        color: Colors.green.shade700,
      ),
      title: Text('Information'),
      subtitle: Text('แสดง Information of User Logined'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(
        userModel == null ? 'Name' : userModel.name,
        style: TextStyle(
          color: Colors.purple.shade700,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        userModel == null ? 'Email' : userModel.email,
        style: TextStyle(color: Colors.redAccent.shade700),
      ),
    );
  }

  Widget buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            onTap: () async {
              await Firebase.initializeApp().then((value) async {
                await FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authen(),
                          ),
                          (route) => false),
                    );
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 36,
            ),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'คือการออกจาก Account เพื่อ Login ใหม่',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
