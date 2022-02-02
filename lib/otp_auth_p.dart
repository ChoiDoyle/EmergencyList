import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPAuth extends StatefulWidget {
  List<String> credential;
  OTPAuth({Key? key, required this.credential}) : super(key: key);

  @override
  _OTPAuthState createState() => _OTPAuthState(credential);
}

//For reference:-
/*credential: 
  ['signUp',
  customID,
  emailFinal,
  bloodFinal,
  phone1Final,
  phone2Final]*/

class _OTPAuthState extends State<OTPAuth> {
  List<String> credential;
  _OTPAuthState(this.credential);

  //Firebase Auth
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReceived = '';
  bool otpCodeVisible = false;
  String phoneForOTP = '';

  //Firebase & Firestore
  final fsdb = FirebaseFirestore.instance;
  final rtdb = FirebaseDatabase.instance.reference();

  TextEditingController otpController = TextEditingController();

  String customID = '';

  @override
  void initState() {
    super.initState();
    customID = credential[1];
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.cyan,
      child: Scaffold(
        backgroundColor: Colors.cyan,
        body: otpPage(context),
      ),
    );
  }

  Column otpPage(BuildContext context) {
    phoneForOTP = '+82' + customID.split('_')[0].substring(1);
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
                  CustomUI().sizedHeightBox(40),
                  Text(
                    '휴대전화 인증',
                    style: TextStyle(color: Colors.white, fontSize: 70.sp),
                  ),
                  CustomUI().sizedHeightBox(10),
                  Text(
                    '재난명부 Ver1.0',
                    style: TextStyle(color: Colors.white, fontSize: 100.sp),
                  ),
                  CustomUI().sizedHeightBox(20),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: Padding(
                      padding: EdgeInsets.all(30.h),
                      child: Column(
                        children: [
                          CustomUI().sizedHeightBox(100),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.w),
                            padding: EdgeInsets.all(20.h),
                            child: Text('로그인을 하려면 아래의 전화번호로\n인증이 필요합니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50.sp)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.w),
                            padding: EdgeInsets.all(20.h),
                            child: Text(customID.split('_')[0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 80.sp)),
                          ),
                          Visibility(
                              visible: otpCodeVisible,
                              child: CupertinoTextField(
                                onChanged: (value) {
                                  if (value.length == 6) {
                                    verifyOTP();
                                  }
                                },
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    letterSpacing: 30, fontSize: 100.sp),
                                maxLength: 6,
                                controller: otpController,
                                keyboardType: TextInputType.number,
                              )),
                          Visibility(
                            visible: otpCodeVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("OTP를 받지 못하였나요?"),
                                CupertinoButton(
                                    child: Text("다시 전송"),
                                    onPressed: () {
                                      verifyNumber();
                                      CustomFunc().showToast('다시 전송하였습니다.');
                                    })
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !otpCodeVisible,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  otpCodeVisible = true;
                                });
                                verifyNumber();
                              },
                              child: Text('OTP 전송'),
                            ),
                          )
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

  verifyNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneForOTP,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print('1: logged in');
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('login failed : ${exception.message}');
        },
        codeSent: (String _verificationID, int? resendToken) {
          verificationIDReceived = _verificationID;
          print('code is sent');
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  verifyOTP() async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived, smsCode: otpController.text);
    try {
      UserCredential _result = await auth.signInWithCredential(_credential);
      print('successful login');
      if (credential[0] == 'logIn') {
        _logIn(customID);
      } else {
        _signUp(customID, credential[2], credential[3], credential[4],
            credential[5]);
      }
    } catch (e) {
      CustomFunc().showToast('인증번호가 불일치합니다. 다시 시도해주세요!!');
      otpController.clear();
    }
  }

  _logIn(String _customID) {
    CustomFunc().storeString('customID', _customID).then((value) {
      CustomFunc().startPage(context, Home(customID: customID));
    });
  }

  _signUp(String _customID, String _emailFinal, String _bloodFinal,
      String _phone1Final, String _phone2Final) {
    fsdb
        .collection('Users')
        .doc(customID)
        .set({
          'email': _emailFinal,
          'bloodType': _bloodFinal,
          'emergencyContact1': _phone1Final,
          'emergencyContact2': _phone2Final
        })
        .then((_) => {
              rtdb.child('Users/$customID').set({
                'family': {'empty': 1},
                'friend': {'empty': 1}
              }).then((_) => {
                    print('uploaded'),
                    CustomFunc()
                        .storeString('customID', _customID)
                        .then((value) {
                      CustomFunc().startPage(context, Home(customID: customID));
                    }).catchError((error) =>
                            {print('at OTP_rtdb : not uploaded'), print(error)})
                  })
            })
        .catchError(
            (error) => {print('at OTP_fsdb : not uploaded'), print(error)});
  }
}
