import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//2초 딜레이 주고 싶을 때
//await Future.delayed(Duration(seconds: 2));

class CustomFunc {
  Future giveDelay(int _duration) async {
    await Future.delayed(Duration(milliseconds: _duration));
  }

  Future storeString(String id, String content) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(id, content);
  }

  //return하면 안되고 이 함수안에 모든걸 해야댐...
  Future streamString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String a = sharedPreferences.getString(id).toString();
    print(a);
    return a;
  }

  //removeString은 다른 type의 variable도 remove 가능
  Future removeString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(id);
  }

  Future<bool> checkIfDocExists(String docID) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(docID).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}
