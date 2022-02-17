import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

//2초 딜레이 주고 싶을 때
//await Future.delayed(Duration(seconds: 2));

class CustomFunc {
  Future giveDelay(int _duration) async {
    await Future.delayed(Duration(milliseconds: _duration));
  }

  Future storeString(String id, String content) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(id, content);
  }

  //return하면 안되고 이 함수안에 모든걸 해야댐...
  Future streamString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String a = sharedPreferences.getString(id).toString();
    print(a);
    return a;
  }

  //removeString은 다른 type의 variable도 remove 가능
  Future removeString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(id);
  }

  Future<bool> checkIfDocExists(String docID) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(docID).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  void showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.cyan,
      textColor: Colors.white,
      fontSize: 70.sp);

  String relation4MeConversion(String _relation) {
    String _relation4Me = '';
    switch (_relation) {
      case '지인':
        _relation4Me = '지인으';
        break;
      case '아버지':
        _relation4Me = '자녀';
        break;
      case '어머니':
        _relation4Me = '자녀';
        break;
      case '형제자매':
        _relation4Me = _relation;
        break;
    }
    return _relation4Me;
  }

  //페이지 이동
  void popPage(BuildContext context, page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  void startPage(BuildContext context, page) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => page,
        ));
  }
}
