import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'home_page2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage4(),
    );
  }
}

class HomePage4 extends StatefulWidget {
  @override
  _HomePage4State createState() => _HomePage4State();
}

class _HomePage4State extends State<HomePage4> {
  bool condition = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCheckingCondition();
  }

  void startCheckingCondition() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      bool perms = await FlutterContacts.requestPermission();

      setState(() async {
        condition = perms;
        if (condition) {
          timer.cancel;
          Navigator.of(context).popUntil((route) => route.isFirst);
          await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage2()));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icon_collage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {},
        ),
      ),
    );
  }
}
