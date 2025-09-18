import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class StoreTab extends StatefulWidget {
  const StoreTab({Key? key}) : super(key: key);

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Seeds', 'Fertilizers', 'Pesticides', 'Tools', 'Equipment'];
  
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Wheat Seeds (HD-2967)',
      'price': '₹2,500',
      'originalPrice': '₹3,000',
      'category': 'Seeds',
      'rating': 4.5,
      'image': '🌾',
      'description': 'High yielding wheat variety suitable for irrigated conditions',
      'inStock': true,
    },
    {
      'name': 'NPK Fertilizer (19:19:19)',
      'price': '₹1,200',
      'originalPrice': '₹1,400',
      'category': 'Fertilizers',
      'rating': 4.3,
      'image': '🧪',
      'description': 'Balanced fertilizer for all crops',
      'inStock': true,
    },
    {
      'name': 'Organic Pesticide',
      'price': '₹800',
      'originalPrice': '₹950',
      'category': 'Pesticides',
      'rating': 4.7,
      'image': '🧴',
      'description': 'Eco-friendly pest control solution',
      'inStock': true,
    },
    {
      'name': 'Garden Sprayer',
      'price': '₹1,500',
      'originalPrice': '₹1,800',
      'category': 'Tools',
      'rating': 4.2,
      'image': '🔧',
      'description': '16L capacity manual sprayer',
      'inStock': false,
    },
    {
      'name': 'Rice Seeds (Basmati)',
      'price': '₹3,200',
      'originalPrice': '₹3,500',
      'category': 'Seeds',
      'rating': 4.8,
      'image': '🌾',
      'description': 'Premium basmati rice seeds',
      'inStock': true,
    },
    {
      'name': 'Drip Irrigation Kit',
      'price': '₹5,500',
      'originalPrice': '₹6,200',
      'category': 'Equipment',
      'rating': 4.6,
      'image': '💧',
      'description': 'Complete drip irrigation system for 1 acre',
      'inStock': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((product) => product['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            border: Border(bottom: BorderSide(color: Colors.purple.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.store, color: Colors.purple, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    tr('store'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cart opened'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    },
                    icon: const Badge(
                      label: Text('3'),
                      child: Icon(Icons.shopping_cart, color: Colors.purple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Quality agricultural products at your doorstep',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search, color: Colors.purple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.purple.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.purple),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        
        // Category Filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  selectedColor: Colors.purple.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.purple : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? Colors.purple : Colors.grey.shade300,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Products Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                product['image'],
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    product['description'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        product['rating'].toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        product['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product['originalPrice'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: product['inStock'] ? () => _addToCart(product) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product['inStock'] ? Colors.purple : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        product['inStock'] ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(fontSize: 12),
                      ),
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

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }
}