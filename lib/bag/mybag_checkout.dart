import 'package:e_commerce_app/bag/success.dart';
import 'package:flutter/material.dart';

class MybagCheckout extends StatefulWidget {
  const MybagCheckout({super.key});

  @override
  State<MybagCheckout> createState() => _MybagCheckoutState();
}

class _MybagCheckoutState extends State<MybagCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Shipping Address",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [Text("")]),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Payment",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),SizedBox(width: 170),Text(
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
                  Row(
                    children: [
                      Image.asset("assets/mastercard.png", height: 50, width: 170), SizedBox(width: 10),
              Text("**** **** **** 3020"),
                    ],
                  ),
                ],
              ), 
              
              
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Delivery method",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset("assets/"),
             
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
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
        ],
      ),
    );
  }
}
