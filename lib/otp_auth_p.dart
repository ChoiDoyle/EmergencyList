import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPAuth extends StatefulWidget {
  String phoneFinal = '';
  OTPAuth({Key? key, required this.phoneFinal}) : super(key: key);

  @override
  _OTPAuthState createState() => _OTPAuthState(phoneFinal);
}

class _OTPAuthState extends State<OTPAuth> {
  String phoneFinal = '';
  _OTPAuthState(this.phoneFinal);

  //Firebase Auth
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReceived = '';
  bool otpCodeVisible = false;
  String phoneForOTP = '';

  TextEditingController otpController = TextEditingController();

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
    phoneForOTP = '+82' + phoneFinal.substring(1);
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
                    '휴대전화 인증',
                    style: TextStyle(color: Colors.white, fontSize: 70.sp),
                  ),
                  CustomUI().sizedBox(10),
                  Text(
                    '재난명부 Ver1.0',
                    style: TextStyle(color: Colors.white, fontSize: 100.sp),
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.w),
                            padding: EdgeInsets.all(20.h),
                            child: Text('로그인을 하려면 아래의 전화번호로 인증이 필요합니다.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 100.sp)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.w),
                            padding: EdgeInsets.all(20.h),
                            child: Text('전화번호 : $phoneForOTP',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50.sp)),
                          ),
                          Visibility(
                            visible: otpCodeVisible,
                            child: Container(
                                padding: EdgeInsets.all(20.h),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  controller: otpController,
                                  decoration: InputDecoration(
                                      hintText: 'otp 입력',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade300),
                                      border: InputBorder.none),
                                )),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (otpCodeVisible) {
                                  verifyOTP();
                                } else {
                                  verifyNumber();
                                }
                              },
                              child: Text(otpCodeVisible ? '로그인' : 'otp전송')),
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
        verificationCompleted: (PhoneAuthCredential credential) {
          print('1: logged in');
          /*await auth.signInWithCredential(credential).then((value) {
            print('You are logged in successfully');
          });*/
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('login failed : ${exception.message}');
        },
        codeSent: (String _verificationID, int? resendToken) {
          verificationIDReceived = _verificationID;
          setState(() {
            otpCodeVisible = true;
          });
          print('code is sent');
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  verifyOTP() async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived, smsCode: otpController.text);
    await auth.signInWithCredential(_credential).then((value) {
      print('successful login');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Home()));
    });
  }
}
