import 'package:flutter/material.dart';
// Pages.
import 'package:event_ticketing_system/pages/homepage.dart';
import 'package:event_ticketing_system/pages/explorepage.dart';
import 'package:event_ticketing_system/pages/ticketpage.dart';
import 'package:event_ticketing_system/pages/profilepage.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  // selectedPageIndex now correctly refers to the index in the `pages` list.
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const ExplorePage(),
    const TicketsPage(),
    const ProfilePage(),
  ];
  final List<String> pageTitle = ["Home", "Explore", "Tickets", "Profile"];

  Icon pageIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.search);
      case 2:
        return const Icon(Icons.confirmation_number);
      case 3:
        return const Icon(Icons.person);
      default:
        return const Icon(Icons.pages);
    }
  }

  // MODIFIED: This function now correctly handles the placeholder at index 2.
  void selectedPage(int index) {
    // If the middle placeholder (index 2) is tapped, do nothing.
    if (index == 2) {
      return;
    }

    setState(() {
      // If an index greater than the placeholder is tapped,
      // we subtract 1 to get the correct index for the `pages` list.
      if (index > 2) {
        selectedPageIndex = index - 1;
      } else {
        selectedPageIndex = index;
      }
    });
  }

  void openQRScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                // Corner decorations
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                        left: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                        right: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                        left: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                        right: BorderSide(
                                            color: Colors.deepPurple, width: 4),
                                      ),
                                    ),
                                  ),
                                ),
                                // Scanning line animation placeholder
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        size: 80,
                                        // REPLACED: .withOpacity() with Color.fromRGBO()
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Position QR code here',
                                        style: TextStyle(
                                          // REPLACED: .withOpacity() with Color.fromRGBO()
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Align the QR code within the frame',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // REPLACED: .withOpacity() with Color.fromRGBO()
                            color: const Color.fromRGBO(255, 255, 255, 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 40),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // REPLACED: .withOpacity() with Color.fromRGBO()
                            color: const Color.fromRGBO(255, 255, 255, 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPageIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // MODIFIED: The currentIndex is now calculated to account for the placeholder.
            // If the selected page index is 2 or 3 (Tickets, Profile), we add 1
            // to get the correct BottomNavigationBarItem index (3, 4).
            currentIndex:
                selectedPageIndex >= 2 ? selectedPageIndex + 1 : selectedPageIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            onTap: selectedPage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Explore',
              ),
              // This is the placeholder for the floating action button.
              BottomNavigationBarItem(
                icon: SizedBox(width: 24),
                label: '',
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
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 32,
            child: GestureDetector(
              onTap: openQRScanner,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Color(0xFF7C4DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // REPLACED: .withOpacity() with Color.fromRGBO()
                      // Colors.deepPurple is RGB(103, 58, 183)
                      color: const Color.fromRGBO(103, 58, 183, 0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}