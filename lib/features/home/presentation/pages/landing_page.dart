import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/presentation/pages/cars_page.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/bottom_bar_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/bottom_bar_state.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_all_cars_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/pages/home_page.dart';
import 'package:rent_n_trace/features/profile/presentation/pages/profile_page.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_histories_page.dart';

const List<TabItem> items = [
  TabItem(icon: LucideIcons.home, title: 'Beranda'),
  TabItem(icon: LucideIcons.car, title: "Mobil"),
  TabItem(icon: LucideIcons.history, title: "Peminjaman"),
  TabItem(icon: LucideIcons.user2, title: 'Profil'),
];

const List<Widget> bottomNavScreen = <Widget>[
  HomePage(),
  CarsPage(),
  RentHistoriesPage(),
  ProfilePage(),
];

class LandingPage extends StatelessWidget {
  final int? defaultIndex;
  const LandingPage({super.key, this.defaultIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomBarCubit()
        ..changeIndex(
          defaultIndex ?? 0,
        ),
      child: BlocBuilder<BottomBarCubit, BottomBarState>(
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
                  context.read<BottomBarCubit>().changeIndex(index);
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
