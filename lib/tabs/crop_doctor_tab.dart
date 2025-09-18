import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CropDoctorTab extends StatefulWidget {
  const CropDoctorTab({Key? key}) : super(key: key);

  @override
  State<CropDoctorTab> createState() => _CropDoctorTabState();
}

class _CropDoctorTabState extends State<CropDoctorTab> {
  Uint8List? _cropImage;
  Map<String, String> _diagnosisResult = {};
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
            tr('crop_doctor'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload crop image for disease detection and treatment advice',
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
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                if (_cropImage == null)
                  Column(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        size: 60,
                        color: Colors.red.shade400,
                      ),
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
                        style: TextStyle(
                          color: Colors.red.shade500,
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
                          const Icon(Icons.medical_services, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
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
                      
                      _buildResultItem('Crop Name', _diagnosisResult['crop'] ?? '', Icons.agriculture),
                      _buildResultItem('Disease', _diagnosisResult['disease'] ?? '', Icons.bug_report),
                      _buildResultItem('Symptoms', _diagnosisResult['symptoms'] ?? '', Icons.visibility),
                      _buildResultItem('Cause', _diagnosisResult['cause'] ?? '', Icons.help_outline),
                      _buildResultItem('Management', _diagnosisResult['management'] ?? '', Icons.healing),
                      _buildResultItem('Prevention', _diagnosisResult['prevention'] ?? '', Icons.shield),
                      
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _cropImage = null;
                                  _diagnosisResult = {};
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Diagnose Another'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Share functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Report shared successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share Report'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Common Diseases Info
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
                        const Icon(Icons.info, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
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
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDiseaseCard('Wheat Rust', 'Yellow/brown spots on leaves', Icons.agriculture),
                          _buildDiseaseCard('Rice Blast', 'Diamond-shaped lesions', Icons.grass),
                          _buildDiseaseCard('Tomato Blight', 'Dark spots with yellow halos', Icons.local_florist),
                          _buildDiseaseCard('Corn Smut', 'Large galls on ears and stalks', Icons.eco),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
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
        title: Text(
          disease,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Show more details
        },
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
          _diagnosisResult = {};
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _diagnoseCrop() async {
    setState(() => _isAnalyzing = true);

    // Simulate AI diagnosis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _diagnosisResult = {
        'crop': 'Wheat',
        'disease': 'Leaf Rust (Puccinia triticina)',
        'symptoms': 'Small, circular to oval, orange-red pustules on leaf surfaces. Pustules may coalesce to form larger patches.',
        'cause': 'Fungal infection caused by Puccinia triticina. Favored by moderate temperatures (15-25°C) and high humidity.',
        'management': '1. Apply fungicides containing propiconazole or tebuconazole\n2. Remove infected plant debris\n3. Ensure proper air circulation\n4. Apply at first sign of infection',
        'prevention': '1. Use resistant wheat varieties\n2. Crop rotation with non-host crops\n3. Avoid overhead irrigation\n4. Monitor weather conditions\n5. Plant at recommended spacing'
      };
    });
  }
}