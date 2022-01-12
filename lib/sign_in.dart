import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Authentication/auth.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/home.dart';
import 'package:emergency_list/Reference/util_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  //Firebase Auth
  final AuthService _auth = AuthService();
  //Firebase Database
  final database = FirebaseDatabase.instance.reference();

  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phone1InputController = TextEditingController();
  TextEditingController phone2InputController = TextEditingController();

  String nameFinal = "";
  String phoneFinal = "";
  String emailFinal = "";
  DateTime? birthFinal;
  String bloodFinal = "";
  String phone1Final = "";
  String phone2Final = "";

  //Bottom Navigation Bar
  int navigationIndex = 0;

  //Birth Date Picker
  DateTime dateTime = DateTime.now();

  //Blood Picker
  static List<String> types = ['A형', 'B형', 'AB형', 'O형'];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.cyan,
      child: Scaffold(
        backgroundColor: Colors.cyan,
        body: pageBuilder(),
        bottomNavigationBar: buildNavigationBar(),
      ),
    );
  }

  Widget pageBuilder() {
    return navigationIndex == 0 ? logInPage(context) : signUpPage(context);
  }

  //Login Page
  Column logInPage(BuildContext context) {
    nameFinal = "";
    phoneFinal = "";
    birthFinal = null;
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Column(
                children: <Widget>[
                  CustomUI().sizedBox(40),
                  Text(
                    '로그인하기',
                    style: TextStyle(color: Colors.white, fontSize: 100.sp),
                  ),
                  CustomUI().sizedBox(10),
                  Text(
                    '재난명부 Ver1.0',
                    style: TextStyle(color: Colors.white, fontSize: 70.sp),
                  ),
                  CustomUI().sizedBox(20),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: Padding(
                      padding: EdgeInsets.all(30.h),
                      child: Column(
                        children: [
                          CustomUI().sizedBox(100),
                          //이름
                          CustomUI().titleForInput(context, '이름'),
                          Container(
                              padding: EdgeInsets.all(20.h),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: nameInputController,
                                decoration: InputDecoration(
                                    hintText: '이름을 입력하세요',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade300),
                                    border: InputBorder.none),
                              )),
                          CustomUI().sizedBox(50),
                          //전화번호
                          CustomUI().titleForInput(context, '전화번호'),
                          Container(
                              padding: EdgeInsets.all(20.h),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: phoneInputController,
                                decoration: InputDecoration(
                                    hintText: '전화번호를 입력하세요',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade300),
                                    border: InputBorder.none),
                              )),
                          CustomUI().sizedBox(50),
                          //생년월일
                          CustomUI().titleForInput(context, '생년월일'),
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
                                  setState(() => birthFinal = dateTime),
                            )),
                          ),
                          CustomUI().sizedBox(350),
                          //로그인 버튼
                          logInBTN(context),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  ElevatedButton logInBTN(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        nameFinal = nameInputController.text;
        phoneFinal = phoneInputController.text;
        if (nameFinal == "" || phoneFinal == "" || birthFinal == null) {
          CustomUI().showToast('공란을 다 채워주세요!!');
        } else {
          dynamic result = await _auth.signInAnon();
          if (result == null) {
            CustomUI().showToast('err: 로그인에 실패했습니다. 다시 시도해주세요');
          } else {
            //CustomUI().showToast('로그인 성공');
            print(result);
            final customID =
                '${phoneFinal}_${nameFinal}_${birthFinal.toString().split(' ')[0]}';
            //TODOS: customID를 가지는 데이터 있으면 로그인, 없으면 로그인 하지 않기
            CustomFunc().storeString('customID', customID);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Home()));
          }
        }
      },
      child: const Text('로그인하기'),
      style: ElevatedButton.styleFrom(
          primary: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  //Sign Up Page
  Column signUpPage(BuildContext context) {
    nameFinal = "";
    phoneFinal = "";
    emailFinal = "";
    birthFinal = null;
    bloodFinal = "";
    phone1Final = "";
    phone2Final = "";
    return Column(
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
                    CustomUI().sizedBox(40),
                    Text(
                      '가입하기',
                      style: TextStyle(color: Colors.white, fontSize: 100.sp),
                    ),
                    CustomUI().sizedBox(10),
                    Text(
                      '재난명부 Ver1.0',
                      style: TextStyle(color: Colors.white, fontSize: 70.sp),
                    ),
                    CustomUI().sizedBox(20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(60))),
                      child: Padding(
                        padding: EdgeInsets.all(30.h),
                        child: Column(
                          children: [
                            CustomUI().sizedBox(100),
                            //이름
                            CustomUI().titleForInput(context, '이름'),
                            Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: nameInputController,
                                  decoration: InputDecoration(
                                      hintText: '이름을 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                            //전화번호
                            CustomUI().titleForInput(context, '전화번호'),
                            Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: phoneInputController,
                                  decoration: InputDecoration(
                                      hintText: '전화번호를 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                            //생년월일
                            CustomUI().titleForInput(context, '생년월일'),
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
                                    setState(() => birthFinal = dateTime),
                              )),
                            ),
                            //이메일
                            CustomUI().titleForInput(context, '이메일'),
                            Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: emailInputController,
                                  decoration: InputDecoration(
                                      hintText: '이메일을 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                            //혈액형
                            CustomUI().titleForInput(context, '혈액형'),
                            Container(
                              height: 200.h,
                              padding: EdgeInsets.all(5.h),
                              child: SizedBox(
                                  child: CupertinoPicker(
                                itemExtent: 100.h,
                                onSelectedItemChanged: (index) =>
                                    setState(() => bloodFinal = types[index]),
                                selectionOverlay: Container(),
                                diameterRatio: 0.9,
                                children: PickerUtils.modelBuilder<String>(
                                    types, (index, value) {
                                  return Center(
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 70.sp),
                                    ),
                                  );
                                }),
                              )),
                            ),
                            CustomUI().sizedBox(100),
                            //제 1연락처
                            CustomUI().titleForInput(context, '제 1비상연락처'),
                            Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: phone1InputController,
                                  decoration: InputDecoration(
                                      hintText: '제 1비상연락처를 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                            //제 2연락처
                            CustomUI().titleForInput(context, '제 2비상연락처'),
                            Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: phone2InputController,
                                  decoration: InputDecoration(
                                      hintText: '제 2비상연락처를 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                            //회원가입 버튼
                            signUpBTN(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  ElevatedButton signUpBTN(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        nameFinal = nameInputController.text;
        phoneFinal = phoneInputController.text;
        emailFinal = emailInputController.text;
        phone1Final = phone1InputController.text;
        phone2Final = phone2InputController.text;
        print(birthFinal.runtimeType);
        if (nameFinal == "" ||
            phoneFinal == "" ||
            emailFinal == "" ||
            birthFinal == null ||
            bloodFinal == "" ||
            phone1Final == "" ||
            phone2Final == "") {
          CustomUI().showToast('공란을 다 채워주세요!!');
        } else {
          dynamic result = await _auth.signInAnon();
          if (result == null) {
            print('error signing in');
          } else {
            print('signed in');
            print(result);
            final customID =
                '${phoneFinal}_${nameFinal}_${birthFinal.toString().split(' ')[0]}';
            database
                .child('Users/$customID')
                .set({
                  'email': emailFinal,
                  'bloodType': bloodFinal,
                  'emergencyContact1': phone1Final,
                  'emergencyContact2': phone2Final
                })
                .then((_) => {
                      print('uploaded'),
                      CustomFunc().storeString('customID', customID),
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Home()))
                    })
                .catchError((error) => {print('not uploaded'), print(error)});
          }
        }
      },
      child: const Text('등록하기'),
      style: ElevatedButton.styleFrom(
          primary: Colors.cyan.shade500,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  //Bottom Navigation Bar
  BottomNavigationBar buildNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.cyan,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationIndex,
      onTap: (index) => setState(() => navigationIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: '로그인하기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '등록하기',
        ),
      ],
    );
  }
}
