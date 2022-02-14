import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_ui.dart';
import 'package:emergency_list/Reference/data.dart';
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
        appBar: CustomUI().simpleAppBar('가족/지인 등록하기'),
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
          ? SizedBox()
          : Expanded(child: searchList(searchedList)),
    ]);
  }

  Widget searchList(List<SearchedData> _searchedListUpdated) =>
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: _searchedListUpdated.length,
          itemBuilder: (_, index) {
            return GestureDetector(
                onTap: () {
                  showSearchDialogFunc(
                      context,
                      _searchedListUpdated[index].name,
                      _searchedListUpdated[index].phone,
                      _searchedListUpdated[index].birth);
                },
                child: searchListCardUI(
                    _searchedListUpdated[index].name,
                    _searchedListUpdated[index].phone,
                    _searchedListUpdated[index].birth));
          });

  searchListCardUI(_name, _phone, _birth) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.height * 0.05),
          ),
        ),
        padding: EdgeInsets.only(
          left: 20.h,
          top: 20.h,
          bottom: 20.h,
        ),
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
          ],
        ),
      ),
    );
  }

  showSearchDialogFunc(context, _name, _phone, _birth) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.all(10.h),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 500.h,
                      child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CustomUI().sizedHeightBox(30),
                              Text(
                                '이름 : $_name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              CustomUI().sizedHeightBox(30),
                              Text(
                                '전화번호 : $_phone',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              CustomUI().sizedHeightBox(30),
                              Text(
                                '생일 : $_birth',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              CustomUI().sizedHeightBox(30),
                              Text(
                                '위 정보의 사람에게 신청하시겠습니까?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: Text('신청'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    alignment: Alignment.center,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )
                            ]),
                      ))));
        });
  }
}
