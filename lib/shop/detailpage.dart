import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/bag/add_shipping_address.dart';
import 'package:e_commerce_app/bag/ratingandreview.dart';
import 'package:e_commerce_app/selectedpage.dart' hide Pages;
import 'package:e_commerce_app/shop/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 // 👈 add this import

class Detailproduct extends StatefulWidget {
  final PagesState pagesState;
  final Product product;

  const Detailproduct({
    super.key,
    required this.pagesState,
    required this.product,
  });

  @override
  State<Detailproduct> createState() => _DetailproductState();
}

class _DetailproductState extends State<Detailproduct> {
  List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  String? selectedSize;
  List<String> colors = ['Black', 'Blue', 'Red', 'Orange', 'Green', 'Yellow'];
  String? selectedColor;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ Product Image & Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.product.image,
                      width: double.infinity,
                      height: 444,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text("Size:", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                            hint: const Text("Select"),
                            value: selectedSize,
                            items: sizes.map((size) {
                              return DropdownMenuItem<String>(
                                value: size,
                                child: Text(size),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedSize = value),
                          ),
                          const SizedBox(width: 20),
                          const Text("Color:", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                            hint: const Text("Select"),
                            value: selectedColor,
                            items: colors.map((color) {
                              return DropdownMenuItem<String>(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedColor = value),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '₹${widget.product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🛒 ADD TO CART BUTTON (Fixed)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (selectedSize == null || selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select both size and color"),
                        ),
                      );
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please login to add items to cart")),
                      );
                      return;
                    }

                    // 👇 prepare product data
                    final selectedProduct = {
                      'id': widget.product.id,
                      'name': widget.product.name,
                      'price': widget.product.price,
                      'image': widget.product.image,
                      'size': selectedSize,
                      'color': selectedColor,
                    };

                    // Add to shared cart state
                    try {
                      await widget.pagesState.addToCartAndNavigate(selectedProduct);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to cart successfully")),
                      );
                      // Pop back to the previous screen after adding to cart
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error adding to cart: $e")),
                      );
                    }
                  },
                  child: const Text("ADD TO CART"),
                ),
              ),
            ),

            /// 🚚 Shipping info
            ListTile(
              title: const Text("Shipping info"),
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddShippingAddress(),
                  ),
                );
              },
            ),

            /// ⭐ Support & Review
            ListTile(
              title: const Text("Support & Review"),
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                final userEmail = FirebaseAuth.instance.currentUser?.email ??
                    'guest@example.com';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ratingandreview(
                      productId: widget.product.id,
                      userEmail: userEmail,
                    ),
                  ),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Customer Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            /// 🔥 Firestore Reviews Stream
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('productId', isEqualTo: widget.product.id)
                  // .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading reviews: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No reviews yet. Be the first to review!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final reviews = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final data =
                        reviews[index].data() as Map<String, dynamic>? ?? {};

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.grey),
                          title: Text(
                            data['userEmail'] ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: List.generate(
                                    (data['rating'] ?? 0).toInt(),
                                    (i) => const Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['comment'] ?? '',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
