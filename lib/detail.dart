import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  String customID;
  Detail({Key? key, required this.customID}) : super(key: key);

  @override
  _DetailState createState() => _DetailState(customID);
}

class _DetailState extends State<Detail> {
  String customID;
  _DetailState(this.customID);

  //Firebase & Firestore
  final fsdb = FirebaseFirestore.instance;
  final rtdb = FirebaseDatabase.instance.reference();

  //My Credential:-
  String myPhone = '';
  String myName = '';
  String myBirth = '';

  @override
  void initState() {
    super.initState();
    myPhone = customID.split('_')[0];
    myName = customID.split('_')[1];
    myBirth = customID.split('_')[2];
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomUI().simpleAppBar('$myName님의 정보'),
        body: Container(),
      ),
    );
  }
}
