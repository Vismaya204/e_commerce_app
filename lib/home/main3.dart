import 'package:e_commerce_app/home/mainpage.dart';
import 'package:e_commerce_app/shop/categories.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mainpage3 extends StatelessWidget {
  const Mainpage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // ✅ Scrollable layout
        child: Column(
          children: [
            // 🔴 Top Banner
            Stack(
              children: [
                GestureDetector(onTap: () {
              //    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
                },
                  child: Container(
                    height: 366,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/picimg1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 305,
                  left: 110,
                  child: Text(
                    "New Collection",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // 🔴 Summer Sale + Image side by side
            Row(
              children: [
                Container(
                  height: 186,
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Categories()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Summer\nSale",
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 186,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/picimg3.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // 🔴 Full-width image (picimg2)
            Container(
              height: 374,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/picimg2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}