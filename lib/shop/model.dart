class Product {
  final String id;
  final String image;
  final String name;
  final String price;
  final String description;
   bool isFavorite;
  
 
  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    this.isFavorite=false
  });
}
