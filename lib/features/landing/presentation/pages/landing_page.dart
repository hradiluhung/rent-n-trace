import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/presentation/pages/car_list_page.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/display_all_cars_cubit.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/navbar_cubit.dart';
import 'package:rent_n_trace/features/landing/presentation/bloc/navbar_state.dart';
import 'package:rent_n_trace/features/landing/presentation/pages/home_page.dart';
import 'package:rent_n_trace/features/profile/presentation/pages/profile_page.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_history_page.dart';

const List<TabItem> items = [
  TabItem(icon: LucideIcons.home, title: 'Beranda'),
  TabItem(icon: LucideIcons.car, title: "Mobil"),
  TabItem(icon: LucideIcons.history, title: "Peminjaman"),
  TabItem(icon: LucideIcons.user2, title: 'Profil'),
];

const List<Widget> bottomNavScreen = <Widget>[
  HomePage(),
  CarListPage(),
  RentHistoryPage(),
  ProfilePage(),
];

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: BlocBuilder<NavbarCubit, NavbarState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => DisplayAllCarsCubit()..displayCars(),
            child: Scaffold(
              body: IndexedStack(index: state.currentIndex, children: const [...bottomNavScreen]),
              bottomNavigationBar: BottomBarDivider(
                items: items,
                backgroundColor: Colors.white,
                color: AppColors.foreground.withOpacity(0.6),
                colorSelected: AppColors.primary,
                indexSelected: state.currentIndex,
                onTap: (int index) {
                  context.read<NavbarCubit>().changeIndex(index);
                },
                styleDivider: StyleDivider.bottom,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
