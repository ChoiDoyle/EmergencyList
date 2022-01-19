import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Container controllerForInput(TextEditingController controller, String hint,
      TextInputType _textInputType) {
    return Container(
        padding: EdgeInsets.all(20.h),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: TextField(
          controller: controller,
          keyboardType: _textInputType,
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

  Widget buildButton() => OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(width: 6.h, color: Colors.cyan),
        ),
        child: Text(
          '로그인하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {},
      );

  Widget buildLoading(bool _isDone) {
    final _color = _isDone ? Colors.green : Colors.cyan;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
      child: Center(
        child: _isDone
            ? Icon(
                Icons.done,
                size: 120.h,
                color: Colors.white,
              )
            : CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
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
