import 'package:emergency_list/Reference/custom_func.dart';
import 'package:emergency_list/home.dart';
import 'package:emergency_list/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      moveToHome(context, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future moveToHome(BuildContext context, _user) async {
    if (_user == null) {
      CustomFunc().startPage(context, SignIn());
    } else {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (!sharedPreferences.containsKey('customID')) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => SignIn()));
      } else {
        String _customID = sharedPreferences.getString('customID').toString();
        print(_customID);
        CustomFunc().startPage(context, Home(customID: _customID));
      }
    }
  }
}
