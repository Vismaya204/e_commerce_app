import 'package:flutter/material.dart';

class Foregotpassword extends StatefulWidget {
  const Foregotpassword({super.key});

  @override
  State<Foregotpassword> createState() => _ForegotpasswordState();
}

class _ForegotpasswordState extends State<Foregotpassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [SizedBox(height: 20),
            Text("Forgot password",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),), SizedBox(height: 20),
            Text("Please enter your email to receive a link to create a new password via email"),SizedBox(height: 20),
            TextFormField(controller: emailController,
            validator: (value) {
              if(value==null || value.isEmpty){
                return "Please enter email";
              }
              return null;
            },
            
              decoration: InputDecoration(labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(height: 50,width: double.infinity,
                child: ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 39, 26),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text("SEND"),
                ),
              ),
            ),SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
