import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Authentication/auth.dart';
import 'package:emergency_list/Authentication/wrapper.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  String customID;
  Home({Key? key, required this.customID}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(customID);
}

class _HomeState extends State<Home> {
  String customID;
  _HomeState(this.customID);
  //Firebase Authentication
  final AuthService _auth = AuthService();

  //Firebase & Firestore
  final fsdb = FirebaseFirestore.instance;
  final rtdb = FirebaseDatabase.instance.reference();

  //My Credential:-
  String myPhone = '';
  String myName = '';
  String myBirth = '';

  int navigationIndex = 0;

  //myData
  late Future<List<FamilyData>> familyDataForUpdate;
  late Future<List<FriendData>> friendDataForUpdate;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    myPhone = customID.split('_')[0];
    myName = customID.split('_')[1];
    myBirth = customID.split('_')[2];
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _key,
        drawer: Drawer(),
        appBar: AppBar(
          title: Text(
            '$myName님의 재난명부',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _key.currentState?.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((_) => {
                      CustomFunc().removeString('customID'),
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Wrapper()))
                    });
              },
            ),
          ],
        ),
        body: navigationIndex == 0 ? familyInfoBuilder() : familyInfoBuilder(),
        bottomNavigationBar: buildNavigationBar(),
      ),
    );
  }

  Widget familyInfoBuilder() {
    setState(() {
      familyDataForUpdate = fetchFamilyData();
    });
    return FutureBuilder<List<FamilyData>>(
      future: familyDataForUpdate,
      builder: (context, familySnap) {
        switch (familySnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: Text('loading...'));
          default:
            if (familySnap.hasError) {
              return Text('에러발생');
            } else {
              print(familySnap.data!.toString());
              return familySnap.data!.isEmpty
                  ? startInitialize()
                  : familyList(familySnap.data!);
            }
        }
      },
    );
  }

  Widget startInitialize() {
    return Center(
      child: Container(
        height: 200.h,
        width: 500.h,
        child: ElevatedButton(
            onPressed: () {
              print('2');
            },
            child: FittedBox(
              child: Text(
                '가족 등록',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            )),
      ),
    );
  }

  Future<List<FamilyData>> fetchFamilyData() async {
    List<FamilyData> _familyListUpdated = [];
    await rtdb.child('Users/$customID/family').get().then((snapshot) {
      final _familyDataMap = Map<String, dynamic>.from(snapshot.value);
      if (_familyDataMap.containsKey('empty')) {
      } else {
        _familyDataMap.forEach((key, value) {
          final _listCustomID = key.toString().split('_');
          final _relation = value['relation'].toString();
          FamilyData _data = FamilyData(
              _listCustomID[1], _listCustomID[0], _listCustomID[2], _relation);
          _familyListUpdated.add(_data);
        });
      }
    });
    return _familyListUpdated;
  }

  Widget familyList(List<FamilyData> _familyListUpdated) => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _familyListUpdated.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            onTap: () {
              print('tapped');
              /*showPaymentDialogFunc(
                  context,
                  '${paymentListUpdated[index].phone}_${paymentListUpdated[index].table}',
                  paymentListUpdated[index].menu);*/
            },
            child: familyCardUI(
                _familyListUpdated[index].name,
                _familyListUpdated[index].phone,
                _familyListUpdated[index].birth,
                _familyListUpdated[index].relation));
      });

  Widget familyCardUI(
      String _name, String _phone, String _birth, String _relation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0, top: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(MediaQuery.of(context).size.height * 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.15),
                  offset: const Offset(-10.0, 0.0),
                  blurRadius: 20.0,
                  spreadRadius: 4.0,
                )
              ]),
          padding: const EdgeInsets.only(
            left: 30,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 0.1.h,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  _relation,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '전화번호 : $_phone',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '생일 : $_birth',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }

  /*Widget friendInfoBuilder() {
    setState(() {
      friendDataForUpdate = fetchFriendData();
    });
    return FutureBuilder<List<FriendData>>(
      future: friendDataForUpdate,
      builder: (context, friendSnap) {
        switch (friendSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: Text('loading...'));
          default:
            if (friendSnap.hasError) {
              return Text('에러발생');
            } else {
              print(friendSnap.data!.toString());
              return friendSnap.data!.isEmpty
                  ? Container(
                      child: Text('need to be implemented when null'),
                    )
                  : friendList(friendSnap.data!);
            }
        }
      },
    );
  }

  Future<List<FriendData>> fetchFriendData() async {
    List<FriendData> _friendListUpdated = [];
    await rtdb.child('Users/$customID/emptyFlag').get().then((snapshot) async {
      if (snapshot.value == true) {
      } else {
        await rtdb.child('Users/$customID/family').get().then((snapshot) {
          final _familyDataMap = Map<String, dynamic>.from(snapshot.value);
          _familyDataMap.forEach((key, value) {
            final _listCustomID = key.toString().split('_');
            final _relation = value['relation'].toString();
            FriendData _data = FriendData(_listCustomID[1], _listCustomID[0],
                _listCustomID[2], _relation);
            _friendListUpdated.add(_data);
          });
        });
      }
    });
    return _friendListUpdated;
  }*/

  BottomNavigationBar buildNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: navigationIndex,
      onTap: (index) => setState(() => navigationIndex = index),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: '가족', backgroundColor: Colors.cyan),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '지인',
            backgroundColor: Colors.cyan),
      ],
    );
  }
}
