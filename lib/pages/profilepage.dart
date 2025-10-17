import 'package:flutter/material.dart';

// Adjust the import paths to match your project structure
import 'package:event_ticketing_system/service/apiservice.dart';
import 'package:event_ticketing_system/models/usermodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // --- API Integration ---
  final ApiService apiService = ApiService();
  late Future<User> _userFuture;

  // The menu items list remains as it's for UI navigation.
  // The subtitle for 'Favorite Events' will be updated dynamically.
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.person_outline, 'title': 'Edit Profile', 'subtitle': 'Update your personal information', 'color': Colors.blue},
    {'icon': Icons.payment, 'title': 'Payment Methods', 'subtitle': 'Manage your payment options', 'color': Colors.green},
    {'icon': Icons.notifications_outlined, 'title': 'Notifications', 'subtitle': 'Manage notification preferences', 'color': Colors.orange},
    {'icon': Icons.favorite_border, 'title': 'Favorite Events', 'subtitle': 'View your saved events', 'color': Colors.pink},
    {'icon': Icons.lock_outline, 'title': 'Privacy & Security', 'subtitle': 'Control your privacy settings', 'color': Colors.purple},
    {'icon': Icons.help_outline, 'title': 'Help & Support', 'subtitle': 'Get help and contact support', 'color': Colors.teal},
    {'icon': Icons.description_outlined, 'title': 'Terms & Conditions', 'subtitle': 'Read our terms of service', 'color': Colors.grey},
    {'icon': Icons.info_outline, 'title': 'About', 'subtitle': 'App version 1.0.0', 'color': Colors.indigo},
  ];

  @override
  void initState() {
    super.initState();
    // Fetch the user data when the widget is initialized (hardcoding user ID 1)
    _userFuture = apiService.fetchUser(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        // Use a FutureBuilder to handle the state of the API call
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            // While data is loading, show a spinner
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // If an error occurs, show an error message
            if (snapshot.hasError) {
              return Center(child: Text("Error fetching profile: ${snapshot.error}"));
            }
            // If data is not found
            if (!snapshot.hasData) {
              return const Center(child: Text("User not found."));
            }

            // Once data is successfully fetched, build the UI
            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProfileCard(user),
                  _buildStatsSection(user),
                  const SizedBox(height: 20),
                  _buildMenuSection(user),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
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
            'Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // MODIFIED: This widget now accepts a User object
  Widget _buildProfileCard(User user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Color(0xFF7C4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // MODIFIED: Replaced withOpacity with withAlpha for a fractional value
            color: Colors.deepPurple.withAlpha(77), // ~0.3 opacity
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.deepPurple),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // --- DYNAMIC DATA ---
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 14, color: Color.fromRGBO(255, 255, 255, 0.9)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 14, color: Color.fromRGBO(255, 255, 255, 0.9)),
              const SizedBox(width: 4),
              Text(
                user.location,
                style: const TextStyle(fontSize: 13, color: Color.fromRGBO(255, 255, 255, 0.9)),
              ),
            ],
          ),
          // --- END DYNAMIC DATA ---
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Colors.white.withAlpha(242), // ~0.95 opacity
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODIFIED: This widget now builds stats dynamically from the User object
  Widget _buildStatsSection(User user) {
    // Create the stats list dynamically based on user data
    final List<Map<String, dynamic>> stats = [
      {'label': 'Events', 'value': user.tickets.length.toString(), 'icon': Icons.confirmation_number},
      {'label': 'Favorites', 'value': user.favorites.length.toString(), 'icon': Icons.favorite},
      {'label': 'Reviews', 'value': '18', 'icon': Icons.star}, // Placeholder
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // MODIFIED: Replaced withOpacity
            color: const Color.fromRGBO(158, 158, 158, 0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) => _buildStatItem(stat)).toList(),
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // MODIFIED: Replaced withOpacity
            color: const Color.fromRGBO(103, 58, 183, 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(stat['icon'], color: Colors.deepPurple, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          stat['value'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 4),
        Text(stat['label'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  // MODIFIED: Accepts user to update menu item subtitles
  Widget _buildMenuSection(User user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // MODIFIED: Replaced withOpacity
            color: const Color.fromRGBO(158, 158, 158, 0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          // Dynamically update the subtitle for 'Favorite Events'
          if (item['title'] == 'Favorite Events') {
            item['subtitle'] = 'View your ${user.favorites.length} saved events';
          }

          final isLast = index == menuItems.length - 1;
          return Column(
            children: [
              _buildMenuItem(item),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Divider(height: 1, color: Colors.grey[200]),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // MODIFIED: Replaced withOpacity with withAlpha for dynamic colors
          color: (item['color'] as Color).withAlpha(26), // 0.1 opacity
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item['icon'], color: item['color'], size: 22),
      ),
      title: Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(item['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () => _handleMenuTap(item['title']),
    );
  }

  // --- The rest of the page (buttons and dialogs) remains the same ---
  // --- as it does not depend on the initial API data. ---

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _showLogoutDialog,
          icon: const Icon(Icons.logout, size: 20),
          label: const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _handleMenuTap(String title) {
    // ... (This method is unchanged)
  }

  void _showEditProfileSheet() {
    // ... (This method is unchanged, but could be enhanced to use the user data)
  }

  Widget _buildTextField(String label, String initialValue, IconData icon) {
    // ... (This method is unchanged)
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: initialValue,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showNotificationSettings() {
    // ... (This method is unchanged)
  }

  Widget _buildSwitchTile(String title, bool value) {
    // ... (This method is unchanged)
     return SwitchListTile(
      title: Text(title),
      value: value,
      activeColor: Colors.deepPurple,
      onChanged: (newValue) {},
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showHelpSheet() {
    // ... (This method is unchanged)
  }

  void _showAboutDialog() {
    // ... (This method is unchanged)
  }

  void _showLogoutDialog() {
    // ... (This method is unchanged)
  }
  
  void _showSuccessSnackBar(String message) {
     // ... (This method is unchanged)
  }
}