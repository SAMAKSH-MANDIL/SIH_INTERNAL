import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../theme_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Removed Firebase dependency
import 'language_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tabs/home_tab.dart';
import '../tabs/crop_advisory_tab.dart';
import '../tabs/soil_advisory_tab.dart';
import '../tabs/crop_doctor_tab.dart';
import '../tabs/store_tab.dart';
import '../tabs/schemes_tab.dart';
import 'my_orders_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final ThemeController _themeController = ThemeController.instance;

  List<Widget> get _tabs => [
        HomeTab(onNavigateToTab: _onItemTapped),
        const CropAdvisoryTab(),
        const SoilAdvisoryTab(),
        const CropDoctorTab(),
        const StoreTab(),
        const SchemesTab(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1f4037) : Colors.white,
        title: Text(tr("language"), style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const SizedBox(width: 0),
              title: Text("English", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green)),
              onTap: () async {
                await _saveLanguagePreference(const Locale('en'));
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const SizedBox(width: 0),
              title: Text("हिन्दी", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green)),
              onTap: () async {
                await _saveLanguagePreference(const Locale('hi'));
                context.setLocale(const Locale('hi'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const SizedBox(width: 0),
              title: Text("বাংলা", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green)),
              onTap: () async {
                await _saveLanguagePreference(const Locale('bn'));
                context.setLocale(const Locale('bn'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const SizedBox(width: 0),
              title: Text("खोर्टा", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green)),
              onTap: () {
                _showKhorthaPopup(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showKhorthaPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'खोर्टा भाषा',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'इस भाषा में ऐप अभी विकसित हो रहा है। कृपया किसी अन्य भाषा का चयन करें।',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'ठीक है',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveLanguagePreference(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', locale.languageCode);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("app_name")),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _themeController.themeMode == ThemeMode.light
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    _themeController.toggle();
                  },
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green),
            ),
            onSelected: (value) async {
              if (value == 'language') {
                _showLanguageDialog(context);
              } else if (value == 'my_orders') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersScreen(),
                  ),
                );
              } else if (value == 'logout') {
                // Demo logout - just clear local data
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('farmer_name');
                  await prefs.remove('farmer_phone');
                  debugPrint('Demo logout: Local data cleared');
                } catch (e) {
                  debugPrint('Demo logout error: $e');
                }

                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LanguageSelectionScreen(),
                  ),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value ${tr("selected")}')),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(tr("profile")),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'my_orders',
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(tr("my_orders")),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'language',
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(tr("language")),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'help',
                  child: Row(
                    children: [
                      const Icon(Icons.help_outline, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(tr("help")),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.red),
                      const SizedBox(width: 10),
                      Text(tr("logout"), style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: tr("home"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.agriculture_outlined),
              activeIcon: const Icon(Icons.agriculture),
              label: tr("crop_advisory"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.grass_outlined),
              activeIcon: const Icon(Icons.grass),
              label: tr("soil_advisory"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.medical_services_outlined),
              activeIcon: const Icon(Icons.medical_services),
              label: tr("crop_doctor"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store_outlined),
              activeIcon: const Icon(Icons.store),
              label: tr("store"),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_outlined),
              activeIcon: const Icon(Icons.account_balance),
              label: tr("schemes"),
            ),
          ],
        ),
      ),
    );
  }
}