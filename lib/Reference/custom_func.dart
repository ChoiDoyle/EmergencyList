import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/menu_item.dart';
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

  //페이지 우측상단 PopUpMenuButton 관련
  PopupMenuItem<HomeMenuItem> buildMenuItems(HomeMenuItem item) =>
      PopupMenuItem<HomeMenuItem>(
          value: item,
          child: Row(children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 70.h,
            ),
            CustomUI().sizedWidthBox(30),
            Text(
              item.text,
              style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
            )
          ]));
}
