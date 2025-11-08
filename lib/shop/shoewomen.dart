import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/shop/model.dart';
import 'package:flutter/material.dart';

class Shoes extends StatefulWidget {
  const Shoes({super.key});

  @override
  State<Shoes> createState() => _ShoesState();
}

class _ShoesState extends State<Shoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: 'Shoes').where('gender', isEqualTo: 'Women') // ✅ Filter by category only
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No shoes found"));
    }

    final products = snapshot.data!.docs;

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = products[index].data() as Map<String, dynamic>;
         final productfetch = Product( id: products[index].id,
                  name: data['title'] ?? 'No Title',
                  image: data['imageUrl'] ?? '',
                  price: data['price'].toString(),
                  description: data['description'] ?? 'No Description',
                );


        return GestureDetector( onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: productfetch,
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
                    child: productfetch.image.isNotEmpty
                        ? Image.network(
                           productfetch.image ,
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
                    productfetch.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "₹${productfetch.price.toString()}",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
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
),)
    );
  }
}