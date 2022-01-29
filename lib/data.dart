class FamilyData {
  String name, phone, birth, relation;

  FamilyData(this.name, this.phone, this.birth, this.relation);
}

class FriendData {
  String phone, table, timestamp, dbKey;
  Map menu;

  FriendData(this.menu, this.phone, this.table, this.timestamp, this.dbKey);
}

class MyData {
  String name, phone, birth, bloodType, email, emerCon1, emerCon2;

  MyData(this.name, this.phone, this.birth, this.bloodType, this.email,
      this.emerCon1, this.emerCon2);
}
