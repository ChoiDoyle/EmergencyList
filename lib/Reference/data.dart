//@Home
class FamilyData {
  String name, phone, birth, relation;
  FamilyData(this.name, this.phone, this.birth, this.relation);
}

//@Home
class FriendData {
  String name, phone, birth, relation;
  int level;
  FriendData(this.name, this.phone, this.birth, this.relation, this.level);
}

//@MyInfo
class MyData {
  String name, phone, birth, bloodType, email, emerCon1, emerCon2;
  MyData(this.name, this.phone, this.birth, this.bloodType, this.email,
      this.emerCon1, this.emerCon2);
}

//@Register
class SearchedData {
  String name, phone, birth;
  SearchedData(this.name, this.phone, this.birth);
}

//@Detail
class DetailsData {
  String bloodType, email;
  DetailsData(this.bloodType, this.email);
}
