import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomUI {
  Container titleForInput(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20.w),
      padding: EdgeInsets.all(20.h),
      child: Text(title,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black, fontSize: 40.sp)),
    );
  }

  Container controllerForInput(TextEditingController controller, String hint) {
    return Container(
        padding: EdgeInsets.all(20.h),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade300),
              border: InputBorder.none),
        ));
  }

  SizedBox sizedBox(int height) {
    return SizedBox(
      height: height.h,
    );
  }

  void showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.cyan,
      textColor: Colors.white,
      fontSize: 70.sp);
}
