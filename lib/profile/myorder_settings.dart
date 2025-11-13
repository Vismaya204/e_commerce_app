import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ordersettings extends StatefulWidget {
  const Ordersettings({super.key});

  @override
  State<Ordersettings> createState() => _OrdersettingsState();
}

class _OrdersettingsState extends State<Ordersettings> {
  final TextEditingController name = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedData();
    });
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    name.text = prefs.getString('name') ?? '';
    dob.text = prefs.getString('dob') ?? '';
    pass.text = prefs.getString('pass') ?? '';
    address.text = prefs.getString('address') ?? '';

    
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name.text);
    await prefs.setString('dob', dob.text);
    await prefs.setString('pass', pass.text);
    await prefs.setString('address', address.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Personal Information", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Full name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dob,
              decoration: InputDecoration(
                hintText: "Date of birth",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pass,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: address,
              decoration: InputDecoration(
                hintText: "Address",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                  foregroundColor: Colors.white,
                ),
                onPressed: saveData,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}