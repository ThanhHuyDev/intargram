import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intargram/untils/colors.dart';
import '../untils/dimens.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeItems[_page],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: mobileBackgroundColor,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: onPageChanged,
          currentIndex: _page,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/ic_homeshop.svg',color: Colors.grey,height: 20,),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/ic_search.svg'),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/ic_add.svg'),
              label: 'Thêm bài đăng',
            ),
            BottomNavigationBarItem(
              icon:SvgPicture.asset('assets/icons/ic_heart_outlined.svg',height: 20,),
              label: 'Đã lưu',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/ic_user.svg',height: 20,),
              label: 'Trang cá nhân',
            ),
          ]),
    );
  }
}