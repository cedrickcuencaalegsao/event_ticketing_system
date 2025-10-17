import 'package:flutter/material.dart';

// Adjust the import paths to match your project structure
import 'package:event_ticketing_system/service/apiservice.dart';
import 'package:event_ticketing_system/models/eventmodel.dart';
import 'package:event_ticketing_system/models/categorymodel.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => ExplorePageState();
}

// MODIFIED: Removed 'with SingleTickerProviderStateMixin' as it's no longer needed
class ExplorePageState extends State<ExplorePage> {
  final ApiService apiService = ApiService();

  // A single Future to hold the result of both API calls
  late Future<Map<String, dynamic>> _dataFuture;
  String selectedCategoryName = 'All';

  @override
  void initState() {
    super.initState();
    // MODIFIED: No longer need to initialize a TabController
    _dataFuture = _loadData();
  }

  // Fetches both events and categories from the API
  Future<Map<String, dynamic>> _loadData() async {
    final events = await apiService.fetchEvents();
    final categories = await apiService.fetchCategories();
    return {'events': events, 'categories': categories};
  }

  // MODIFIED: dispose method is now empty but good practice to keep it
  @override
  void dispose() {
    super.dispose();
  }

  // Helper function to get an icon for a category
  String _getIconForCategory(int categoryId) {
    switch (categoryId) {
      case 1: return '🎵';
      case 2: return '⚽';
      case 3: return '🎨';
      case 4: return '🍔';
      default: return '🎟️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            // MODIFIED: The TabBar is removed from here
            Expanded(
              // The FutureBuilder now directly builds the event list UI
              child: FutureBuilder<Map<String, dynamic>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!['events'] == null ||
                      snapshot.data!['categories'] == null) {
                    return const Center(child: Text('No data found.'));
                  }

                  // Extract the data once it's loaded
                  final List<Event> allEvents = snapshot.data!['events'];
                  final List<Category> allCategories = snapshot.data!['categories'];

                  // --- Filtering Logic (moved from the old _buildAllEventsTab) ---
                  List<Event> filteredEvents;
                  if (selectedCategoryName == 'All') {
                    filteredEvents = allEvents;
                  } else {
                    final selectedCat = allCategories.firstWhere(
                      (cat) => cat.name == selectedCategoryName,
                      orElse: () => Category(id: -1, name: '', icon: '', color: ''),
                    );
                    if (selectedCat.id != -1) {
                      filteredEvents = allEvents
                          .where((event) => event.categoryId == selectedCat.id)
                          .toList();
                    } else {
                      filteredEvents = [];
                    }
                  }
                  // --- End Filtering Logic ---

                  // MODIFIED: Directly return the Column with filters and grid
                  return Column(
                    children: [
                      _buildCategoryFilter(allCategories),
                      Expanded(child: _buildEventGrid(filteredEvents)),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Text(
            'Explore Events',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(),
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

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0), // Added bottom padding
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(158, 158, 158, 0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search events, artists, venues...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            suffixIcon: Icon(Icons.mic, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  // REMOVED: _buildTabBar() is no longer needed.

  Widget _buildCategoryFilter(List<Category> categories) {
    final categoryNames = ['All', ...categories.map((c) => c.name)];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16), // Adjusted margin
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categoryNames.length,
        itemBuilder: (context, index) {
          final categoryName = categoryNames[index];
          final isSelected = selectedCategoryName == categoryName;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryName = categoryName;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(158, 158, 158, 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventGrid(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: Text("No events found for this category."));
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade300, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(
                    _getIconForCategory(event.categoryId),
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 10, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.date,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 10, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '4.5', // Placeholder, API doesn't provide rating
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${event.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // REMOVED: _buildMapView() and _buildCalendarView() are no longer needed.

  void _showFilterSheet() {
    // This widget remains a placeholder
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Filters')))
            ])));
  }
}