import 'package:e_commerce_app/home/mainpage2.dart';
import 'package:e_commerce_app/selectedpage.dart';
import 'package:e_commerce_app/shop/model.dart';
import 'package:flutter/material.dart';

class FavouriteList extends StatefulWidget {
  final List<Product> favourites;

  const FavouriteList({super.key, required this.favourites});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  // ✅ Handle back press to go to root screen
  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Pages()), // your main/root screen
      (route) => false,
    );
    return false; // prevent normal back pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // ✅ intercept system back press
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favourites"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // ✅ AppBar back button also goes to root
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Pages()),
                (route) => false,
              );
            },
          ),
        ),
        body: widget.favourites.isEmpty
            ? const Center(child: Text("No favourites yet"))
            : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: widget.favourites.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = widget.favourites[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(10)),
                              child: product.image.isNotEmpty
                                  ? Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Center(child: Icon(Icons.broken_image)),
                                    )
                                  : const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
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
                    );
                  },
                ),
              ),
      ),
    );
  }
}
