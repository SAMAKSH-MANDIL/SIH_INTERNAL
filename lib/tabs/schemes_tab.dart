import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // Central Government Schemes
    {
      'name': 'PM-KISAN',
      'fullName': 'Pradhan Mantri Kisan Samman Nidhi',
      'type': 'Central',
      'category': 'Credit',
      'amount': '₹6,000/year',
      'description': 'Direct income support to small and marginal farmers',
      'eligibility': 'Small & marginal farmers with cultivable land up to 2 hectares',
      'benefits': '₹2,000 in three equal installments directly to bank accounts',
      'howToApply': 'Online through PM-KISAN portal or Common Service Centers',
      'documents': 'Aadhaar, Bank details, Land records, Mobile number',
      'link': 'https://pmkisan.gov.in',
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
      'description': 'Crop insurance scheme for farmers against natural calamities',
      'eligibility': 'All farmers including sharecroppers & tenant farmers',
      'benefits': 'Comprehensive risk cover for crops, low premium rates',
      'howToApply': 'Through banks, insurance companies, or online portal',
      'documents': 'Aadhaar, Bank account, Land documents, Sowing certificate',
      'link': 'https://pmfby.gov.in',
      'icon': '🛡️',
      'color': Colors.blue,
      'isActive': true,
    },
    {
      'name': 'PMKSY',
      'fullName': 'Pradhan Mantri Krishi Sinchayee Yojana',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': '55-90% Subsidy',
      'description': 'Micro irrigation and water conservation scheme',
      'eligibility': 'All categories of farmers',
      'benefits': 'Subsidy on drip/sprinkler irrigation systems, water conservation',
      'howToApply': 'Through state agriculture/horticulture departments',
      'documents': 'Land ownership proof, Water source certificate, Bank details',
      'link': 'https://pmksy.gov.in',
      'icon': '💧',
      'color': Colors.cyan,
      'isActive': true,
    },
    {
      'name': 'Soil Health Card',
      'fullName': 'Soil Health Card Scheme',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': 'Free Service',
      'description': 'Soil testing and health card distribution to farmers',
      'eligibility': 'All farmers across the country',
      'benefits': 'Free soil testing, personalized recommendations, improved productivity',
      'howToApply': 'Through Krishi Vigyan Kendras or online portal',
      'documents': 'Aadhaar, Land documents, Contact details',
      'link': 'https://soilhealth.dac.gov.in',
      'icon': '🌱',
      'color': Colors.brown,
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
      'link': 'https://pgsindia-ncof.gov.in',
      'icon': '🌿',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'e-NAM',
      'fullName': 'National Agriculture Market',
      'type': 'Central',
      'category': 'Credit',
      'amount': 'Better Prices',
      'description': 'Online trading platform for agricultural commodities',
      'eligibility': 'All farmers, traders, and FPOs',
      'benefits': 'Transparent pricing, better market access, reduced intermediaries',
      'howToApply': 'Register on e-NAM portal',
      'documents': 'Aadhaar, Bank details, Commodity details',
      'link': 'https://enam.gov.in',
      'icon': '💻',
      'color': Colors.orange,
      'isActive': true,
    },
    {
      'name': 'RKVY-RAFTAAR',
      'fullName': 'Rashtriya Krishi Vikas Yojana',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': 'State-wise allocation',
      'description': 'Comprehensive agricultural development program',
      'eligibility': 'State governments and implementing agencies',
      'benefits': 'Infrastructure development, technology adoption, capacity building',
      'howToApply': 'Through state agriculture departments',
      'documents': 'Project proposals, State action plans',
      'link': 'https://rkvy.nic.in',
      'icon': '🏗️',
      'color': Colors.indigo,
      'isActive': true,
    },
    {
      'name': 'NMSA',
      'fullName': 'National Mission on Sustainable Agriculture',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': '50-100% Subsidy',
      'description': 'Promoting sustainable agriculture practices',
      'eligibility': 'Farmers, FPOs, and agricultural institutions',
      'benefits': 'Climate-resilient farming, soil conservation, water management',
      'howToApply': 'Through state agriculture departments',
      'documents': 'Project proposals, Land documents, Bank details',
      'link': 'https://nmsa.dac.gov.in',
      'icon': '🌍',
      'color': Colors.teal,
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
      'link': 'https://agricoop.nic.in',
      'icon': '💳',
      'color': Colors.purple,
      'isActive': true,
    },
    {
      'name': 'NBHM',
      'fullName': 'National Beekeeping & Honey Mission',
      'type': 'Central',
      'category': 'Subsidy',
      'amount': 'Up to ₹1.5 Lakh',
      'description': 'Promotion of beekeeping and honey production',
      'eligibility': 'Beekeepers, FPOs, and agricultural institutions',
      'benefits': 'Financial assistance for beekeeping equipment and training',
      'howToApply': 'Through state horticulture departments',
      'documents': 'Beekeeping experience, Land documents, Bank details',
      'link': 'https://nbb.gov.in',
      'icon': '🐝',
      'color': Colors.amber,
      'isActive': true,
    },
    
    // Jharkhand State Schemes
    {
      'name': 'Jharkhand Krishi Rin Mafi',
      'fullName': 'Jharkhand Krishi Rin Mafi Yojana',
      'type': 'State',
      'category': 'Credit',
      'amount': 'Loan Waiver',
      'description': 'Agricultural loan waiver scheme for farmers',
      'eligibility': 'Small and marginal farmers with outstanding loans',
      'benefits': 'Complete or partial waiver of agricultural loans',
      'howToApply': 'Through designated banks and agricultural offices',
      'documents': 'Loan documents, Land records, Aadhaar, Bank details',
      'link': 'https://jrfry.jharkhand.gov.in',
      'icon': '💰',
      'color': Colors.red,
      'isActive': true,
    },
    {
      'name': 'MKAY',
      'fullName': 'Mukhyamantri Krishi Ashirwad Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': '₹5,000/acre',
      'description': 'Direct financial assistance to farmers for agricultural inputs',
      'eligibility': 'All farmers registered in Jharkhand',
      'benefits': 'Direct cash transfer for seeds, fertilizers, and other inputs',
      'howToApply': 'Online through MKAY portal or Common Service Centers',
      'documents': 'Aadhaar, Land documents, Bank details, Mobile number',
      'link': 'https://mkay.jharkhand.gov.in',
      'icon': '🎁',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'Birsa Harit Gram',
      'fullName': 'Birsa Harit Gram Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Varies by component',
      'description': 'Green village development and environmental conservation',
      'eligibility': 'Village communities and panchayats',
      'benefits': 'Tree plantation, environmental protection, rural development',
      'howToApply': 'Through district administration and panchayats',
      'documents': 'Village development plan, Land records, Community resolution',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🌳',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'Nilambar Pitambar Jal',
      'fullName': 'Nilambar Pitambar Jal Samriddhi Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Up to ₹50,000',
      'description': 'Water conservation and irrigation development scheme',
      'eligibility': 'Farmers and water user groups',
      'benefits': 'Financial assistance for water conservation structures',
      'howToApply': 'Through state water resources department',
      'documents': 'Land documents, Water source details, Bank details',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🏞️',
      'color': Colors.blue,
      'isActive': true,
    },
    {
      'name': 'Johar Scheme',
      'fullName': 'Johar Scheme',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Up to ₹1 Lakh',
      'description': 'Comprehensive development scheme for rural areas',
      'eligibility': 'Rural communities and self-help groups',
      'benefits': 'Infrastructure development, livelihood support, skill training',
      'howToApply': 'Through district administration and block offices',
      'documents': 'Community resolution, Bank details, Project proposal',
      'link': 'https://joharjharkhand.org',
      'icon': '🏘️',
      'color': Colors.orange,
      'isActive': true,
    },
    {
      'name': 'Krishi Input Subsidy',
      'fullName': 'Krishi Input Subsidy Scheme',
      'type': 'State',
      'category': 'Subsidy',
      'amount': '50-75% Subsidy',
      'description': 'Subsidy on agricultural inputs and equipment',
      'eligibility': 'All farmers in Jharkhand',
      'benefits': 'Subsidy on seeds, fertilizers, pesticides, and farm equipment',
      'howToApply': 'Through agricultural input dealers and cooperatives',
      'documents': 'Aadhaar, Land documents, Purchase receipts',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🛒',
      'color': Colors.purple,
      'isActive': true,
    },
    {
      'name': 'Mukhya Mantri Pashudhan',
      'fullName': 'Mukhya Mantri Pashudhan Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Up to ₹2 Lakh',
      'description': 'Livestock development and animal husbandry scheme',
      'eligibility': 'Livestock farmers and dairy cooperatives',
      'benefits': 'Financial assistance for livestock purchase and healthcare',
      'howToApply': 'Through animal husbandry department',
      'documents': 'Livestock registration, Bank details, Veterinary certificates',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🐄',
      'color': Colors.brown,
      'isActive': true,
    },
    {
      'name': 'Jharkhand Horticulture',
      'fullName': 'Jharkhand Horticulture Mission',
      'type': 'State',
      'category': 'Subsidy',
      'amount': '50-90% Subsidy',
      'description': 'Promotion of horticulture and fruit cultivation',
      'eligibility': 'Horticulture farmers and FPOs',
      'benefits': 'Subsidy on plants, irrigation, and post-harvest infrastructure',
      'howToApply': 'Through state horticulture department',
      'documents': 'Land documents, Horticulture plan, Bank details',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🍎',
      'color': Colors.green,
      'isActive': true,
    },
    {
      'name': 'Balram Yojana',
      'fullName': 'Balram Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Up to ₹25,000',
      'description': 'Agricultural mechanization and equipment subsidy',
      'eligibility': 'Individual farmers and FPOs',
      'benefits': 'Subsidy on tractors, tillers, and other farm machinery',
      'howToApply': 'Through state agriculture department',
      'documents': 'Land documents, Equipment quotations, Bank details',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '🚜',
      'color': Colors.grey,
      'isActive': true,
    },
    {
      'name': 'Mukhyamantri Krishi Pump',
      'fullName': 'Mukhyamantri Krishi Pump Set Yojana',
      'type': 'State',
      'category': 'Subsidy',
      'amount': 'Up to ₹15,000',
      'description': 'Subsidy on irrigation pump sets for farmers',
      'eligibility': 'Farmers with irrigation facilities',
      'benefits': 'Financial assistance for pump set installation',
      'howToApply': 'Through state agriculture and irrigation departments',
      'documents': 'Land documents, Water source certificate, Bank details',
      'link': 'https://www.jharkhand.gov.in/',
      'icon': '⚡',
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
                        if (scheme['link'] != null && scheme['link'].toString().isNotEmpty)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _launchUrl(scheme['link']);
                              },
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('Visit Website'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        if (scheme['link'] != null && scheme['link'].toString().isNotEmpty)
                          const SizedBox(width: 10),
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

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open $url'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}