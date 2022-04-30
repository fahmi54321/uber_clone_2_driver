import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/tabs/earningstab.dart';
import 'package:uber_clone_2_driver/tabs/hometab.dart';
import 'package:uber_clone_2_driver/tabs/profiletab.dart';
import 'package:uber_clone_2_driver/tabs/ratingstab.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Ratings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorOrange,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
        currentIndex: selectedIndex,
      ),
    );
  }
}
