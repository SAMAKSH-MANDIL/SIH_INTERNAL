import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../screens/my_orders_screen.dart';

class StoreTab extends StatefulWidget {
  const StoreTab({Key? key}) : super(key: key);

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  String _selectedCategory = 'All';
  String _query = '';
  final Map<String, int> _cart = {};
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
    final List<Map<String, dynamic>> byCategory = _selectedCategory == 'All'
        ? _products
        : _products.where((product) => product['category'] == _selectedCategory).toList();
    if (_query.trim().isEmpty) return byCategory;
    final lower = _query.toLowerCase();
    return byCategory.where((p) =>
      (p['name'] as String).toLowerCase().contains(lower) ||
      (p['description'] as String).toLowerCase().contains(lower)
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
                    onPressed: _openCart,
                    icon: Badge(
                      label: Text('$_cartCount'),
                      child: const Icon(Icons.shopping_cart, color: Colors.purple),
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
            onChanged: (val) => setState(() => _query = val),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
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
    final String name = product['name'];
    final bool inStock = product['inStock'] as bool;
    final int qty = _cart[name] ?? 0;
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
                  
                  // Add to Cart / Quantity Controls
                  if (qty == 0)
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: inStock ? () => _addToCart(product) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: inStock ? Colors.purple : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          inStock ? 'Add to Cart' : 'Out of Stock',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade200),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.purple.shade50,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18, color: Colors.purple),
                            padding: EdgeInsets.zero,
                            onPressed: () => _decrement(name),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18, color: Colors.purple),
                            padding: EdgeInsets.zero,
                            onPressed: () => _increment(name),
                          ),
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

  void _addToCart(Map<String, dynamic> product) {
    final String name = product['name'];
    setState(() {
      _cart[name] = (_cart[name] ?? 0) + 1;
    });
    _showAddedSnackBar(name);
  }

  void _increment(String name) {
    setState(() {
      _cart[name] = (_cart[name] ?? 0) + 1;
    });
  }

  void _decrement(String name) {
    setState(() {
      final current = _cart[name] ?? 0;
      if (current <= 1) {
        _cart.remove(name);
      } else {
        _cart[name] = current - 1;
      }
    });
  }

  int get _cartCount => _cart.values.fold(0, (sum, v) => sum + v);

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CartScreen(
          cart: Map<String, int>.from(_cart),
          products: _products,
          onUpdate: (name, qty) {
            setState(() {
              if (qty <= 0) {
                _cart.remove(name);
              } else {
                _cart[name] = qty;
              }
            });
          },
        ),
      ),
    );
  }

  void _showAddedSnackBar(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: _openCart,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

}

class _CartScreen extends StatefulWidget {
  final Map<String, int> cart;
  final List<Map<String, dynamic>> products;
  final void Function(String name, int qty) onUpdate;

  const _CartScreen({Key? key, required this.cart, required this.products, required this.onUpdate}) : super(key: key);

  @override
  State<_CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<_CartScreen> {
  late Map<String, int> _localCart;

  @override
  void initState() {
    super.initState();
    _localCart = Map<String, int>.from(widget.cart);
  }

  Map<String, Map<String, dynamic>> get _nameToProduct {
    final map = <String, Map<String, dynamic>>{};
    for (final p in widget.products) {
      map[p['name'] as String] = p;
    }
    return map;
  }

  int _parsePriceToPaise(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits) * 100; // treat as rupees
  }

  int get _totalPaise {
    final products = _nameToProduct;
    int total = 0;
    _localCart.forEach((name, qty) {
      final p = products[name];
      if (p != null) {
        total += _parsePriceToPaise(p['price'] as String) * qty;
      }
    });
    return total;
  }

  String get _totalDisplay {
    final rupees = _totalPaise ~/ 100;
    return '₹${rupees.toString()}';
  }

  void _changeQty(String name, int qty) {
    setState(() {
      if (qty <= 0) {
        _localCart.remove(name);
      } else {
        _localCart[name] = qty;
      }
    });
    widget.onUpdate(name, qty);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _localCart.entries.toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Cart'),
      ),
      body: entries.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final item = entries[index];
                      final product = _nameToProduct[item.key];
                      final price = product != null ? product['price'] as String : '₹0';
                      final image = product != null ? product['image'] as String : '🛒';
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              alignment: Alignment.center,
                              child: Text(image, style: const TextStyle(fontSize: 36)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.key,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    _QtyControl(
                                      qty: item.value,
                                      onChanged: (q) => _changeQty(item.key, q),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      bottomSheet: entries.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _totalDisplay,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order placed (demo)')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('My Orders'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final void Function(int) onChanged;

  const _QtyControl({Key? key, required this.qty, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple.shade50,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18, color: Colors.purple),
            padding: EdgeInsets.zero,
            onPressed: () => onChanged(qty - 1),
          ),
          Expanded(
            child: Center(
              child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18, color: Colors.purple),
            padding: EdgeInsets.zero,
            onPressed: () => onChanged(qty + 1),
          ),
        ],
      ),
    );
  }
}