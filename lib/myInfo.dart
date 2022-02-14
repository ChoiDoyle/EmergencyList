import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatefulWidget {
  String customID;
  MyInfo({Key? key, required this.customID}) : super(key: key);

  @override
  _MyInfoState createState() => _MyInfoState(customID);
}

class _MyInfoState extends State<MyInfo> {
  String customID;

  _MyInfoState(this.customID);

  late Future<MyData> myDataForUpdate;

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
        appBar: CustomUI().simpleAppBar('$myName님의 재난명부'),
        body: myInfoBuilder(),
      ),
    );
  }

  Widget myInfoBuilder() {
    setState(() {
      myDataForUpdate = fetchMyData();
    });
    return FutureBuilder<MyData>(
      future: myDataForUpdate,
      builder: (context, mySnap) {
        switch (mySnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          default:
            if (mySnap.hasError) {
              return Text('에러발생');
            } else {
              print(mySnap.data!.toString());
              return myInfoPage(mySnap.data!);
            }
        }
      },
    );
  }

  Future<MyData> fetchMyData() async {
    String _bloodType = '';
    String _email = '';
    String _emerCon1 = '';
    String _emerCon2 = '';
    try {
      if (await CustomFunc().checkIfDocExists(customID)) {
        await fsdb.collection('Users').doc(customID).get().then((snapshot) {
          final _familyDataMap = Map<String, dynamic>.from(snapshot.data()!);
          _bloodType = _familyDataMap['bloodType'];
          _email = _familyDataMap['email'];
          _emerCon1 = _familyDataMap['emergencyContact1'];
          _emerCon2 = _familyDataMap['emergencyContact2'];
        });
      }
    } catch (e) {
      CustomFunc().showToast('잠시후 다시 시도해주세요');
      print(e.toString());
    }
    return MyData(
        myName, myPhone, myBirth, _bloodType, _email, _emerCon1, _emerCon2);
  }

  Widget myInfoPage(MyData _myDataForUpdate) {
    return Text(
        '${_myDataForUpdate.name} \n${_myDataForUpdate.phone} \n${_myDataForUpdate.birth} \n${_myDataForUpdate.bloodType} \n${_myDataForUpdate.email} \n${_myDataForUpdate.emerCon1} \n${_myDataForUpdate.emerCon2} \n');
  }
}
