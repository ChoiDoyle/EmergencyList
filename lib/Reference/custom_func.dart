import 'package:shared_preferences/shared_preferences.dart';

class CustomFunc {
  Future storeString(String id, String content) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(id, content);
  }

  //return하면 안되고 이 함수안에 모든걸 해야댐...
  Future streamString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? a = sharedPreferences.getString(id);
    print('2');
    print(a);
    return a;
  }

  //removeString은 다른 type의 variable도 remove 가능
  Future removeString(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(id);
  }
}
