import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emergency_list/Reference/custom_func.dart';
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
                  showSearchDialogLVL1(
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

  showSearchDialogLVL1(context, _name, _phone, _birth) {
    final _width = MediaQuery.of(context).size.width * 0.7;
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
                    width: _width,
                    height: 500.h,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: FittedBox(
                              child: Text(
                                '이름 : $_name',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: FittedBox(
                              child: Text(
                                '전화번호 : $_phone',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: FittedBox(
                              child: Text(
                                '생일 : $_birth',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                            flex: 6,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: _width / 2 - 10.h,
                                  padding: EdgeInsets.all(10.h),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showSearchDialogLVL2(
                                          context, _name, _phone, _birth, 1);
                                    },
                                    child: FittedBox(child: Text('가족으로 등록')),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        alignment: Alignment.center,
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Container(
                                  width: _width / 2 - 10.h,
                                  padding: EdgeInsets.all(10.h),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showSearchDialogLVL2(
                                          context, _name, _phone, _birth, 2);
                                    },
                                    child: FittedBox(child: Text('지인으로 등록')),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        alignment: Alignment.center,
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                  )));
        });
  }

  showSearchDialogLVL2(context, _name, _phone, _birth, int _requestType) {
    final _width = MediaQuery.of(context).size.width * 0.7;
    String _selectedRelation = '아버지';

    Container relationSelectText() {
      return Container(
        width: _width - 20.h,
        padding: EdgeInsets.all(10.h),
        child: const FittedBox(
          child: Text(
            '관계를 선택하세요.',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    Container relationSelect(_setState) {
      Widget _relationRadio(String _relation) {
        return Container(
          padding: EdgeInsets.only(left: 10.h, right: 10.h),
          child: ElevatedButton(
            onPressed: (() {
              _setState(() {
                _selectedRelation = _relation;
              });
            }),
            child: FittedBox(child: Text(_relation)),
            style: ElevatedButton.styleFrom(
                primary:
                    _selectedRelation == _relation ? Colors.blue : Colors.grey,
                alignment: Alignment.center,
                textStyle: TextStyle(
                  color: Colors.black,
                )),
          ),
        );
      }

      return Container(
        width: _width - 20.h,
        alignment: Alignment.center,
        child: Row(children: <Widget>[
          _relationRadio('아버지'),
          _relationRadio('어머니'),
          _relationRadio('형제자매'),
        ]),
      );
    }

    Container requestCancelBTNLVL2(_context) {
      return Container(
        width: _width / 2 - 10.h,
        padding: EdgeInsets.all(10.h),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(_context).pop();
          },
          child: FittedBox(child: Text('취소')),
          style: ElevatedButton.styleFrom(
              primary: Colors.black,
              alignment: Alignment.center,
              textStyle: TextStyle(
                color: Colors.white,
              )),
        ),
      );
    }

    Container familyRequestBTNLVL2(_context) {
      return Container(
        width: _width / 2 - 10.h,
        padding: EdgeInsets.all(10.h),
        child: ElevatedButton(
          onPressed: () async {
            await rtdb
                .child('Request')
                .child('${_phone}_${_name}_$_birth')
                .set({customID: _selectedRelation}).then((_) {
              CustomFunc().showToast('등록 신청을 하였습니다. 상대방도 수락시 가족으로 등록됩니다.');
              Navigator.of(_context).pop();
            }).catchError((e) {
              CustomFunc().showToast('잠시후 다시 시도해주세요.');
            });
          },
          child: const Text('등록'),
          style: ElevatedButton.styleFrom(
              primary: Colors.black,
              alignment: Alignment.center,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
    }

    Container friendRequestBTNLVL2(_context) {
      return Container(
        width: _width / 2 - 10.h,
        padding: EdgeInsets.all(10.h),
        child: ElevatedButton(
          onPressed: () async {
            await rtdb
                .child('Request')
                .child('${_phone}_${_name}_$_birth')
                .set({customID: 'friend'}).then((_) {
              CustomFunc().showToast('등록 신청을 하였습니다. 상대방도 수락시 지인으로 등록됩니다.');
              Navigator.of(_context).pop();
            }).catchError((e) {
              CustomFunc().showToast('잠시후 다시 시도해주세요.');
            });
          },
          child: const Text('등록'),
          style: ElevatedButton.styleFrom(
              primary: Colors.black,
              alignment: Alignment.center,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
    }

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Center(
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.all(10.h),
                        width: _width,
                        height: _requestType == 1 ? 500.h : 130.h,
                        child: _requestType == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Expanded(flex: 2, child: SizedBox()),
                                    Expanded(
                                        flex: 4, child: relationSelectText()),
                                    Expanded(flex: 2, child: SizedBox()),
                                    Expanded(
                                      flex: 6,
                                      child: relationSelect(setState),
                                    ),
                                    Expanded(flex: 3, child: SizedBox()),
                                    Expanded(
                                      flex: 6,
                                      child: Row(
                                        children: <Widget>[
                                          requestCancelBTNLVL2(context),
                                          familyRequestBTNLVL2(context)
                                        ],
                                      ),
                                    )
                                  ])
                            : Row(
                                children: <Widget>[
                                  requestCancelBTNLVL2(context),
                                  friendRequestBTNLVL2(context)
                                ],
                              ),
                      ))),
            ));
  }
}
