import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'KisanOne',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'One Stop Solution for Farmers',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Select Your Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              _buildLanguageButton(
                context,
                'English',
                '🇺🇸',
                const Locale('en'),
              ),
              const SizedBox(height: 15),
              _buildLanguageButton(
                context,
                'हिन्दी',
                '🇮🇳',
                const Locale('hi'),
              ),
              const SizedBox(height: 15),
              _buildLanguageButton(
                context,
                'বাংলা',
                '🇧🇩',
                const Locale('bn'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String language,
    String flag,
    Locale locale,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          context.setLocale(locale);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.green, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 15),
            Text(
              language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}