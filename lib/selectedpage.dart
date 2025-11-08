import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/bag/mybag.dart';
import 'package:e_commerce_app/favourite/favourite_list.dart';
import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/profile/myprofile.dart';
import 'package:e_commerce_app/service.dart';
import 'package:e_commerce_app/shop/categories.dart';
import 'package:e_commerce_app/shop/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  final Set<String>? initialFavorites;
  final List<Map<String, dynamic>>? initialCartItems;

  const Pages({
    super.key, 
    this.initialFavorites,
    this.initialCartItems,
  });

  // ✅ allow other screens to access this state
  static PagesState? of(BuildContext context) =>
      context.findAncestorStateOfType<PagesState>();

  @override
  State<Pages> createState() => PagesState();
}

class PagesState extends State<Pages> {
  late Set<String> favoriteIds;
  List<DocumentSnapshot> allProductsSnapshot = [];
  late List<Map<String, dynamic>> cartItems;
  int index = 0;

  @override
  void initState() {
    super.initState();
    favoriteIds = widget.initialFavorites ?? {};
    cartItems = widget.initialCartItems ?? [];
  }

  void updateProducts(List<DocumentSnapshot> products) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          allProductsSnapshot = products;
        });
      }
    });
  }

  // Toggle favorite with persistence
  Future<void> toggleFavorite(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isFavorite = favoriteIds.contains(productId);
    
    try {
      final favRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');
          
      if (!isFavorite) {
        await favRef.doc(productId).set({
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          favoriteIds.add(productId);
        });
      } else {
        await favRef.doc(productId).delete();
        setState(() {
          favoriteIds.remove(productId);
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // 🛒 Function to add product to cart with persistence
  Future<void> addToCart(Map<String, dynamic> product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');
          
      await cartRef.doc(product['id']).set({
        ...product,
        'quantity': 1,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        // Check if product is already in cart
        final existingIndex = cartItems.indexWhere((item) => item['id'] == product['id']);
        if (existingIndex >= 0) {
          cartItems[existingIndex] = product;
        } else {
          cartItems.add(product);
        }
      });
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Add to cart and navigate to bag
  Future<void> addToCartAndNavigate(Map<String, dynamic> product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');
          
      await cartRef.doc(product['id']).set({
        ...product,
        'quantity': 1,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        // Check if product is already in cart
        final existingIndex = cartItems.indexWhere((item) => item['id'] == product['id']);
        if (existingIndex >= 0) {
          cartItems[existingIndex] = product;
        } else {
          cartItems.add(product);
        }
      });

      // Switch to the bag tab
      setState(() {
        index = 2; // Index of the bag tab
      });
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Remove from cart with persistence
  Future<void> removeFromCart(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .delete();

      setState(() {
        cartItems.removeWhere((item) => item['id'] == productId);
      });
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Widget buildFavouriteScreen() {
    final favouriteProducts = allProductsSnapshot
        .where((doc) => favoriteIds.contains(doc.id))
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product(
            id: doc.id,
            name: data['title'] ?? 'No Title',
            image: data['imageUrl'] ?? '',
            price: data['price'].toString(),
            description: data['description'] ?? 'No Description',
          );
        })
        .toList();

    return FavouriteList(favourites: favouriteProducts);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Home(
        favoriteIds: favoriteIds,
        onProductsLoaded: updateProducts,
      ),
      const Categories(),
      Bag(selectedProducts: cartItems), // ✅ uses shared cart list
      buildFavouriteScreen(),
      const Myprofile(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        selectedItemColor: const Color.fromARGB(255, 222, 39, 26),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Shop"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "Bag"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
