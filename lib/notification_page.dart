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
      print('Error: $e');
      if (e.runtimeType == TimeoutException) {
        CustomFunc().showToast('네트워크 상태를 확인하세요');
      } else {
        CustomFunc().showToast('잠시후 다시 시도해주세요.');
      }
    }
    return _notiListUpdated;
  }

  Widget notiList(List<NotiData> _notiListUpdated) => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _notiListUpdated.length,
      itemBuilder: (_, index) {
        return GestureDetector(
            onTap: () {},
            child: notiCardUI(context, _notiListUpdated[index].requestedID,
                _notiListUpdated[index].relation));
      });

  notiCardUI(BuildContext context, _requestedID, _relation) {
    final _name = _requestedID.split('_')[1];
    final _phone = _requestedID.split('_')[0];
    final _birth = _requestedID.split('_')[2];
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
          left: 20.h,
          top: 20.h,
          bottom: 20.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                  )),
              SizedBox(width: 10.h),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 5,
                ),
                Text('이름 : $_name', style: TextStyle(color: Colors.black)),
                SizedBox(
                  height: 5,
                ),
                Text('전화번호 : $_phone', style: TextStyle(color: Colors.black)),
                SizedBox(
                  height: 5,
                ),
                Text('생년월일 : $_birth', style: TextStyle(color: Colors.black)),
                Text('관계 : $_relation', style: TextStyle(color: Colors.black)),
              ])
            ]),
          ],
        ),
      ),
    );
  }
}
