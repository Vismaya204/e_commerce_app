import 'package:e_commerce_app/profile/myorder.dart';
import 'package:flutter/material.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "My Profile",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: CircleAvatar(child: Image(image: AssetImage(""))),
            title: Text(
              "Matilda Brown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "matildabrown @mail.com",
              style: TextStyle(color: Colors.grey,fontSize: 14),
            ),
            
          ),SizedBox(height: 30,),
          
             ListTile(
              leading: Icon(Icons.person),
              title: Text("My Orders",),subtitle: Text(""),
              trailing: GestureDetector(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>Myorder(),));
              },child: Icon(Icons.arrow_forward_ios)),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Shipping Address",),subtitle: Text(""),
              trailing: Icon(Icons.arrow_forward_ios),
            ),ListTile(
              leading: Icon(Icons.payment),
              title: Text("Payment Methods",),subtitle: Text(""),
              trailing: Icon(Icons.arrow_forward_ios),
            ),ListTile(
              leading: Icon(Icons.favorite),
              title: Text("promocode",),subtitle: Text(""),
              trailing: Icon(Icons.arrow_forward_ios),
            ),ListTile(
              leading: Icon(Icons.settings),
              title: Text("My reviews",),subtitle: Text(""),
              trailing: Icon(Icons.arrow_forward_ios),
            ),ListTile(
              leading: Icon(Icons.help),
              title: Text("settings",),subtitle: Text(""),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          
        ],
      ),
    );
  }
}
