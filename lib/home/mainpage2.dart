import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/home/allproducts.dart';
import 'package:e_commerce_app/shop/categories.dart';
import 'package:e_commerce_app/shop/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Salepage extends StatefulWidget {
  const Salepage({super.key});

  @override
  State<Salepage> createState() => _SalepageState();
}

class _SalepageState extends State<Salepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 196,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Small banner.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 136,
                  left: 16,
                  child: Text(
                    "Street clothes",
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                "Sale",
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ), subtitle: Text(
                "super summer sale",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: GestureDetector(
                child: Text("view all", style: TextStyle(color: Colors.grey)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
            ),StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No new clothes found"));
    }

    final clothesProducts = snapshot.data!.docs;

    final filteredProduct = clothesProducts.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['category'] == 'Clothes';
    }).toList();

    if (filteredProduct.isEmpty) {
      return const Center(child: Text("No new items found for Clothes"));
    }

    return SizedBox(
      height: 280, // ✅ Fixed height for horizontal scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // ✅ Horizontal scrolling
        itemCount: filteredProduct.length,
        itemBuilder: (context, index) {
          final data = filteredProduct[index].data() as Map<String, dynamic>;
           final productfetch = Product( id: filteredProduct[index].id,
                  name: data['title'] ?? 'No Title',
                  image: data['imageUrl'] ?? '',
                  price: data['price'].toString(),
                  description: data['description'] ?? 'No Description',
                );


          return Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: GestureDetector(onTap: () {
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
                        child:productfetch.image.isNotEmpty
                            ? Image.network(
                                productfetch.image,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "₹${productfetch.price.toString()}",
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
            ),
          );
        },
      ),
    );
  },
),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                "New",
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "You've never seen before!",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: GestureDetector(
                child: Text("view all", style: TextStyle(color: Colors.grey)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
            ),
            SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
       // ✅ Filter by category
      .orderBy('createdAt', descending: true)  // ✅ Sort by newest
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No new clothes found"));
    }

    final clothesProducts = snapshot.data!.docs;
     final filteredProduct = clothesProducts.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['category'] == 'Clothes'; // ✅ Case-sensitive
            }).toList();

            if (filteredProduct.isEmpty) {
              return const Center(child: Text("No new items found for Clothes"));
            }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clothesProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final data = filteredProduct[index].data() as Map<String, dynamic>;
        final productfetch = Product( id: filteredProduct[index].id,
                  name: data['title'] ?? 'No Title',
                  image: data['imageUrl'] ?? '',
                  price: data['price'].toString(),
                  description: data['description'] ?? 'No Description',
                );

        return GestureDetector(onTap: () {
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
                            productfetch.image,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "₹${productfetch.price.toString()}",
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
           
          ],
        ),
      ),
    );
  }
}
