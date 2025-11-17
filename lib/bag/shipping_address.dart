import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  String userName = '';
  String address = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadShippingAddress();
  }

  Future<void> loadShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
      address = prefs.getString('address') ?? '';
      nameController.text = userName;
      addressController.text = address;
    });
  }

  Future<void> saveShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('address', addressController.text);
    setState(() {
      userName = nameController.text;
      address = addressController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Shipping address saved"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Enter your name"),
            ),
            const SizedBox(height: 20),
            const Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(hintText: "Enter your address"),
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveShippingAddress,
              child: const Text("Save Address"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text("Saved Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Name: $userName", style: const TextStyle(fontSize: 16)),
            Text("Address: $address", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}