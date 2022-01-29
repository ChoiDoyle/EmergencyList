import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  String customID;
  Register({Key? key, required this.customID}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState(customID);
}

class _RegisterState extends State<Register> {
  String customID;
  _RegisterState(this.customID);
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '가족/지인 등록하기',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.person_pin_circle_outlined,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
