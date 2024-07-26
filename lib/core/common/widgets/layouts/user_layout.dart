import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';
import 'package:rent_n_trace/features/profile/presentation/pages/profile_page.dart';

class UserLayout extends StatefulWidget {
  static route({int? defaultIndex}) => MaterialPageRoute(
      builder: (context) => UserLayout(defaultIndex: defaultIndex));

  final int? defaultIndex;
  const UserLayout({super.key, this.defaultIndex});

  @override
  State<UserLayout> createState() => _UserLayoutState();
}

const List<TabItem> items = [
  TabItem(
    icon: EvaIcons.homeOutline,
    title: 'Beranda',
  ),
  TabItem(
    icon: EvaIcons.personOutline,
    title: 'Profil',
  ),
];

class _UserLayoutState extends State<UserLayout> {
  int _selectedIndex = 0;
  final Color _colorSelect = AppPalette.darkHeadlineTextColor;
  final Color _color = AppPalette.bodyTextColor.withOpacity(0.5);
  final Color _shadowColor = AppPalette.greyColor.withOpacity(0.3);
  final Color _bgColor = AppPalette.whiteColor;

  @override
  void initState() {
    super.initState();

    if (widget.defaultIndex != null) {
      _selectedIndex = widget.defaultIndex!;
    }
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 48.h),
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBarInspiredFancy(
              items: items,
              backgroundColor: _bgColor,
              bottom: 0.h,
              top: 16.h,
              enableShadow: true,
              boxShadow: [
                BoxShadow(
                  color: _shadowColor,
                  blurRadius: 15,
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
              color: _color,
              colorSelected: _colorSelect,
              indexSelected: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
