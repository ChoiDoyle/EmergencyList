import 'package:emergency_list/util_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    validateStoreName(context);
    super.initState();
  }

  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phone1InputController = TextEditingController();
  TextEditingController phone2InputController = TextEditingController();

  String? nameFinal = "";
  String? phoneFinal = "";
  String? emailFinal = "";
  DateTime? dateFinal;
  String bloodFinal = "";
  String? phone1Final = "";
  String? phone2Final = "";

  //Birth Date Picker
  DateTime dateTime = DateTime.now();

  //Blood Picker
  static List<String> types = ['A형', 'B형', 'AB형', 'O형'];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                        Colors.cyan.shade500,
                        Colors.cyan.shade300,
                        Colors.cyan.shade400
                      ])),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        '가입하기',
                        style: TextStyle(color: Colors.white, fontSize: 100.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '재난명부 Ver1.0',
                        style: TextStyle(color: Colors.white, fontSize: 70.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: Padding(
                          padding: EdgeInsets.all(30.h),
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100.h,
                                ),
                                //이름
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('이름',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                    padding: EdgeInsets.all(20.h),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      controller: nameInputController,
                                      decoration: InputDecoration(
                                          hintText: '이름을 입력하세요',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade300),
                                          border: InputBorder.none),
                                    )),
                                //전화번호
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('전화번호',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                    padding: EdgeInsets.all(5.h),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      controller: phoneInputController,
                                      decoration: InputDecoration(
                                          hintText: '전화번호를 입력하세요',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade300),
                                          border: InputBorder.none),
                                    )),
                                //생년월일
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('생년월일',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                  height: 400.h,
                                  padding: EdgeInsets.all(5.h),
                                  child: SizedBox(
                                      child: CupertinoDatePicker(
                                    minimumYear: 1900,
                                    maximumYear: DateTime.now().year,
                                    initialDateTime: dateTime,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (dateTime) =>
                                        setState(() => dateFinal = dateTime),
                                  )),
                                ),
                                //이메일
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('이메일',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                    padding: EdgeInsets.all(5.h),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      controller: emailInputController,
                                      decoration: InputDecoration(
                                          hintText: '이메일을 입력하세요',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade300),
                                          border: InputBorder.none),
                                    )),
                                //혈액형
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('혈액형',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                  height: 200.h,
                                  padding: EdgeInsets.all(5.h),
                                  child: SizedBox(
                                      child: CupertinoPicker(
                                    itemExtent: 100.h,
                                    onSelectedItemChanged: (index) => setState(
                                        () => bloodFinal = types[index]),
                                    selectionOverlay: Container(),
                                    diameterRatio: 0.9,
                                    children: PickerUtils.modelBuilder<String>(
                                        types, (index, value) {
                                      return Center(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 70.sp),
                                        ),
                                      );
                                    }),
                                  )),
                                ),
                                SizedBox(
                                  height: 100.h,
                                ),
                                //제 1연락처
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('제 1비상연락처',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                    padding: EdgeInsets.all(5.h),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      controller: phone1InputController,
                                      decoration: InputDecoration(
                                          hintText: '제 1비상연락처를 입력하세요',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade300),
                                          border: InputBorder.none),
                                    )),
                                //제 2연락처
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20.w),
                                  padding: EdgeInsets.all(20.h),
                                  child: Text('제 2비상연락처',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 40.sp)),
                                ),
                                Container(
                                    padding: EdgeInsets.all(5.h),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey))),
                                    child: TextField(
                                      controller: phone2InputController,
                                      decoration: InputDecoration(
                                          hintText: '제 2비상연락처를 입력하세요',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade300),
                                          border: InputBorder.none),
                                    )),
                                ElevatedButton(
                                  onPressed: () async {
                                    nameFinal = nameInputController.text;
                                    phoneFinal = phoneInputController.text;
                                    emailFinal = emailInputController.text;
                                    print(nameFinal);
                                    print(bloodFinal);
                                    if (nameFinal == "" ||
                                        phoneFinal == "" ||
                                        emailFinal == "" ||
                                        dateFinal == null ||
                                        bloodFinal == "" ||
                                        phone1Final == "" ||
                                        phone2Final == "") {
                                      showToast();
                                    }
                                    /*if (credentials.contains(combiFinal)) {
                                      final SharedPreferences
                                          sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      //sharedPreferences.setString('storeName', idFinal);
                                      /*Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Home(storeID: idFinal)));*/
                                    } else {
                                      showToast();
                                    }*/
                                  },
                                  child: const Text('Login'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.cyan.shade500,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 100, vertical: 10),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future validateStoreName(context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var storeName = sharedPreferences.getString('storeName');
    if (storeName == null) {
    } else {
      /*Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home(storeID: storeName)));*/
    }
  }

  void showToast() => Fluttertoast.showToast(
      msg: "공란을 다 채워주세요!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.cyan,
      textColor: Colors.white,
      fontSize: 70.sp);
}
