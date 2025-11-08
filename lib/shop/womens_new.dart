import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/shop/model.dart';

class Newitems extends StatefulWidget {
  const Newitems({super.key});

  @override
  State<Newitems> createState() => _NewitemsState();
}

class _NewitemsState extends State<Newitems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No new items found"));
            }

            final allProducts = snapshot.data!.docs;
            final filteredProducts = allProducts.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['gender'] == 'Women';
            }).toList();

            if (filteredProducts.isEmpty) {
              return const Center(child: Text("No new items found for Women"));
            }

            return GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final data = filteredProducts[index].data() as Map<String, dynamic>;

                final product = Product( 
                  id: allProducts[index].id,
                  name: data['title'] ?? 'No Title',
                  image: data['imageUrl'] ?? '',
                  price: data['price'].toString(),
                  description: data['description'] ?? 'No Description',
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: product,
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: product.image.isNotEmpty
                                ? Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(child: Icon(Icons.broken_image)),
                                  )
                                : const Center(child: Icon(Icons.image_not_supported)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "₹${product.price}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}