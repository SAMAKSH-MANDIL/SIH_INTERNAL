import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

class SoilAdvisoryTab extends StatefulWidget {
  const SoilAdvisoryTab({Key? key}) : super(key: key);

  @override
  State<SoilAdvisoryTab> createState() => _SoilAdvisoryTabState();
}

class _SoilAdvisoryTabState extends State<SoilAdvisoryTab> {
  String _analysisResult = "";
  bool _isLoadingAdvisory = false;
  bool _askedLocationThisSession = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    // Ask for location when the tab is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _promptForLocationIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingAdvisory) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                tr('analyzing'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: 0.7,
                duration: const Duration(milliseconds: 700),
                child: Text(
                  tr('please_wait_while_we_fetch_advisory'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('soil_advisory'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get crop recommendations based on your location and soil conditions',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Content removed as per requirement – advisory will be fetched by location
          
          const SizedBox(height: 20),
          
          // Soil Health Tips
          if (_analysisResult.isEmpty)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          tr('soil_health_tips'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTipItem(tr('tip_1')),
                          _buildTipItem(tr('tip_2')),
                          _buildTipItem(tr('tip_3')),
                          _buildTipItem(tr('tip_4')),
                          _buildTipItem(tr('tip_5')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Analysis Results
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.science, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            tr('soil_analysis_result'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _analysisResult,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _analysisResult = "";
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(tr('analyze_another')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Image selection and manual analysis removed

  Future<void> _promptForLocationIfNeeded() async {
    if (_askedLocationThisSession) return;
    _askedLocationThisSession = true;

    // Simple dialog prompting user to enable location
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enable Location'),
          content: const Text(
            'We use your location to provide soil advisory for your area.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );

    if (proceed != true) return;
    await _ensureLocationAndFetch();
  }

  Future<void> _ensureLocationAndFetch() async {
    try {
      setState(() => _isLoadingAdvisory = true);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingAdvisory = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingAdvisory = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingAdvisory = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission permanently denied.'),
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Fetch advisory from backend using coordinates
      await _fetchSoilAdvisoryForLocation(_latitude!, _longitude!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get location.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingAdvisory = false);
      }
    }
  }

  Future<void> _fetchSoilAdvisoryForLocation(double lat, double lng) async {
    // TODO: Replace this simulated delay with a real HTTP call
    await Future.delayed(const Duration(seconds: 2));
    // Do not show lat/lng to the user; just use them internally
  }
}