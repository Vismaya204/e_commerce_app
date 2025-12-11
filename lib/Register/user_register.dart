import 'package:e_commerce_app/login.dart';
import 'package:e_commerce_app/service.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign up",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
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
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Already have an account? "),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 48,
              width: 343,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  registerUser(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                child: Text("SIGN UP"),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 48,
              width: 343,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                  foregroundColor: Colors.white,
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
            SizedBox(height: 30),
            Text("Or sign up with social account"),
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
