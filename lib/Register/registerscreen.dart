import 'package:e_commerce_app/Register/user_register.dart';
import 'package:e_commerce_app/home/allproducts.dart';
import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/login.dart';
import 'package:flutter/material.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 48, 34),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(height: 48,width: 343,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Text("Sign up"),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 48,width: 343,
              child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
