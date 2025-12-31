class ProductEntity {
  final String name;
  final int price;
  final String description;

  final String? imageUrl;
  final String? imagePath;

  const ProductEntity({
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    this.imagePath
  });
}
