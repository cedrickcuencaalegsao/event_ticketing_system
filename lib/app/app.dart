import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <-- Import the scanner package
import 'package:qr_flutter/qr_flutter.dart';       // <-- Import the QR display package

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
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const ExplorePage(),
    const TicketsPage(),
    const ProfilePage(),
  ];

  final MobileScannerController cameraController = MobileScannerController();
  bool _isScanCompleted = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void selectedPage(int index) {
    if (index == 2) return;
    setState(() {
      selectedPageIndex = (index > 2) ? index - 1 : index;
    });
  }

  void _showScanResult(String code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ticket ID:',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                code,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 30),
              QrImageView(
                data: code,
                version: QrVersions.auto,
                size: 180.0,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openQRScanner() {
    _isScanCompleted = false;

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
                      const Text('Scan QR Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      if (!_isScanCompleted) {
                        setState(() {
                          _isScanCompleted = true;
                        });
                        final String code = capture.barcodes.first.rawValue ?? '---';
                        Navigator.pop(context);
                        _showScanResult(code);
                      }
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(top: 0, left: 0, child: _buildCorner(true, true)),
                            Positioned(top: 0, right: 0, child: _buildCorner(true, false)),
                            Positioned(bottom: 0, left: 0, child: _buildCorner(false, true)),
                            Positioned(bottom: 0, right: 0, child: _buildCorner(false, false)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Align the QR code within the frame',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- START OF FIX ---
                        ValueListenableBuilder(
                          // 1. Listen to the controller directly
                          valueListenable: cameraController,
                          builder: (context, state, child) {
                            return GestureDetector(
                              onTap: () => cameraController.toggleTorch(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  // 2. Check the 'torchEnabled' boolean property
                                  cameraController.torchEnabled ? Icons.flash_on : Icons.flash_off,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            );
                          },
                        ),
                        // --- END OF FIX ---
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.image, color: Colors.white, size: 28),
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

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Colors.deepPurple, width: 4) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.deepPurple, width: 4) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.deepPurple, width: 4) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.deepPurple, width: 4) : BorderSide.none,
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
            currentIndex: selectedPageIndex >= 2 ? selectedPageIndex + 1 : selectedPageIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            onTap: selectedPage,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
              BottomNavigationBarItem(icon: SizedBox(width: 24), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Tickets'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
                      color: const Color.fromRGBO(103, 58, 183, 0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}