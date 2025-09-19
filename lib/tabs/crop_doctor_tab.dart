import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CropDoctorTab extends StatefulWidget {
  const CropDoctorTab({Key? key}) : super(key: key);

  @override
  State<CropDoctorTab> createState() => _CropDoctorTabState();
}

class _CropDoctorTabState extends State<CropDoctorTab> {
  Uint8List? _cropImage;
  XFile? _selectedFile;
  Map<String, dynamic> _diagnosisResult = {};
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('crop_doctor'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload crop image for disease detection and treatment advice',
              style: TextStyle(
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
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  if (_cropImage == null)
                    Column(
                      children: [
                        Icon(Icons.local_hospital,
                            size: 60, color: Colors.red.shade400),
                        const SizedBox(height: 15),
                        Text(
                          'Upload Crop Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take a clear photo of affected crop parts for accurate diagnosis',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red.shade500),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _cropImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Crop image uploaded successfully',
                          style: TextStyle(
                            color: Colors.red.shade700,
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
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
                          label: const Text('From Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
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

                  if (_cropImage != null) ...[
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _diagnoseCrop,
                        icon: _isAnalyzing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.medical_services),
                        label: Text(
                          _isAnalyzing ? 'Diagnosing...' : 'Diagnose Crop',
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

            // Diagnosis Results
            if (_diagnosisResult.isNotEmpty)
              _buildDiagnosisReport()
            else
              _buildCommonDiseases(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisReport() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Diagnosis Report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildResultItem('Crop Name', _diagnosisResult['crop_name'] ?? '',
                Icons.agriculture),
            _buildResultItem(
                'Disease', _diagnosisResult['crop_disease'] ?? '', Icons.bug_report),
            _buildResultItem(
                'Symptoms',
                (_diagnosisResult['crop_disease_symptoms'] as List<dynamic>?)
                        ?.join(", ") ??
                    '',
                Icons.visibility),
            _buildResultItem(
                'Cause',
                (_diagnosisResult['crop_disease_cause'] as List<dynamic>?)
                        ?.join(", ") ??
                    '',
                Icons.help_outline),
            _buildResultItem(
                'Management',
                (_diagnosisResult['crop_disease_management'] as List<dynamic>?)
                        ?.join(", ") ??
                    '',
                Icons.healing),
            _buildResultItem(
                'Prevention',
                (_diagnosisResult['crop_disease_prevention'] as List<dynamic>?)
                        ?.join(", ") ??
                    '',
                Icons.shield),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonDiseases() {
    return Container(
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
            children: const [
              Icon(Icons.info, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Common Crop Diseases',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDiseaseCard(
                  'Wheat Rust', 'Yellow/brown spots on leaves', Icons.agriculture),
              _buildDiseaseCard(
                  'Rice Blast', 'Diamond-shaped lesions', Icons.grass),
              _buildDiseaseCard('Tomato Blight',
                  'Dark spots with yellow halos', Icons.local_florist),
              _buildDiseaseCard(
                  'Corn Smut', 'Large galls on ears and stalks', Icons.eco),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(String disease, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(disease,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
          _cropImage = bytes;
          _selectedFile = pickedFile;
          _diagnosisResult = {};
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error picking image. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _diagnoseCrop() async {
    if (_selectedFile == null) return;
    setState(() => _isAnalyzing = true);

    try {
      final uri =
          Uri.parse("https://d35fd786c844.ngrok-free.app/crop-doctor/analyze"); // emulator base
      final request = http.MultipartRequest("POST", uri);

      if (kIsWeb) {
        final bytes = await _selectedFile!.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes('image', bytes,
            filename: _selectedFile!.name));
      } else {
        request.files.add(
            await http.MultipartFile.fromPath('image', _selectedFile!.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          _diagnosisResult = jsonDecode(responseBody);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }
}