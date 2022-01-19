import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Authentication/auth.dart';
import 'package:emergency_list/Authentication/wrapper.dart';
import 'package:emergency_list/Reference/custom_func.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Firebase Authentication
  final AuthService _auth = AuthService();

  int navigationIndex = 0;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _key,
        drawer: Drawer(),
        appBar: AppBar(
          title: const Text(
            'HomePage',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _key.currentState?.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            //buildTopLabel(height, width),
            SizedBox(
              height: width * 0.01,
            ),
            signOutBTN(),
          ],
        ),
        bottomNavigationBar: buildNavigationBar(),
      ),
    );
  }

  ElevatedButton signOutBTN() {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut().then((_) => {
              CustomFunc().removeString('customID'),
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Wrapper()))
            });
      },
      child: const Text('로그아웃'),
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

  /*Container buildTopLabel(double height, double width) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(height * 0.1),
          ),
          color: Colors.cyan),
      child: Stack(
        children: [
          Positioned(
              top: 30.h,
              left: 0,
              child: Container(
                height: 200.h,
                width: width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height * 0.03),
                      bottomRight: Radius.circular(height * 0.03),
                    )),
              )),
          Positioned(
              top: 100.h,
              left: width * 0.1,
              child: Text('재난명부',
                  style: TextStyle(
                      fontSize: 80.sp,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }*/

  /*StreamBuilder<Event> buildListView() {
    return navigationIndex == 0 ? friendStream() : myStream();
  }*/

  BottomNavigationBar buildNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: navigationIndex,
      onTap: (index) => setState(() => navigationIndex = index),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '내 지인',
            backgroundColor: Colors.cyan),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '내 정보',
            backgroundColor: Colors.cyan),
      ],
    );
  }

  /*StreamBuilder<Event> friendStream() {
    return StreamBuilder(
        );
  }

  StreamBuilder<Event> myStream() {
    return StreamBuilder(
        );
  }*/
}
