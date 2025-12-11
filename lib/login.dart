import 'package:e_commerce_app/foregotpassword.dart';
import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Foregotpassword()),
                    );
                  },
                  child: Text("Forgot password?"),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 48,width: 343,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 222, 39, 26),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  login(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    context: context,
                  );
                  
                },
                child: Text("LOGIN"),
              ),
            ),
            SizedBox(height: 30),
            Text("Or login with social account"),
             Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    CircleAvatar(
      radius: 20, // smaller radius looks cleaner
      backgroundImage: AssetImage("assets/gogl.jpg"), // fixed path
    ),
    SizedBox(width: 40), // spacing between icons
    CircleAvatar(
      radius: 30,
      backgroundImage: AssetImage("assets/facebookimg.png"), // correct path
    ),
  ],
),
          ],
        ),
      ),
    );
  }
}
