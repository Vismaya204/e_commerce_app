import 'package:flutter/material.dart';

class PaymentCart extends StatefulWidget {
  const PaymentCart({super.key});

  @override
  State<PaymentCart> createState() => _PaymentCartState();
}

class _PaymentCartState extends State<PaymentCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(floatingActionButton: FloatingActionButton(
      onPressed: () {
      
    },child: Icon(Icons.add),),
      appBar: AppBar(
        title: Text(
          "Payment methods",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Your payment cards",
            style: TextStyle( fontSize: 20),
          ),
          SizedBox(height: 10),
          SizedBox(width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset("assets/payimg.jpeg"),
            ),
          ),
        ],
      ),
    );
  }
}
