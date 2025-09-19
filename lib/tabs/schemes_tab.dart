import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SchemesTab extends StatefulWidget {
  const SchemesTab({Key? key}) : super(key: key);

  @override
  State<SchemesTab> createState() => _SchemesTabState();
}

class _SchemesTabState extends State<SchemesTab> {
  String _selectedCategory = 'All';
  String _query = '';
  final List<String> _categories = ['All', 'Central', 'State', 'Credit', 'Insurance', 'Subsidy'];

  final List<Map<String, dynamic>> _schemes = [
    {
      'name': 'PM-KISAN',
      'fullName': 'Pradhan Mantri Kisan Samman Nidhi',
      'type': 'Central',
      'category': 'Credit',
      'amount': '₹6,000/year',
      'description': 'Direct income support to small and marginal farmers',
      'eligibility': 'Small & marginal farmers with cultivable land up to 2 hectares',
      'benefits': '₹2,000 in three equal installments',
      'howToApply': 'Online through PM-KISAN portal or Common Service Centers',
      'documents': 'Aadhaar, Bank details, Land records',
      'icon': '🌾',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'PMFBY',
      'fullName': 'Pradhan Mantri Fasal Bima Yojana',
      'type': 'Central',
      'category': 'Insurance',
      'amount': 'Up to ₹2 Lakh',
      'description': 'Crop insurance scheme for farmers',
      'eligibility': 'All farmers (sharecroppers & tenant farmers included)',
      'benefits': 'Comprehensive risk cover for crops',
      'howToApply': 'Through banks, insurance companies, or online portal',
      'documents': 'Aadhaar, Bank account, Land documents, Sowing certificate',
      'icon': '🛡️',
      'color': Colors.blue,
      'isActive': true,
    },
    {
      'name': 'KCC',
      'fullName': 'Kisan Credit Card',
      'type': 'Central',
      'category': 'Credit',
      'amount': 'Up to ₹3 Lakh',
      'description': 'Credit facility for farmers at subsidized interest rates',
      'eligibility': 'All farmers including tenant farmers, oral lessees, sharecroppers',
      'benefits': '4% interest rate, flexible repayment, insurance coverage',
      'howToApply': 'Visit nearest bank branch or apply online',
      'documents': 'Identity proof, Address proof, Land documents, Income proof',
      'icon': '💳',
      'color': Colors.orange,
      'isActive': true,
    },
    {
      'name': 'SMAM',
      'fullName': 'Sub-Mission on Agricultural Mechanization',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': '40-50% Subsidy',
      'description': 'Financial assistance for farm mechanization',
      'eligibility': 'Individual farmers, FPOs, Self Help Groups',
      'benefits': 'Subsidy on tractors, harvesters, and other farm equipment',
      'howToApply': 'Through state agriculture departments',
      'documents': 'Farmer registration, Bank details, Quotations',
      'icon': '🚜',
      'color': Colors.purple,
      'isActive': true,
    },
    {
      'name': 'PKVY',
      'fullName': 'Paramparagat Krishi Vikas Yojana',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': '₹50,000/hectare',
      'description': 'Promotion of organic farming practices',
      'eligibility': 'Groups of farmers (minimum 50) for cluster approach',
      'benefits': 'Financial support for organic inputs and certification',
      'howToApply': 'Through state organic farming agencies',
      'documents': 'Group formation certificate, Land records, Bank details',
      'icon': '🌱',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'PMKSY',
      'fullName': 'Pradhan Mantri Krishi Sinchayee Yojana',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': '55-90% Subsidy',
      'description': 'Micro irrigation and water conservation',
      'eligibility': 'All categories of farmers',
      'benefits': 'Subsidy on drip/sprinkler irrigation systems',
      'howToApply': 'Through state agriculture/horticulture departments',
      'documents': 'Land ownership proof, Water source certificate, Bank details',
      'icon': '💧',
      'color': Colors.blue,
      'isActive': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredSchemes {
    final List<Map<String, dynamic>> byCategory = _selectedCategory == 'All'
        ? _schemes
        : _schemes.where((scheme) => scheme['category'] == _selectedCategory || scheme['type'] == _selectedCategory).toList();
    if (_query.trim().isEmpty) return byCategory;
    final lower = _query.toLowerCase();
    return byCategory.where((s) =>
      (s['name'] as String).toLowerCase().contains(lower) ||
      (s['fullName'] as String).toLowerCase().contains(lower) ||
      (s['description'] as String).toLowerCase().contains(lower)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade400, Colors.indigo.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    tr('schemes'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredSchemes.length} ${tr("schemes_available")}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tr('schemes_subtitle'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.indigo.shade50,
          child: TextField(
            onChanged: (val) => setState(() => _query = val),
            decoration: InputDecoration(
              hintText: tr('search_schemes'),
              prefixIcon: const Icon(Icons.search, color: Colors.indigo),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
        
        // Category Filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.indigo.shade50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: Colors.indigo.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.indigo : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? Colors.indigo : Colors.grey.shade300,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Schemes List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredSchemes.length,
            itemBuilder: (context, index) {
              final scheme = _filteredSchemes[index];
              return _buildSchemeCard(scheme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSchemeCard(Map<String, dynamic> scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showSchemeDetails(scheme),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scheme['icon'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: scheme['color'],
                          ),
                        ),
                        Text(
                          scheme['fullName'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme['type'] == 'Central' ? Colors.orange.shade100 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scheme['type'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: scheme['type'] == 'Central' ? Colors.orange.shade700 : Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                scheme['description'],
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Amount and Category
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.currency_rupee, size: 16, color: Colors.green),
                        Text(
                          scheme['amount'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      scheme['category'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSchemeDetails(Map<String, dynamic> scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme['color'].withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scheme['icon'],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme['name'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: scheme['color'],
                            ),
                          ),
                          Text(
                            scheme['fullName'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildDetailSection(tr('description'), scheme['description'], Icons.info_outline),
                    _buildDetailSection(tr('eligibility'), scheme['eligibility'], Icons.person_outline),
                    _buildDetailSection(tr('benefits'), scheme['benefits'], Icons.star_outline),
                    _buildDetailSection(tr('how_to_apply'), scheme['howToApply'], Icons.assignment_outlined),
                    _buildDetailSection(tr('required_documents'), scheme['documents'], Icons.description_outlined),
                    
                    const SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${tr("more_info_about")} ${scheme["name"]}'),
                                  backgroundColor: Colors.indigo,
                                ),
                              );
                            },
                            icon: const Icon(Icons.info),
                            label: Text(tr('more_info')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${tr("applying_for")} ${scheme["name"]}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(Icons.assignment_turned_in),
                            label: Text(tr('apply_now')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}