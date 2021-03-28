import 'package:flutter/material.dart';
import 'package:news_reader_app/features/discovery/presentation/pages/discovery_page.dart';
import 'package:news_reader_app/features/home/presentation/pages/home_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int index = 0;

  void onItemTapped(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[HomePage(), DiscoveryPage()];

    return SafeArea(
        child: Scaffold(
      body: Center(
        child: pages.elementAt(index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home_inactive.png'),
            activeIcon: Image.asset('assets/images/home_active.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/search_inactive.png'),
            activeIcon: Image.asset('assets/images/search_active.png'),
            label: 'Discovery',
          ),
        ],
        currentIndex: index,
        onTap: onItemTapped,
      ),
    ));
  }
}
