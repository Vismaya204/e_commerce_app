import 'package:e_commerce_app/bag/mybag_checkout.dart';
import 'package:flutter/material.dart';

class Bag extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  const Bag({super.key, required this.selectedProducts});

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = widget.selectedProducts.map((product) {
      return {...product, 'quantity': product['quantity'] ?? 1};
    }).toList();
  }

  double get totalAmount {
    return products.fold<double>(
      0,
      (sum, item) =>
          sum +
          ((double.tryParse(item['price'].toString()) ?? 0) *
              (item['quantity'] as int)),
    );
  }

  void incrementQuantity(int index) {
    setState(() {
      products[index]['quantity'] += 1;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (products[index]['quantity'] > 1) {
        products[index]['quantity'] -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bag")),
      body: products.isEmpty
          ? const Center(child: Text("🛍️ Your bag is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(product['image'], width: 60),
                          title: Text(product['name']),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text(product['quantity'].toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => incrementQuantity(index),
                              ),
                            ],
                          ),
                          trailing: Text(
                            "₹${(double.tryParse(product['price'].toString()) ?? 0) * product['quantity']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("₹${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MybagCheckout(cartData: products),
                      ),
                    );
                  },
                  child: const Text("CHECK OUT"),
                ),
              ],
            ),
    );
  }
}