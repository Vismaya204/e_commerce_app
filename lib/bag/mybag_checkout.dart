import 'package:e_commerce_app/bag/payment_cart.dart';
import 'package:e_commerce_app/bag/success.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MybagCheckout extends StatefulWidget {
  const MybagCheckout({super.key});

  @override
  State<MybagCheckout> createState() => _MybagCheckoutState();
}

class _MybagCheckoutState extends State<MybagCheckout> {
  String shippingAddress = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'No name found';
      shippingAddress = prefs.getString('address') ?? 'No address found';
    });

    print("Loaded name: $userName");
    print("Loaded address: $shippingAddress");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "$userName\n$shippingAddress",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Change",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>PaymentCart() ,));
            },
              child: Row(
                children: [
                  Image.asset(
                    "assets/mastercard.png",
                    height: 50,
                    width: 170,
                  ),
                  SizedBox(width: 10),
                  Text("**** **** **** 3020"),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Delivery method",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXdrfRCUne0fWQ56eT9QTR8ng2cRpDADGdKg&s",
                  width: 80,
                  height: 80,
                ),
                Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-hD3YaPZwj7Ej3r_nn0B351-Sl_laFdnUCA&s",
                  width: 80,
                  height: 80,
                ),
                Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlKj5KTGwEUqAx7esPWBSfzxrXOBeNUMFVCw&s",
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Success()),
                  );
                },
                child: Text("SUBMIT ORDER"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}