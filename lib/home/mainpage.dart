import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/home/mainpage2.dart';
import 'package:e_commerce_app/selectedpage.dart';
import 'package:e_commerce_app/shop/categories.dart';
import 'package:e_commerce_app/shop/detailpage.dart';
import 'package:e_commerce_app/shop/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final Set<String> favoriteIds;
  final Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>) onProductsLoaded;

  const Home({
    super.key,
    required this.favoriteIds,
    required this.onProductsLoaded,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _hasLoadedProducts = false; // ✅ Prevent repeated callbacks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Banner Section
              Stack(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/Image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    bottom: 60,
                    child: Text(
                      "Fashion\nSale",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    bottom: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Salepage()),
                        );
                      },
                      child: const Text("Check"),
                    ),
                  ),
                ],
              ),

              // 🔹 Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "You've never seen it before!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Categories()),
                        );
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Product Grid (Stream from Firestore)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Text("No new items found"),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // ✅ Call onProductsLoaded only once
                  if (!_hasLoadedProducts) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) widget.onProductsLoaded(docs);
                    });
                    _hasLoadedProducts = true;
                  }

                  final products = docs.map((doc) {
                    final data = doc.data();
                    return Product(
                      id: doc.id,
                      name: data['title'] ?? 'No Title',
                      image: data['imageUrl'] ?? '',
                      price: data['price'].toString(),
                      description: data['description'] ?? 'No Description',
                      isFavorite: widget.favoriteIds.contains(doc.id),
                    );
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isFav = widget.favoriteIds.contains(product.id);

                        return GestureDetector(
                          onTap: () {
                            final state = context.findAncestorStateOfType<PagesState>();
                            if (state != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailproduct(
                                    pagesState: state,
                                    product: product,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          product.image,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stack) =>
                                              const Center(
                                            child: Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: IconButton(
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFav ? Colors.red : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isFav) {
                                                widget.favoriteIds.remove(product.id);
                                              } else {
                                                widget.favoriteIds.add(product.id);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${product.price}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
