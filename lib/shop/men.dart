import 'package:e_commerce_app/shop/accesorieswomen.dart';
import 'package:e_commerce_app/shop/clothesmen.dart';
import 'package:e_commerce_app/shop/mennew.dart';
import 'package:e_commerce_app/shop/shoesmen.dart';
import 'package:e_commerce_app/shop/shoewomen.dart';
import 'package:e_commerce_app/shop/womens_new.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Men extends StatefulWidget {
  const Men({super.key});

  @override
  State<Men> createState() => _MenState();
}

class _MenState extends State<Men> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 219, 48, 34),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 96,
                    child: Text(
                      "SUMMER SALE\nUp to 50% off",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),SizedBox(height: 20,),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Men_new() ,));
                      },
                  child: Card(
                    child: Row(
                      children: [
                       Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22,width: 40,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "New",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(width: 172),
                        Image.asset("assets/new.png"),
                      ],
                    ),
                  ),
                ),
              ), 
              SizedBox(height: 20
              ,),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Clothesmen(),));
                      },
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22,width: 67,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Clothes",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(width: 145),
                        Image.asset("assets/clothes.png"),
                      ],
                    ),
                  ),
                ),
              ),SizedBox(height: 20
              ,),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Shoesmen(),));
                      },
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22,width: 67,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Shoes",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(width: 145),
                        Image.asset("assets/shoesimg.jpg"),
                      ],
                    ),
                  ),
                ),
              ),SizedBox(height: 20
              ,),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) =>Accesorieswomen(),));
                },
                  child: Card(
                    child: Row(
                      children: [
                       
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22,width: 100,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Accesories",
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(width: 110),
                        Image.asset("assets/accesories.png"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}