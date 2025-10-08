import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ticketing',
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    const Center(child: Text("Home Page")), const Center(child: Text("Profile Page")), 
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedPageIndex,
        onTap: seletedPage,
        items: [
          for (int i = 0; i < pageTitle.length; i++)
            BottomNavigationBarItem(icon: pageIcon(i), label: pageTitle[i]),
        ],
      ),
    );
  }
}
