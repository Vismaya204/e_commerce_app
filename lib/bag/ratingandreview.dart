import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ratingandreview extends StatefulWidget {
  final String productId;
  final String userEmail;

  const Ratingandreview({
    super.key,
    required this.productId,
    required this.userEmail,
  });

  @override
  State<Ratingandreview> createState() => _RatingandreviewState();
}

class _RatingandreviewState extends State<Ratingandreview> {
  TextEditingController typeController = TextEditingController();
  double rating = 0;

  /// 🔥 Add Review to Firestore
  Future<void> addReviewToFirestore(String reviewText) async {
    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'productId': widget.productId,
        'userEmail': widget.userEmail,
        'comment': reviewText,
        'rating': rating,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Review added successfully')),
      );

      typeController.clear();
      setState(() => rating = 0);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error adding review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Rating & Review",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ⭐ Rating Bar
            const Text(
              "Select Rating:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => rating = index + 1),
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                    size: 32,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            /// ✍️ Review Input
            TextFormField(
              controller: typeController,
              decoration: InputDecoration(
                hintText: "Write your review here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            /// 🚀 Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final reviewText = typeController.text.trim();
                  if (reviewText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('⚠️ Please enter a review')),
                    );
                    return;
                  }
                  if (rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('⚠️ Please select a rating')),
                    );
                    return;
                  }

                  addReviewToFirestore(reviewText);
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
