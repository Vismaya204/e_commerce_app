import 'package:e_commerce_app/Register/registerscreen.dart';
import 'package:e_commerce_app/Register/user_register.dart';
import 'package:e_commerce_app/bag/mybag.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/foregotpassword.dart';
import 'package:e_commerce_app/home/allproducts.dart';
import 'package:e_commerce_app/home/main3.dart';
import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/login.dart';
import 'package:e_commerce_app/profile/myorder.dart';
import 'package:e_commerce_app/profile/myprofile.dart';
import 'package:e_commerce_app/selectedpage.dart';
import 'package:e_commerce_app/shop/categories.dart';
import 'package:e_commerce_app/shop/detailpage.dart';
import 'package:e_commerce_app/shop/women.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Registerscreen(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => Detailproduct(
              product: args['product'],
              parentContext: args['parentContext'], pagesState: null,
            ),
          );
        }
        return null;
      },
    );
  }
}
