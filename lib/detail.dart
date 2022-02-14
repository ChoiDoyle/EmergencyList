import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expandable/expandable.dart';

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

  late Future<DetailsData> detailDataForUpdate;
  late Future<List<FamilyData>> familyDataForUpdate;
  late Future<List<FriendData>> friendDataForUpdate;

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
        body: SingleChildScrollView(
            child: Column(
          children: [
            detailsBuilder(),
            familyInfoBuilder(),
            friendInfoBuilder(),
          ],
        )),
      ),
    );
  }

  //그사람 디테일
  Widget detailsBuilder() {
    setState(() {
      detailDataForUpdate = fetchDetails();
    });
    return FutureBuilder<DetailsData>(
      future: detailDataForUpdate,
      builder: (context, detailsSnap) {
        switch (detailsSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          //TODOS: 인터넷 연결없는 상황에서 아래의 Text나오면 전체 적용
          case ConnectionState.none:
            return Text('인터넷이 연결되어있지 않습니다.');
          default:
            if (detailsSnap.hasError) {
              return Text('에러발생');
            } else {
              return detailsTable(detailsSnap.data!);
            }
        }
      },
    );
  }

  Future<DetailsData> fetchDetails() async {
    DetailsData _detailsDataUpdated = DetailsData('', '');
    await fsdb.collection('Users').doc(customID).get().then((_snapshot) {
      final _detailsSnap = Map<String, dynamic>.from(_snapshot.data()!);
      _detailsDataUpdated.email = _detailsSnap['email'];
      _detailsDataUpdated.bloodType = _detailsSnap['bloodType'];
    }).catchError((e) {
      CustomFunc().showToast('잠시후 다시 시도해주세요.');
    });
    return _detailsDataUpdated;
  }

  Widget detailsTable(DetailsData _detailsData) {
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 2, child: Center(child: Text('생일'))),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(myBirth),
                      )),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              )),
          Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 2, child: Center(child: Text('이메일'))),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(_detailsData.email),
                      )),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              )),
          Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 2, child: Center(child: Text('혈액형'))),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(_detailsData.bloodType),
                      )),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              )),
        ],
      ),
    );
  }

  //가족 데이터
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
          //TODOS: 인터넷 연결없는 상황에서 아래의 Text나오면 전체 적용
          case ConnectionState.none:
            return Text('인터넷이 연결되어있지 않습니다.');
          default:
            if (familySnap.hasError) {
              return Text('에러발생');
            } else {
              return ExpandablePanel(
                  header: Center(
                    child: Text('가족 정보',
                        style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  collapsed: SizedBox(
                    height: 100.h,
                    width: double.infinity,
                  ),
                  expanded: familySnap.data!.isEmpty
                      ? const Center(child: Text('아직 등록된 가족이 없습니다.'))
                      : familyList(familySnap.data!));
            }
        }
      },
    );
  }

  Future<List<FamilyData>> fetchFamilyData() async {
    List<FamilyData> _familyListUpdated = [];
    await rtdb.child('Users/$customID/family').get().then((_snapshot) {
      if (_snapshot.exists) {
        final _familyDataMap = Map<String, dynamic>.from(_snapshot.value);
        if (_familyDataMap.containsKey('empty')) {
          print('Details : no family data for $customID');
        } else {
          _familyDataMap.forEach((key, value) {
            final _listCustomID = key.toString().split('_');
            final _relation = value['relation'].toString();
            FamilyData _data = FamilyData(_listCustomID[1], _listCustomID[0],
                _listCustomID[2], _relation);
            _familyListUpdated.add(_data);
          });
        }
      } else {
        print('Details : no family data for $customID');
      }
    }).catchError((e) {
      CustomFunc().showToast('잠시후 다시 시도해주세요.');
    });
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

//지인 데이터
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
          //TODOS: 인터넷 연결없는 상황에서 아래의 Text나오면 전체 적용
          case ConnectionState.none:
            return Text('인터넷이 연결되어있지 않습니다.');
          default:
            if (friendSnap.hasError) {
              return Text('에러발생');
            } else {
              return ExpandablePanel(
                  header: Center(
                    child: Text('지인 정보',
                        style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  collapsed: SizedBox(
                    height: 100.h,
                    width: double.infinity,
                  ),
                  expanded: friendSnap.data!.isEmpty
                      ? const Center(child: Text('아직 등록된 지인이 없습니다.'))
                      : friendList(friendSnap.data!));
            }
        }
      },
    );
  }

  Future<List<FriendData>> fetchFriendData() async {
    List<FriendData> _friendListUpdated = [];
    await rtdb.child('Users/$customID/friend').get().then((_snapshot) {
      if (_snapshot.exists) {
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
      } else {
        print('Details : no friend data for $customID');
      }
    }).catchError((e) {
      CustomFunc().showToast('잠시후 다시 시도해주세요.');
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
}
