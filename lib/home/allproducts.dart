import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Allproducts extends StatefulWidget {
  const Allproducts({super.key});

  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts> {
  final TextEditingController productcontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController descriptioncontroller=TextEditingController();
  final picker = ImagePicker();
  File? image;
  Uint8List? webImage;
  bool loading = false;
  String? selectedCategory;

  final categories = [
   
    'Clothes',
    'Shoes',
    'Accessories',
  ];
 final genderOptions = ['Men', 'Women', 'Kid',];
String? selectedGender;

  // 📸 Pick image (Web + Mobile)
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          webImage = bytes;
          image = null;
        });
      } else {
        setState(() {
          image = File(picked.path);
          webImage = null;
        });
      }
    }
  }

  // 🧾 Request storage permission (for Android)
  Future<void> requestStoragePermission() async {
    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  // ☁️ Upload to Cloudinary
  Future<String?> uploadProductImage({
    required XFile? imageFile,
    required Uint8List? webImage,
  }) async {
    const cloudName = 'dc0ny45w9';
    const uploadPreset = 'productimg';

    try {
      await requestStoragePermission();

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;

      // Web upload
      if (webImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            webImage,
            filename: 'product.png',
          ),
        );
      }
      // Mobile upload
      else if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );
      } else {
        return null;
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var data = json.decode(responseData.body);
        print("✅ Cloudinary Upload Success: ${data['secure_url']}");
        return data['secure_url'];
      } else {
        print("❌ Cloudinary upload failed: ${responseData.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Upload error: $e");
      return null;
    }
  }

  // 🧩 Add product to Firestore
  Future<void> addProduct(BuildContext context) async {
    final title = productcontroller.text.trim();
    final price = double.tryParse(pricecontroller.text.trim()) ?? 0;

    if (title.isEmpty ||
        price <= 0 ||
        (image == null && webImage == null) ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields, select an image, and choose a category.",
          ),
        ),
      );
      return;
    }

    setState(() => loading = true);

    final imageUrl = await uploadProductImage(
      imageFile: image != null ? XFile(image!.path) : null,
      webImage: webImage,
    );

    if (imageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
      setState(() => loading = false);
      return;
    }  final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now());

    await FirebaseFirestore.instance.collection("products").add({
  "title": title,
  "price": price,
  "category": selectedCategory,
  "gender": selectedGender,
  "description": descriptioncontroller.text.trim(),
  "imageUrl": imageUrl,
  "createdAt":formattedDate,
});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Product added successfully")),
    );

    setState(() {
      productcontroller.clear();
      pricecontroller.clear();
      image = null;
      webImage = null;
      selectedCategory = null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: const Color.fromARGB(255, 219, 48, 34),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Product Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🖼️ Image Picker
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  image: (kIsWeb && webImage != null)
                      ? DecorationImage(
                          image: MemoryImage(webImage!),
                          fit: BoxFit.cover,
                        )
                      : (image != null)
                      ? DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (image == null && webImage == null)
                    ? const Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // 📝 Product Name
            TextFormField(
              controller: productcontroller,
              decoration: InputDecoration(
                hintText: "Product name",
                prefixIcon: const Icon(Icons.shopping_bag_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 💰 Price
            TextFormField(
              controller: pricecontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Price",
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(controller:descriptioncontroller ,
              decoration: InputDecoration(hintText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),SizedBox(height: 10,),


            // 🏷️ Category Selector
            InputDecorator(
              decoration: InputDecoration(
                hintText: "Select Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                itemBuilder: (context) {
                  return categories
                      .map(
                        (cat) =>
                            PopupMenuItem<String>(value: cat, child: Text(cat)),
                      )
                      .toList();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory ?? "Choose Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedCategory == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),const SizedBox(height: 10),

InputDecorator(
  decoration: InputDecoration(
    hintText: "Select Gender",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    prefixIcon: const Icon(Icons.person_outline),
  ),
  child: PopupMenuButton<String>(
    onSelected: (value) {
      setState(() {
        selectedGender = value;
      });
    },
    itemBuilder: (context) {
      return genderOptions
          .map((g) => PopupMenuItem<String>(value: g, child: Text(g)))
          .toList();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectedGender ?? "Choose Gender",
          style: TextStyle(
            fontSize: 16,
            color: selectedGender == null ? Colors.grey : Colors.black,
          ),
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    ),
  ),
),

            const SizedBox(height: 20),

            // ✅ Add Button
            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 48, 34),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => addProduct(context),
                    child: const Text("Add Product"),
                  ),
          ],
        ),
      ),
    );
  }
}
