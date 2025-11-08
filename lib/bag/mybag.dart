import 'package:flutter/material.dart';

class Bag extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;
  const Bag({super.key, required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bag")),
      body: selectedProducts.isEmpty
          ? const Center(child: Text("🛍️ Your bag is empty"))
          : ListView.builder(
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final product = selectedProducts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      product['image'],
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['name']),
                    subtitle: Text(
                        "Size: ${product['size']} | Color: ${product['color']}"),
                    trailing: Text("₹${product['price']}"),
                  ),
                );
              },
            ),
    );
  }
}
