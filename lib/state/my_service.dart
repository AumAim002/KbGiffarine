import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kbgiffarine/state/authen.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: buildDrawer(),
    );
  }

  Drawer buildDrawer() => Drawer(
        child: Column(
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
        ),
      );
}
