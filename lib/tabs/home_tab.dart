import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// Location access is restricted to Soil Advisory tab only
// import 'package:firebase_auth/firebase_auth.dart'; // Removed Firebase dependency
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  final void Function(int index)? onNavigateToTab;
  const HomeTab({Key? key, this.onNavigateToTab}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _location = "Location disabled";
  String _weather = "25°C";
  String _humidity = "65%";
  String _windSpeed = "12 km/h";
  String _farmerName = 'Farmer';

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _farmerName = prefs.getString('farmer_name') ?? 'Farmer';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Removed Firebase user dependency - using demo mode
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tr('welcome')}, ${_farmerName.isNotEmpty ? _farmerName : 'Farmer'}!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('welcome_message'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Weather Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      tr('weather_info'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherItem(Icons.thermostat, tr('temperature'), _weather),
                    _buildWeatherItem(Icons.water_drop, tr('humidity'), _humidity),
                    _buildWeatherItem(Icons.air, tr('wind_speed'), _windSpeed),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          Text(
            tr('quick_actions'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
            children: [
              _buildQuickActionCard(
                Icons.agriculture,
                tr('crop_advisory'),
                Colors.green,
                () => _navigateToTab(1),
              ),
              _buildQuickActionCard(
                Icons.grass,
                tr('soil_advisory'),
                Colors.brown,
                () => _navigateToTab(2),
              ),
              _buildQuickActionCard(
                Icons.medical_services,
                tr('crop_doctor'),
                Colors.red,
                () => _navigateToTab(3),
              ),
              _buildQuickActionCard(
                Icons.store,
                tr('shop_now'),
                Colors.purple,
                () => _navigateToTab(4),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Recent Activity
          Text(
            tr('recent_activity'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          
          _buildActivityCard(
            Icons.camera_alt,
            tr('crop_diagnosis'),
            tr('wheat_rust_detected'),
            "2 ${tr('hours_ago')}",
          ),
          const SizedBox(height: 10),
          _buildActivityCard(
            Icons.shopping_cart,
            tr('order_placed'),
            tr('fertilizer_order'),
            "1 ${tr('day_ago')}",
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.2),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTab(int index) {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(index);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${tr('navigating_to')} ${_getTabName(index)}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 1: return tr('crop_advisory');
      case 2: return tr('soil_advisory');
      case 3: return tr('crop_doctor');
      case 4: return tr('store');
      default: return tr('home');
    }
  }
}