import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Authentication/auth.dart';
import 'package:emergency_list/Authentication/wrapper.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/data.dart';
import 'package:emergency_list/detail.dart';
import 'package:emergency_list/myInfo.dart';
import 'package:emergency_list/notification_page.dart';
import 'package:emergency_list/register.dart';
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

  //My Data:-
  late Future<List<FamilyData>> familyDataForUpdate;
  late Future<List<String>> familyCommonDataForUpdate;
  late Future<List<FriendData>> friendDataForUpdate;

  //Family Data:-
  String familyID = '';
  List<String> searchedData = ['email', 'place'];

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
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
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
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _key.currentState?.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notification_important,
                color: Colors.black,
              ),
              onPressed: () {
                CustomFunc().popPage(context, NotiPage(customID: customID));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            navigationIndex == 0
                ? familyCommonInfoBuilder()
                : Container(height: 0),
            navigationIndex == 0
                ? familyInfoBuilder()
                : navigationIndex == 1
                    ? friendInfoBuilder()
                    : Container(),
          ],
        )),
        bottomNavigationBar: buildNavigationBar(),
      ),
    );
  }

  Widget familyCommonInfoBuilder() {
    setState(() {
      familyCommonDataForUpdate = fetchCommonFamilyData();
    });
    return FutureBuilder<List<String>>(
      future: familyCommonDataForUpdate,
      builder: (context, familyCommonSnap) {
        switch (familyCommonSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          default:
            if (familyCommonSnap.hasError) {
              return Text('에러발생');
            } else {
              return familyCommonTable(familyCommonSnap.data!);
            }
        }
      },
    );
  }

  Future<List<String>> fetchCommonFamilyData() async {
    searchedData = ['email', 'place'];
    await fsdb
        .collection('Family')
        .where('member', arrayContains: customID)
        .get()
        .then((_snapshot) {
      _snapshot.docs.forEach((element) {
        familyID = element.id;
        final _searchedDataSingle = Map<String, dynamic>.from(element.data());
        if (_searchedDataSingle['email'] != null) {
          searchedData[0] = _searchedDataSingle['email'];
        }
        if (_searchedDataSingle['place'] != null) {
          searchedData[1] = _searchedDataSingle['place'];
        }
      });
    }).catchError((e) => CustomFunc().showToast('잠시후 다시 시도해주세요.'));
    return searchedData;
  }

  Widget familyCommonTable(List<String> _familyCommonData) {
    return Container(
      height: 300.h,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 2, child: Center(child: Text('가족 메일'))),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: _familyCommonData[0] == 'email'
                            ? initializeBTN('email')
                            : Text(_familyCommonData[0]),
                      )),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 1,
                    child: _familyCommonData[0] == 'email'
                        ? const SizedBox()
                        : editBTN(context, 'email'),
                  ),
                ],
              )),
          Expanded(
              flex: 5,
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 2, child: Center(child: Text('재난 장소'))),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: _familyCommonData[1] == 'place'
                            ? initializeBTN('place')
                            : Text(_familyCommonData[1]),
                      )),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 1,
                    child: _familyCommonData[1] == 'place'
                        ? const SizedBox()
                        : editBTN(context, 'place'),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  GestureDetector editBTN(BuildContext context, String _commonData) {
    return GestureDetector(
      onTap: () {
        showCommonDataDialog(context, _commonData);
      },
      child: Text(
        '변경',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  showCommonDataDialog(BuildContext context, String _commonData) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController _commonDataInputController =
              TextEditingController();
          String _commonDataFinal = '';
          return Center(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.all(10.h),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 400.h,
                      child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CustomUI().sizedHeightBox(30),
                              CustomUI().controllerForInput(
                                  _commonDataInputController,
                                  '정보를 입력하세요.',
                                  TextInputType.text),
                              ElevatedButton(
                                onPressed: () {
                                  _commonDataFinal =
                                      _commonDataInputController.text;
                                  if (_commonData == 'email') {
                                    fsdb
                                        .collection('Family')
                                        .doc(familyID)
                                        .update({
                                      'email': _commonDataFinal
                                    }).then((_) {
                                      Navigator.pop(context);
                                      setState(() {
                                        searchedData[0] = _commonDataFinal;
                                      });
                                    }).catchError((e) => CustomFunc()
                                            .showToast('잠시후 다시 시도해주세요.'));
                                  } else {
                                    fsdb
                                        .collection('Family')
                                        .doc(familyID)
                                        .update({
                                      'place': _commonDataFinal
                                    }).then((_) {
                                      Navigator.pop(context);
                                      setState(() {
                                        searchedData[1] = _commonDataFinal;
                                      });
                                    }).catchError((e) => CustomFunc()
                                            .showToast('잠시후 다시 시도해주세요.'));
                                  }
                                },
                                child: Text('변경'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    alignment: Alignment.center,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )
                            ]),
                      ))));
        });
  }

  ElevatedButton initializeBTN(String _commonData) {
    return ElevatedButton(
        onPressed: () {
          print(_commonData);
          showCommonDataDialog(context, _commonData);
        },
        child: Text('추가하기'));
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
            return Center(child: CustomUI().customLoading());
          default:
            if (familySnap.hasError) {
              return Text('에러발생');
            } else {
              return familySnap.data!.isEmpty
                  ? startInitialize('family')
                  : familyList(familySnap.data!);
            }
        }
      },
    );
  }

  Widget startInitialize(String _mode) {
    return Center(
      child: SizedBox(
        height: 200.h,
        width: 500.h,
        child: ElevatedButton(
            onPressed: () {
              CustomFunc().popPage(context, Register(customID: customID));
            },
            child: FittedBox(
              child: Text(
                _mode == 'family' ? '가족 등록' : '지인 등록',
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
    await rtdb.child('Users/$customID/family').get().then((_snapshot) {
      final _familyDataMap = Map<String, dynamic>.from(_snapshot.value);
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
    }).catchError((e) => CustomFunc().showToast('잠시후 다시 시도해주세요.'));
    return _familyListUpdated;
  }

  Widget familyList(List<FamilyData> _familyListUpdated) => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _familyListUpdated.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            onTap: () {
              final _customID = _familyListUpdated[index].phone +
                  '_' +
                  _familyListUpdated[index].name +
                  '_' +
                  _familyListUpdated[index].birth;
              CustomFunc().popPage(context, Detail(customID: _customID));
            },
            child: CustomUI().familyCardUI(
                context,
                _familyListUpdated[index].name,
                _familyListUpdated[index].phone,
                _familyListUpdated[index].birth,
                _familyListUpdated[index].relation));
      });

  Widget friendInfoBuilder() {
    setState(() {
      friendDataForUpdate = fetchFriendData();
    });
    return FutureBuilder<List<FriendData>>(
      future: friendDataForUpdate,
      builder: (context, friendSnap) {
        switch (friendSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          default:
            if (friendSnap.hasError) {
              return Text('에러발생');
            } else {
              return friendSnap.data!.isEmpty
                  ? startInitialize('friend')
                  : friendList(friendSnap.data!);
            }
        }
      },
    );
  }

  Future<List<FriendData>> fetchFriendData() async {
    List<FriendData> _friendListUpdated = [];
    await rtdb.child('Users/$customID/friend').get().then((_snapshot) {
      final _friendDataMap = Map<String, dynamic>.from(_snapshot.value);
      if (_friendDataMap.containsKey('empty')) {
      } else {
        _friendDataMap.forEach((key, value) {
          final _listCustomID = key.toString().split('_');
          final _relation = value['relation'].toString();
          final _level = value['level'];
          FriendData _data = FriendData(_listCustomID[1], _listCustomID[0],
              _listCustomID[2], _relation, _level);
          _friendListUpdated.add(_data);
        });
      }
    });
    return _friendListUpdated;
  }

  Widget friendList(List<FriendData> _friendListUpdated) => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _friendListUpdated.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            onTap: () {
              final _customID = _friendListUpdated[index].phone +
                  '_' +
                  _friendListUpdated[index].name +
                  '_' +
                  _friendListUpdated[index].birth;
              CustomFunc().popPage(context, Detail(customID: _customID));
            },
            child: CustomUI().friendCardUI(
                context,
                _friendListUpdated[index].name,
                _friendListUpdated[index].phone,
                _friendListUpdated[index].birth,
                _friendListUpdated[index].relation,
                _friendListUpdated[index].level));
      });

  BottomNavigationBar buildNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: navigationIndex,
      onTap: (index) => setState(() => navigationIndex = index),
      fixedColor: Colors.black,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom, color: Colors.black),
            label: '가족',
            backgroundColor: Colors.grey[200]),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            label: '지인',
            backgroundColor: Colors.grey[200]),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: '내 정보',
            backgroundColor: Colors.grey[200]),
      ],
    );
  }
}
