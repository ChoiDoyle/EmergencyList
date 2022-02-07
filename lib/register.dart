import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  String customID;
  Register({Key? key, required this.customID}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState(customID);
}

class _RegisterState extends State<Register> {
  String customID;
  _RegisterState(this.customID);

  //Firebase & Firestore
  final fsdb = FirebaseFirestore.instance;
  final rtdb = FirebaseDatabase.instance.reference();

  TextEditingController searchInputController = TextEditingController();

  //late Future<List<String>> searchedList;
  List<SearchedData> searchedList = [];

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '가족/지인 등록하기',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
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
          ],
        ),
        body: buildSearchPage(),
      ),
    );
  }

  Widget buildSearchPage() {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(20.h),
        height: 150.h,
        width: double.infinity,
        child: Row(children: <Widget>[
          Expanded(
            flex: 9,
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.h),
                          bottomLeft: Radius.circular(100.h)),
                      borderSide: BorderSide.none),
                  hintStyle:
                      TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  hintText: "검색"),
              controller: searchInputController,
              keyboardType: TextInputType.text,
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                List<SearchedData> _searchedListUpdated = [];
                await fsdb
                    .collection('Users')
                    .where('name', isEqualTo: searchInputController.text)
                    .get()
                    .then((_snapshot) {
                  _snapshot.docs.forEach((element) {
                    final _searchedDataSingle =
                        Map<String, dynamic>.from(element.data());
                    SearchedData _data = SearchedData(
                        _searchedDataSingle['name'],
                        _searchedDataSingle['phone'],
                        _searchedDataSingle['birth']);
                    _searchedListUpdated.add(_data);
                  });
                  setState(() {
                    if (_searchedListUpdated.isEmpty) {
                      searchedList = [];
                    } else {
                      searchedList = _searchedListUpdated;
                    }
                  });
                });
              },
              child: Container(
                height: 150.h,
                decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100.h),
                        bottomRight: Radius.circular(100.h))),
                child: Icon(
                  Icons.arrow_forward,
                ),
              ),
            ),
          )
        ]),
      ),
      searchedList.isEmpty
          ? Container(
              child: Text('empty'),
            )
          : Expanded(child: searchList(searchedList)),
    ]);
  }

  /*Widget searchListBuilder() {
    setState(() {
      searchedList = fetchSearchedData();
    });
    return FutureBuilder<List<SearchedData>>(
      future: searchedList,
      builder: (context, searchedSnap) {
        switch (searchedSnap.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomUI().customLoading());
          default:
            if (searchedSnap.hasError) {
              return Text('에러발생');
            } else {
              return searchedSnap.data!.isEmpty
                  ? Text('존재하는 아이디가 없습니다.')
                  : searchList(searchedSnap.data!);
            }
        }
      },
    );
  }

  Future<List<String>> fetchSearchedData() async {
    List<String> _searchedListUpdated = [];
    await fsdb.collection('Users').doc().get().then((_snapshot) {
      print(_snapshot.reference.doc)
    });
    await rtdb.child('Users/$customID/friend').get().then((snapshot) {
      final _friendDataMap = Map<String, dynamic>.from(snapshot.value);
      if (_friendDataMap.containsKey('empty')) {
      } else {
        _friendDataMap.forEach((key, value) {
          final _listCustomID = key.toString().split('_');
          final _relation = value['relation'].toString();
          final _level = value['level'];
          FriendData _data = FriendData(_listCustomID[1], _listCustomID[0],
              _listCustomID[2], _relation, _level);
          _friendListUpdated.add(_data);
        });
      }
    });
    return _searchedListUpdated;
  } */

  Widget searchList(List<SearchedData> _searchedListUpdated) =>
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: _searchedListUpdated.length,
          itemBuilder: (_, index) {
            return GestureDetector(
                onTap: () {
                  print('tapped');
                  /*showPaymentDialogFunc(
                  context,
                  '${paymentListUpdated[index].phone}_${paymentListUpdated[index].table}',
                  paymentListUpdated[index].menu);*/
                },
                child: searchListCardUI(
                    _searchedListUpdated[index].name,
                    _searchedListUpdated[index].phone,
                    _searchedListUpdated[index].birth));
          });

  searchListCardUI(_name, _phone, _birth) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                )),
            SizedBox(width: 10.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 5,
              ),
              Text('이름 : $_name', style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              Text('전화번호 : $_phone', style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              Text('생년월일 : $_birth', style: TextStyle(color: Colors.black)),
            ])
          ]),
          /*GestureDetector(
            onTap: () {},
          )*/
        ],
      ),
    );
  }
}
