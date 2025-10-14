import 'package:flutter/material.dart';
// Pages.
import 'package:event_ticketing_system/pages/homepage.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    HomePage(), const Center(child: Text("Profile Page")), 
  ];
  final List<String> pageTitle = ["Home", "profile"];
  Icon pageIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.person);
      default:
        return const Icon(Icons.pages);
    }
  }

  void seletedPage(int index){
    setState(() {
      selectedPageIndex = index;
    });
    Navigator.canPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPageIndex],
      bottomNavigationBar: _buildBottomNav(),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: selectedPageIndex,
      //   onTap: seletedPage,
      //   items: [
      //     for (int i = 0; i < pageTitle.length; i++)
      //       BottomNavigationBarItem(icon: pageIcon(i), label: pageTitle[i]),
      //   ],
      // ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 50),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
