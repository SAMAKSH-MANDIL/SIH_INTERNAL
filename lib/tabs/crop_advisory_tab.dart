import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CropAdvisoryTab extends StatefulWidget {
  const CropAdvisoryTab({Key? key}) : super(key: key);

  @override
  State<CropAdvisoryTab> createState() => _CropAdvisoryTabState();
}

class _CropAdvisoryTabState extends State<CropAdvisoryTab> {
  final TextEditingController _queryController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _advisoryResult = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('crop_advisory'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr('crop_advisory_subtitle'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _queryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: tr('ask_crop_question'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.agriculture, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _getAdvice,
                        icon: const Icon(Icons.search),
                        label: Text(tr('get_advice')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _toggleListening,
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Suggestions
          Text(
            tr('quick_suggestions'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip(tr('wheat_cultivation')),
              _buildSuggestionChip(tr('rice_farming')),
              _buildSuggestionChip(tr('pest_control')),
              _buildSuggestionChip(tr('fertilizer_guide')),
              _buildSuggestionChip(tr('irrigation_tips')),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Results Section
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          else if (_advisoryResult.isNotEmpty)
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
                          const Icon(Icons.lightbulb, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            tr('advisory_result'),
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
                        _advisoryResult,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
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

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _queryController.text = text;
        _getAdvice();
      },
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.green.shade100,
        labelStyle: const TextStyle(color: Colors.green),
        side: BorderSide(color: Colors.green.shade300),
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _queryController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _getAdvice() {
    if (_queryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('enter_question')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _advisoryResult = _generateMockAdvice(_queryController.text);
      });
    });
  }

  String _generateMockAdvice(String query) {
    // Mock advisory based on query
    if (query.toLowerCase().contains('wheat')) {
      return tr('wheat_advice');
    } else if (query.toLowerCase().contains('rice')) {
      return tr('rice_advice');
    } else if (query.toLowerCase().contains('pest')) {
      return tr('pest_advice');
    } else {
      return tr('general_advice');
    }
  }
}