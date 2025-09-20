import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2e7d32), Color(0xFF43a047), Color(0xFF66bb6a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Column(
                    children: const [
                      SizedBox(height: 4),
                      Text(
                        'KisanOne',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'One Stop Solution for Farmers',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              const Text(
                'Select Your Language',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildLanguageButton(
                context,
                'English',
                const Locale('en'),
              ),
              const SizedBox(height: 15),
              _buildLanguageButton(
                context,
                'हिन्दी',
                const Locale('hi'),
              ),
              const SizedBox(height: 15),
              _buildLanguageButton(
                context,
                'বাংলা',
                const Locale('bn'),
              ),
              const SizedBox(height: 15),
              _buildLanguageButton(
                context,
                'खोर्टा',
                const Locale('kho'),
              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String language,
    Locale locale,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // Check if Khortha language is selected
          if (locale.languageCode == 'kho') {
            _showKhorthaPopup(context);
            return;
          }
          
          // Save language preference
          _saveLanguagePreference(locale);
          
          // Set locale and navigate
          context.setLocale(locale);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
         style: ElevatedButton.styleFrom(
           padding: EdgeInsets.zero,
           elevation: 0,
           backgroundColor: Colors.white,
           foregroundColor: Colors.green,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
             side: const BorderSide(color: Colors.black, width: 1),
           ),
         ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  language,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ),
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
}