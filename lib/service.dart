import 'dart:convert';
import 'dart:typed_data';
import 'package:e_commerce_app/home/allproducts.dart';
import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/selectedpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

Future<String?> uploadProductImage({
  required XFile? imageFile,
  required Uint8List? webImage,
}) async {
  const cloudName = 'dc0ny45w9';
  const uploadPreset = 'productimg';

  try {
    await requestStoragePermission();

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;

    if (webImage != null) {
      request.files.add(http.MultipartFile.fromBytes('file', webImage, filename: 'product.png'));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    } else {
      return null;
    }

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
     print('Cloudinary Response: ${responseData.body}'); 

    if (response.statusCode == 200) {
      var data = json.decode(responseData.body);
      return data['secure_url'];
    } else {
     
      return null;
    }
  } catch (e) {
    print("Upload error: $e");
    return null;
  }
}

Future<void> addProduct({
  required String title,
  required String description,
  required double price,
  required String category,
  required XFile? imageFile,
  required Uint8List? webImage,
  required BuildContext context,
}) async {
  try {
    String? imageUrl = await uploadProductImage(
      imageFile: imageFile,
      webImage: webImage,
    );

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("products").add({
      "title": title,
      "description": description,
      "price": price,
      "category": category,
      "productimage": imageUrl ??'',
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Product added successfully")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

Future<void> registerUser({
  required String name,
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
      "Name": name,
      "Email": email,
      "Role": "user",
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("user created successfully")));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}



// Favorites management
Future<void> toggleFavorite({
  required String userId,
  required String productId,
  required bool isFavorite,
}) async {
  final userFavoritesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favorites');
      
  if (isFavorite) {
    await userFavoritesRef.doc(productId).set({
      'timestamp': FieldValue.serverTimestamp(),
    });
  } else {
    await userFavoritesRef.doc(productId).delete();
  }
}

Future<Set<String>> getFavorites(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favorites')
      .get();
      
  return snapshot.docs.map((doc) => doc.id).toSet();
}

// Cart management
Future<void> addToCart({
  required String userId,
  required Map<String, dynamic> product,
  required int quantity,
}) async {
  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart');
      
  await cartRef.doc(product['id']).set({
    ...product,
    'quantity': quantity,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<void> removeFromCart({
  required String userId,
  required String productId,
}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(productId)
      .delete();
}

Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .get();
      
  return snapshot.docs.map((doc) => {
    'id': doc.id,
    ...doc.data(),
  }).toList();
}

Future<void> login({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    if (email == "admin@gmail.com" && password == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Allproducts()),
      );
      return; // prevent further execution
    }

    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Load favorites and cart items after login
    if (userCredential.user != null) {
      final userId = userCredential.user!.uid;
      final favorites = await getFavorites(userId);
      final cartItems = await getCartItems(userId);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Pages(
          initialFavorites: favorites,
          initialCartItems: cartItems,
        )),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}