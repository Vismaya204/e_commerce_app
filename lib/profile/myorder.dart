import 'package:flutter/material.dart';

class Myorder extends StatefulWidget {
  const Myorder({super.key});

  @override
  State<Myorder> createState() => _MyorderState();
}

class _MyorderState extends State<Myorder> {
  final List<String> orders = [
    "Delivered",
    "Processing",
    "Cancelled",
  ];

  String selectedOrder = "Delivered"; // default selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ),

            // 📝 Title
            const Text(
              "My Orders",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🏷️ Tab Bar
            SizedBox(
              height: 50,
              child: Row(
                children: orders.map((order) {
                  final isSelected = order == selectedOrder;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOrder = order;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            order,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color.fromARGB(255, 219, 48, 34)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              height: 2,
                              width: 20,
                              color: const Color.fromARGB(255, 219, 48, 34),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 📦 Placeholder for order list
            Expanded(
              child: Center(
                child: Text(
                  "Showing: $selectedOrder orders",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}