import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Removed for demo mode
import 'package:easy_localization/easy_localization.dart';
import 'home_page.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  // FirebaseAuth? _auth; // Removed for demo mode
  
  // String _verificationId = ''; // Not used in demo mode
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _demoOtp = '';

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
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double logoWidth = constraints.maxWidth < 420
                            ? 140
                            : constraints.maxWidth < 560
                                ? 180
                                : 220;
                        return Column(
                          children: [
                            Image.asset(
                              'assets/images/kisanone_logo.png',
                              width: logoWidth,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                    Text(
                      tr('login_title'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tr('login_subtitle'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    if (!_isOtpSent) ...[
                      _buildNameInput(),
                      const SizedBox(height: 12),
                      _buildPhoneInput(),
                      const SizedBox(height: 16),
                      _buildSendOtpButton(),
                    ] else ...[
                      const SizedBox(height: 6),
                      Text(
                        tr('enter_otp'),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildOtpInput(),
                      const SizedBox(height: 12),
                      _buildVerifyOtpButton(),
                      const SizedBox(height: 10),
                      _buildResendButton(),
                    ],
                    const SizedBox(height: 24),
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Demo mode - no Firebase initialization needed
    debugPrint('LoginScreen: Demo mode initialized');
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(color: Colors.green),
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: tr("farmer_name_hint"),
          hintStyle: const TextStyle(color: Colors.green),
          prefixIcon: const Icon(Icons.person, color: Colors.green),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _phoneController,
        style: const TextStyle(color: Colors.green),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        onChanged: (value) {
          // Real-time validation feedback
          if (value.length == 10) {
            final isValid = RegExp(r'^\d{10}$').hasMatch(value);
            if (!isValid) {
              _showSnackBar('Please enter a valid mobile number');
            }
          }
        },
        decoration: InputDecoration(
          hintText: tr("phone_hint"),
          counterText: '',
          hintStyle: const TextStyle(color: Colors.green),
          prefixIcon: const Icon(Icons.phone, color: Colors.green),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildOtpInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _otpController,
        style: const TextStyle(color: Colors.green),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 6,
        decoration: InputDecoration(
          hintText: tr("otp_hint"),
          counterText: '',
          hintStyle: const TextStyle(color: Colors.green),
          prefixIcon: const Icon(Icons.security, color: Colors.green),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendOtp,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.black)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Ink(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    tr("send_otp"),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.green),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildVerifyOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.black)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Ink(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    tr("verify_otp"),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.green),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: _sendOtp,
      child: Text(
        tr("resend_otp"),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LanguageSelectionScreen(),
          ),
          (route) => false,
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          tr("back_to_language"),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_nameController.text.isEmpty) {
      _showSnackBar(tr("enter_name"));
      return;
    }
    final phone = _phoneController.text.trim();
    final isTenDigits = RegExp(r'^\d{10}$').hasMatch(phone);
    if (!isTenDigits) {
      _showSnackBar('Please enter a valid mobile number');
      return;
    }

    setState(() => _isLoading = true);

    // Always use demo mode
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    _demoOtp = ((nowMillis % 900000) + 100000).toString(); // 6-digit
    setState(() {
      _isOtpSent = true;
      _isLoading = false;
    });
    _showSnackBar('Demo OTP: $_demoOtp');
    debugPrint('Demo OTP generated: $_demoOtp');
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      _showSnackBar(tr("enter_otp"));
      return;
    }

    setState(() => _isLoading = true);

    // Always use demo verification
    if (_otpController.text == _demoOtp && _demoOtp.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('farmer_name', _nameController.text);
      await prefs.setString('farmer_phone', _phoneController.text);
      debugPrint('Demo login successful for: ${_nameController.text}');
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      _showSnackBar(tr("invalid_otp"));
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}