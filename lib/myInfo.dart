import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/data.dart';
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

  late Future<List<MyData>> myDataForUpdate;

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
        appBar: AppBar(
          title: Text(
            '$myName님의 재난명부',
            style: TextStyle(color: Colors.black),
          ),
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
        body: myInfoBuilder(),
      ),
    );
  }

  Widget myInfoBuilder() {
    setState(() {
      myDataForUpdate = fetchMyData();
    });
    return FutureBuilder<List<MyData>>(
      future: myDataForUpdate,
      builder: (context, familySnap) {
        switch (familySnap.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          default:
            if (familySnap.hasError) {
              return Text('에러발생');
            } else {
              print(familySnap.data!.toString());
              return myInfoPage();
            }
        }
      },
    );
  }

  Future<List<MyData>> fetchMyData() async {
    List<MyData> _myListUpdated = [];
    await fsdb.collection('Users').doc(customID).get().then((snapshot) {
      final _familyDataMap = Map<String, dynamic>.from(snapshot.value);
      if (_familyDataMap.containsKey('empty')) {
      } else {
        _familyDataMap.forEach((key, value) {
          final _listCustomID = key.toString().split('_');
          final _relation = value['relation'].toString();
          MyData _data = MyData(
              _listCustomID[1], _listCustomID[0], _listCustomID[2], _relation);
          _myListUpdated.add(_data);
        });
      }
    });
    return _myListUpdated;
  }

  Widget myInfoPage() {
    return Container();
  }
}
