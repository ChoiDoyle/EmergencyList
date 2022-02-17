import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotiPage extends StatefulWidget {
  String customID;
  NotiPage({Key? key, required this.customID}) : super(key: key);

  @override
  _NotiPageState createState() => _NotiPageState(customID);
}

class _NotiPageState extends State<NotiPage> {
  String customID;

  _NotiPageState(this.customID);

  //Firebase & Firestore
  final fsdb = FirebaseFirestore.instance;
  final rtdb = FirebaseDatabase.instance.reference();

  late Future<List<NotiData>> notiDataForUpdate;

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
        appBar: CustomUI().simpleAppBar('$myName님의 알림'),
        body: SingleChildScrollView(child: notiBuilder()),
      ),
    );
  }

  Widget notiBuilder() {
    setState(() {
      notiDataForUpdate = fetchNotiData();
    });
    return FutureBuilder<List<NotiData>>(
      future: notiDataForUpdate,
      builder: (context, notiSnap) {
        switch (notiSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          default:
            if (notiSnap.hasError) {
              return Text('에러발생');
            } else {
              return notiList(notiSnap.data!);
            }
        }
      },
    );
  }

  Future<List<NotiData>> fetchNotiData() async {
    List<NotiData> _notiListUpdated = [];
    try {
      await rtdb.child('Request/$customID').get().then((_snapshot) {
        final _NotiDataMap = Map<String, dynamic>.from(_snapshot.value);
        if (_NotiDataMap.isEmpty) {
        } else {
          _NotiDataMap.forEach((key, value) {
            final _requestedID = key.toString();
            final _relation = value.toString();
            NotiData _data = NotiData(_requestedID, _relation);
            _notiListUpdated.add(_data);
          });
        }
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error: ${e.runtimeType}');
      if (e.runtimeType == TimeoutException) {
        CustomFunc().showToast('네트워크 상태를 확인하세요');
      } else {}
    }
    return _notiListUpdated;
  }

  Widget notiList(List<NotiData> _notiListUpdated) => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _notiListUpdated.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            onTap: () {
              showAcceptDialogFunc(context, _notiListUpdated[index].requestedID,
                  _notiListUpdated[index].relation);
            },
            child: notiCardUI(context, _notiListUpdated[index].requestedID,
                _notiListUpdated[index].relation));
      });

  notiCardUI(BuildContext context, _requestedID, _relation) {
    final _name = _requestedID.split('_')[1];
    final _phone = _requestedID.split('_')[0];
    final _birth = _requestedID.split('_')[2];
    String _relation4Me = CustomFunc().relation4MeConversion(_relation);
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.height * 0.05),
          ),
        ),
        padding: EdgeInsets.only(
          left: 10.h,
          top: 10.h,
          bottom: 10.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  width: 200.h,
                  height: 200.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.h),
                  )),
              SizedBox(width: 10.h),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$_name님이 당신의 $_relation4Me로 신청하셨습니다.',
                    style: TextStyle(
                        fontSize: 50.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20.h,
                ),
                Text('전화번호 : $_phone',
                    style: TextStyle(fontSize: 30.sp, color: Colors.black)),
                SizedBox(
                  height: 10.h,
                ),
                Text('생년월일 : $_birth',
                    style: TextStyle(fontSize: 30.sp, color: Colors.black)),
              ])
            ]),
          ],
        ),
      ),
    );
  }

  showAcceptDialogFunc(BuildContext context, _requestedID, _relation) {
    final _height = 200.h;
    final _width = MediaQuery.of(context).size.width * 0.8;
    final _relation4Me = CustomFunc().relation4MeConversion(_relation);
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.h),
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.all(10.h),
                      width: _width,
                      height: _height,
                      child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: _height - 20.h,
                                width: _width / 2 - 10.h,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      if (_relation4Me == '지인으') {
                                        await rtdb
                                            .child(
                                                'Users/$customID/friend/$_requestedID')
                                            .set({
                                          'level': 1,
                                          'relation': _relation
                                        }).timeout(const Duration(seconds: 5));
                                      } else {
                                        await rtdb
                                            .child(
                                                'Users/$customID/family/$_requestedID')
                                            .set({
                                          'relation': _relation4Me
                                        }).timeout(const Duration(seconds: 5));
                                      }
                                      await rtdb
                                          .child(
                                              'Request/$customID/$_requestedID')
                                          .remove()
                                          .then((_) {
                                        setState(() {
                                          notiDataForUpdate = fetchNotiData();
                                        });
                                        Navigator.pop(context);
                                      }).timeout(const Duration(seconds: 5));
                                    } catch (e) {
                                      if (e.runtimeType == TimeoutException) {
                                        CustomFunc()
                                            .showToast('네트워크 상태를 확인하세요');
                                      } else {}
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: FittedBox(child: Text('수락')),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      alignment: Alignment.center,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: _height - 20.h,
                                width: _width / 2 - 10.h,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await rtdb
                                          .child(
                                              'Request/$customID/$_requestedID')
                                          .remove()
                                          .then((_) {
                                        setState(() {
                                          notiDataForUpdate = fetchNotiData();
                                        });
                                        Navigator.pop(context);
                                      }).timeout(const Duration(seconds: 5));
                                    } catch (e) {
                                      if (e.runtimeType == TimeoutException) {
                                        CustomFunc()
                                            .showToast('네트워크 상태를 확인하세요');
                                      } else {}
                                    }
                                  },
                                  child: FittedBox(child: Text('거절')),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      alignment: Alignment.center,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              )
                            ]),
                      ))));
        });
  }
}
