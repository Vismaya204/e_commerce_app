import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/bag/add_shipping_address.dart';
import 'package:e_commerce_app/bag/mybag_promo_code.dart';
import 'package:e_commerce_app/bag/payment_cart.dart';
import 'package:e_commerce_app/bag/shipping_address.dart';
import 'package:e_commerce_app/profile/myorder_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/profile/myorder.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  String userName = '';
  String userEmail = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

 Future<void> fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      print("Fetched user data by email: $data");

      setState(() {
        userEmail = user.email ?? '';
        userName = data['Name'] ?? 'No Name';
        isLoading = false;
      });
    } else {
      print("No user document found for email: ${user.email}");
      setState(() {
        userEmail = user.email ?? '';
        userName = 'No Name';
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "My Profile",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    userEmail,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("My Orders"),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Myorder(),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                 ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Shipping Address"),
                  trailing: GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddShippingAddress(),));
                  },child: Icon(Icons.arrow_forward_ios)),
                  
                  
                ),
                 ListTile(
                  leading: Icon(Icons.payment),
                  title: Text("Payment Methods"),
                  trailing: GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>PaymentCart() ,));
                  },child: Icon(Icons.arrow_forward_ios)),
                ),
                 ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Promocode"),
                  trailing: GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PromoCode(),));
                  },child: Icon(Icons.arrow_forward_ios)),
                ),
                 ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  trailing: GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Ordersettings(),));
                  },child: Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
    );
  }
}