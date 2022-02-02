import 'package:flutter/material.dart';

class HomeMenuItem {
  final String text;
  final IconData icon;

  const HomeMenuItem({
    required this.text,
    required this.icon,
  });
}

class HomeMenuItems {
  static const List<HomeMenuItem> itemsFirst = [
    itemRegister,
    itemMyInfo,
  ];
  static const List<HomeMenuItem> itemsSecond = [
    itemSignOut,
  ];

  static const itemRegister = HomeMenuItem(text: '지인 등록', icon: Icons.add);
  static const itemMyInfo =
      HomeMenuItem(text: '내 정보', icon: Icons.person_pin_circle_outlined);
  static const itemSignOut = HomeMenuItem(text: '로그아웃', icon: Icons.logout);
}
