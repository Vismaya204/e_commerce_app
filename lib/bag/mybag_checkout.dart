import 'package:e_commerce_app/bag/success.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MybagCheckout extends StatefulWidget {
  final List<Map<String, dynamic>> cartData;
  const MybagCheckout({super.key, required this.cartData});

  @override
  State<MybagCheckout> createState() => _MybagCheckoutState();
}

class _MybagCheckoutState extends State<MybagCheckout> {
  String selectedPayment = 'Gpay';
  String userName = '';
  String shippingAddress = '';

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
  }

  double getTotalAmount() {
    return widget.cartData.fold<double>(
      0,
      (sum, item) =>
          sum +
          ((double.tryParse(item['price'].toString()) ?? 0) *
              (item['quantity'] as int)),
    );
  }

  Widget buildPaymentTile({
    required String value,
    required String title,
    required String subtitle,
    required String assetPath,
  }) {
    return InkWell(
      onTap: () => setState(() => selectedPayment = value),
      child: ListTile(
        leading: Image.asset(assetPath, width: 80, height: 50),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
        trailing: Radio<String>(
          value: value,
          groupValue: selectedPayment,
          onChanged: (val) => setState(() => selectedPayment = val!),
          activeColor: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = getTotalAmount();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Shipping Address", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("$userName\n$shippingAddress", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            const Text("Payment Method", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildPaymentTile(
              value: 'Gpay',
              title: 'Gpay',
              subtitle: '**** **** **** ****',
              assetPath: 'assets/gpayimg.jpeg',
            ),
            buildPaymentTile(
              value: 'Mastercard',
              title: 'Mastercard',
              subtitle: '**** **** **** 2121',
              assetPath: 'assets/mastercard.png',
            ),
            buildPaymentTile(
              value: 'Visa',
              title: 'Visa',
              subtitle: '**** **** **** 0004',
              assetPath: 'assets/visalogo.png',
            ),

            const SizedBox(height: 30),
            const Text("Total Amount", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Success()),);
                  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Order submitted successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Success()));
      });

                },
                child: const Text("SUBMIT ORDER", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}