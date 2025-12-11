import 'package:e_commerce_app/home/mainpage2.dart';
import 'package:e_commerce_app/selectedpage.dart';
import 'package:e_commerce_app/shop/kid.dart';
import 'package:e_commerce_app/shop/men.dart';
import 'package:e_commerce_app/shop/women.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  List<String> categories = ['Women', 'Men', 'Kid'];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        final category = categories[tabController.index];
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle Android/iOS back press
      onWillPop: () async {
        // Navigate to the root screen instead of popping
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Pages()),
          (route) => false,
        );
        return false; // prevent normal pop
      },
      child: Scaffold(
        appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 219, 48, 34),
          title: const Text("Categories",style: TextStyle(color: Colors.white),),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            controller: tabController,
            tabs: categories
                .map(
                  (category) => Tab(
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(fontSize: 16,color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children:  [
            Women(),
            Men(),
            Kid(),
          ],
        ),
      ),
    );
  }
}
