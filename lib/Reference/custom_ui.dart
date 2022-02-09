import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

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

  SizedBox sizedHeightBox(double height) {
    return SizedBox(
      height: height.h,
    );
  }

  SizedBox sizedWidthBox(double width) {
    return SizedBox(
      width: width.h,
    );
  }

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

  Widget customLoading() {
    return SizedBox(
        height: 500.h,
        width: 500.h,
        child: Lottie.asset('assets/loading.json'));
  }

  PreferredSizeWidget simpleAppBar(String _title) {
    return AppBar(
      title: FittedBox(
        alignment: Alignment.center,
        child: Text(
          _title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.grey[200],
      /*actions: <Widget>[
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
          ],*/
    );
  }
}
