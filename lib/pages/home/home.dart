import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:culinfo/color/AppColor.dart';
import 'package:culinfo/pages/create/create_news.dart';
import 'package:culinfo/pages/dashboard/dashboard.dart';
import 'package:culinfo/pages/profile/favorite.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0; // index halaman

  List<Widget> screens = [
    // Memasukkan Halaman kedalam Array
    DashboardPage(), // Halaman Dashboard
    FavoritePage(), // Halaman Favorite
  ];

  List<IconData> icons = [Icons.home, Icons.favorite]; // Menampilkan Icon

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index],
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: CreateNewsPage(
                        onDetailsPagePopped: () {
                          setState(() {});
                          (screens[index] as DashboardPageState).fetchNews();
                        },
                      ),
                      type: PageTransitionType
                          .rightToLeft)); // Navigasi untuk menambahkan berita
            },
            child: Icon(
              Icons.add,
              color: AppColor.textBlack,
            ),
            backgroundColor: AppColor.secondary),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          activeColor: AppColor.text,
          inactiveColor: AppColor.textBlack,
          backgroundColor: AppColor.primary,
          icons: icons,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          activeIndex: index,
          onTap: (i) =>
              setState(() => index = i), // Navigasi ke setiap halaman yang ada
        ),
      ),
    );
  }
}
