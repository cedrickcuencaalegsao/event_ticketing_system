import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:event_ticketing_system/service/apiservice.dart';
import 'package:event_ticketing_system/models/usermodel.dart';
import 'package:event_ticketing_system/models/eventmodel.dart';
import 'package:event_ticketing_system/models/ticketmode.dart';

class FullTicketDetails {
  final Ticket ticket;
  final Event event;

  FullTicketDetails({required this.ticket, required this.event});
}

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => TicketsPageState();
}

class TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService apiService = ApiService();

  // Future to hold the combined result of our API calls
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Use Future.wait to fetch user (for their tickets) and all events simultaneously
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    // Fetch both the user and the list of all events
    final user = await apiService.fetchUser(1); // Hardcoding user ID 1
    final events = await apiService.fetchEvents();
    return {'user': user, 'events': events};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              // Use FutureBuilder to handle loading/error states for our API data
              child: FutureBuilder<Map<String, dynamic>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text("No data found."));
                  }

                  // --- Data Processing ---
                  final User user = snapshot.data!['user'];
                  final List<Event> allEvents = snapshot.data!['events'];

                  // Create a map for quick event lookup by ID
                  final eventsMap = {for (var e in allEvents) e.id: e};

                  final List<FullTicketDetails> allFullTickets = [];
                  for (var ticket in user.tickets) {
                    if (eventsMap.containsKey(ticket.eventId)) {
                      allFullTickets.add(FullTicketDetails(
                        ticket: ticket,
                        event: eventsMap[ticket.eventId]!,
                      ));
                    }
                  }

                  // Filter tickets into upcoming and past lists
                  final now = DateTime.now();
                  final upcomingTickets = allFullTickets.where((ft) {
                    try {
                      return DateTime.parse(ft.event.date).isAfter(now);
                    } catch (e) {
                      return false;
                    }
                  }).toList();

                  final pastTickets = allFullTickets.where((ft) {
                    try {
                      return DateTime.parse(ft.event.date).isBefore(now);
                    } catch (e) {
                      return false;
                    }
                  }).toList();
                  // --- End of Data Processing ---

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUpcomingTab(upcomingTickets),
                      _buildPastTab(pastTickets),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Widgets (Now accept API data) ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Text(
            'My Tickets',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past Events'),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab(List<FullTicketDetails> tickets) {
    if (tickets.isEmpty) {
      return const Center(child: Text("No upcoming tickets."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index]);
      },
    );
  }

  Widget _buildTicketCard(FullTicketDetails fullTicket) {
    final ticket = fullTicket.ticket;
    final event = fullTicket.event;
    final cardColor = _getColorForCategory(event.categoryId);

    return GestureDetector(
      onTap: () => _showTicketDetails(fullTicket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // MODIFIED: Replaced withOpacity
                    color: const Color.fromRGBO(158, 158, 158, 0.15),
                    spreadRadius: 2,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cardColor.withAlpha(200), // Lighter shade
                          cardColor, // Base color
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                // MODIFIED: Replaced withOpacity
                                color: const Color.fromRGBO(255, 255, 255, 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getIconForCategory(event.categoryId),
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.location,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      // MODIFIED: Replaced withOpacity
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ticket.status == 'confirmed'
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                ticket.status == 'confirmed'
                                    ? 'Confirmed'
                                    : 'Pending',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildInfoColumn(
                              Icons.calendar_today,
                              'Date',
                              event.date,
                            ),
                            const SizedBox(width: 24),
                            _buildInfoColumn(
                              Icons.access_time,
                              'Time',
                              "N/A", // API data doesn't have time
                            ),
                            const SizedBox(width: 24),
                            _buildInfoColumn(
                              Icons.confirmation_number,
                              'Tickets',
                              '1x', // API data doesn't have quantity
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: DashedLinePainter(),
                    size: const Size(double.infinity, 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ticket Number',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ticket.ticketNumber,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Seats',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ticket.seats,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // MODIFIED: Replaced placeholder with real QR Code
                        SizedBox(
                          width: 84,
                          height: 84,
                          child: QrImageView(
                            data: ticket.ticketNumber, // QR code data
                            version: QrVersions.auto,
                            size: 84.0,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // These are the decorative circles on the side of the ticket
            Positioned(
              left: -10,
              top: 170, // Adjust this value based on your card height
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: 170, // Adjust this value based on your card height
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color.fromRGBO(255, 255, 255, 0.9)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPastTab(List<FullTicketDetails> tickets) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined,
                size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Past Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your attended events will appear here',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final fullTicket = tickets[index];
        final event = fullTicket.event;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(158, 158, 158, 0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _getIconForCategory(event.categoryId),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Rating button can be added here if needed
            ],
          ),
        );
      },
    );
  }

  void _showTicketDetails(FullTicketDetails fullTicket) {
    final ticket = fullTicket.ticket;
    final event = fullTicket.event;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      // MODIFIED: Display a larger QR Code here
                      child: QrImageView(
                        data: ticket.ticketNumber,
                        version: QrVersions.auto,
                        size: 220.0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(Icons.calendar_today, 'Date', event.date),
                    _buildDetailRow(
                        Icons.access_time, 'Time', "N/A"), // No time in API
                    _buildDetailRow(
                        Icons.location_on, 'Location', event.location),
                    _buildDetailRow(Icons.event_seat, 'Seats', ticket.seats),
                    _buildDetailRow(
                        Icons.confirmation_number, 'Ticket ID', ticket.ticketNumber),
                    const SizedBox(height: 24),
                    // Action buttons... (unchanged)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // MODIFIED: Replaced withOpacity
              color: const Color.fromRGBO(103, 58, 183, 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions to provide dynamic icons and colors based on category
  String _getIconForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return '🎵'; // Music
      case 2:
        return '⚽'; // Sports
      case 3:
        return '🎨'; // Arts
      case 4:
        return '🍔'; // Food
      default:
        return '🎟️';
    }
  }

  Color _getColorForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return Colors.purple;
      case 2:
        return Colors.green;
      case 3:
        return Colors.pink;
      case 4:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}