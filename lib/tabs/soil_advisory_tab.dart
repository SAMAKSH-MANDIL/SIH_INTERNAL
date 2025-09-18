import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class SoilAdvisoryTab extends StatefulWidget {
  const SoilAdvisoryTab({Key? key}) : super(key: key);

  @override
  State<SoilAdvisoryTab> createState() => _SoilAdvisoryTabState();
}

class _SoilAdvisoryTabState extends State<SoilAdvisoryTab> {
  Uint8List? _soilImage;
  String _analysisResult = "";
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
            tr('soil_advisory_subtitle'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Image Upload Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.brown.shade200,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                if (_soilImage == null)
                  Column(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 60,
                        color: Colors.brown.shade400,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        tr('upload_soil_image'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('soil_image_instruction'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.brown.shade500,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _soilImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        tr('soil_image_uploaded'),
                        style: TextStyle(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: Text(tr('take_photo')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: Text(tr('from_gallery')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (_soilImage != null) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _analyzeSoil,
                      icon: _isAnalyzing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.analytics),
                      label: Text(
                        _isAnalyzing ? tr('analyzing') : tr('analyze_soil'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
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
                            _soilImage = null;
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _soilImage = bytes;
          _analysisResult = "";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('image_pick_error')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeSoil() async {
    setState(() => _isAnalyzing = true);

    // Simulate soil analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _analysisResult = tr('soil_analysis_mock_result');
    });
  }
}