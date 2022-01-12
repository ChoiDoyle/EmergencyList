import 'package:emergency_list/home.dart';
import 'package:emergency_list/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    //return either home or authenticate widget
    if (user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}
