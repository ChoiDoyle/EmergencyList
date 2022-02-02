import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/util_picker.dart';
import 'package:emergency_list/otp_auth_p.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum LoadingState { init, loading, done }

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

  //Firebase Database
  final rtdb = FirebaseDatabase.instance.reference();
  final fsdb = FirebaseFirestore.instance;

  //Loading Spinner
  bool _isAnimating = true;
  LoadingState state = LoadingState.init;

  TextEditingController nameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController phone1InputController = TextEditingController();
  TextEditingController phone2InputController = TextEditingController();

  String nameFinal = "";
  String phoneFinal = "";
  String emailFinal = "";
  DateTime? birthDate;
  String bloodFinal = "";
  String phone1Final = "";
  String phone2Final = "";
  String birthFinal = "";

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
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height - 400.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Column(
                  children: <Widget>[
                    CustomUI().sizedHeightBox(40),
                    Text(
                      '로그인하기',
                      style: TextStyle(color: Colors.white, fontSize: 100.sp),
                    ),
                    CustomUI().sizedHeightBox(10),
                    Text(
                      '재난명부 Ver1.0',
                      style: TextStyle(color: Colors.white, fontSize: 70.sp),
                    ),
                    CustomUI().sizedHeightBox(20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.all(30.h),
                        child: Column(
                          children: [
                            CustomUI().sizedHeightBox(100),
                            //이름
                            CustomUI().titleForInput(context, '이름'),
                            CustomUI().controllerForInput(nameInputController,
                                '이름을 입력하세요', TextInputType.name),
                            CustomUI().sizedHeightBox(50),
                            //전화번호
                            CustomUI().titleForInput(context, '전화번호'),
                            CustomUI().controllerForInput(phoneInputController,
                                '전화번호를 입력하세요', TextInputType.phone),
                            CustomUI().sizedHeightBox(50),
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
                                    setState(() => birthDate = dateTime),
                              )),
                            ),
                            CustomUI().sizedHeightBox(900.h),
                            //로그인 버튼
                            logInBTNBuilder(),
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

  Widget logInBTNBuilder() {
    final _isStretched = _isAnimating || state == LoadingState.init;
    final _isDone = state == LoadingState.done;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      width: state == LoadingState.init ? 1000.h : 150.h,
      onEnd: () => setState(() => _isAnimating = !_isAnimating),
      height: 150.h,
      child: _isStretched ? logInBTN() : CustomUI().buildLoading(_isDone),
    );
  }

  ElevatedButton logInBTN() {
    return ElevatedButton(
        onPressed: () async {
          setState(() {
            state = LoadingState.loading;
          });
          await CustomFunc().giveDelay(500);
          nameFinal = nameInputController.text;
          phoneFinal = phoneInputController.text;
          if (nameFinal == "" || phoneFinal == "" || birthDate == null) {
            CustomFunc().showToast('공란을 다 채워주세요!!');
          } else {
            birthFinal = birthDate.toString().split(' ')[0];
            final customID = '${phoneFinal}_${nameFinal}_$birthFinal';
            if (await CustomFunc().checkIfDocExists(customID)) {
              setState(() {
                state = LoadingState.done;
              });
              await CustomFunc().giveDelay(500);
              CustomFunc().popPage(context,
                  OTPAuth(credential: ['logIn', customID, '0', '0', '0', '0']));
            } else {
              CustomFunc().showToast('일치하는 유저가 없습니다.');
            }
          }
          setState(() {
            state = LoadingState.init;
          });
        },
        child: FittedBox(
          child: Text(
            '로그인하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ));
  }

  //Sign Up Page
  Column signUpPage(BuildContext context) {
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
                    CustomUI().sizedHeightBox(40),
                    Text(
                      '가입하기',
                      style: TextStyle(color: Colors.white, fontSize: 100.sp),
                    ),
                    CustomUI().sizedHeightBox(10),
                    Text(
                      '재난명부 Ver1.0',
                      style: TextStyle(color: Colors.white, fontSize: 70.sp),
                    ),
                    CustomUI().sizedHeightBox(20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.all(30.h),
                        child: Column(
                          children: [
                            CustomUI().sizedHeightBox(100),
                            //이름
                            CustomUI().titleForInput(context, '이름'),
                            CustomUI().controllerForInput(nameInputController,
                                '이름을 입력하세요', TextInputType.name),
                            //전화번호
                            CustomUI().titleForInput(context, '전화번호'),
                            CustomUI().controllerForInput(phoneInputController,
                                '전화번호를 입력하세요', TextInputType.phone),
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
                                    setState(() => birthDate = dateTime),
                              )),
                            ),
                            //이메일
                            CustomUI().titleForInput(context, '이메일'),
                            CustomUI().controllerForInput(emailInputController,
                                '이메일을 입력하세요', TextInputType.emailAddress),
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
                            CustomUI().sizedHeightBox(100),
                            //제 1연락처
                            CustomUI().titleForInput(context, '제 1비상연락처'),
                            CustomUI().controllerForInput(phone1InputController,
                                '제 1비상연락처를 입력하세요', TextInputType.phone),
                            //제 2연락처
                            CustomUI().titleForInput(context, '제 2비상연락처'),
                            CustomUI().controllerForInput(phone2InputController,
                                '제 2비상연락처를 입력하세요', TextInputType.phone),
                            CustomUI().sizedHeightBox(100.h),
                            //회원가입 버튼
                            signUpBTNBuilder(),
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

  Widget signUpBTNBuilder() {
    bool _isAnimating = true;
    final _isStretched = _isAnimating || state == LoadingState.init;
    final _isDone = state == LoadingState.done;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      width: state == LoadingState.init ? 1000.h : 200.h,
      onEnd: () => setState(() => _isAnimating = !_isAnimating),
      height: 200.h,
      child: _isStretched ? signUpBTN() : CustomUI().buildLoading(_isDone),
    );
  }

  ElevatedButton signUpBTN() {
    return ElevatedButton(
        onPressed: () async {
          setState(() {
            state = LoadingState.loading;
          });
          nameFinal = nameInputController.text;
          phoneFinal = phoneInputController.text;
          emailFinal = emailInputController.text;
          phone1Final = phone1InputController.text;
          phone2Final = phone2InputController.text;
          if (nameFinal == "" ||
              phoneFinal == "" ||
              emailFinal == "" ||
              birthDate == null ||
              bloodFinal == "" ||
              phone1Final == "" ||
              phone2Final == "") {
            CustomFunc().showToast('공란을 다 채워주세요!!');
          } else {
            birthFinal = birthDate.toString().split(' ')[0];
            final customID = '${phoneFinal}_${nameFinal}_${birthFinal}';
            if (await CustomFunc().checkIfDocExists(customID)) {
              CustomFunc().showToast('유저가 이미 존재합니다. 로그인 해주세요!');
            } else {
              setState(() {
                state = LoadingState.done;
              });
              CustomFunc().giveDelay(500);
              CustomFunc().popPage(
                  context,
                  OTPAuth(
                    credential: [
                      'signUp',
                      customID,
                      emailFinal,
                      bloodFinal,
                      phone1Final,
                      phone2Final
                    ],
                  ));
            }
          }
          setState(() {
            state = LoadingState.init;
          });
        },
        child: FittedBox(
          child: Text(
            '등록하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ));
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
