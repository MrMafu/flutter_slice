class Food {
  final String name;
  final double price;
  final FoodCategory? category;
  final String image;
  final DateTime createdAt;

  Food({
    required this.name,
    required this.price,
    required this.image,
    this.category,
    required this.createdAt,
  });

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(
      name: data['nama_produk'] as String,
      price: (data['harga'] as num).toDouble(),
      image: data['image'] as String,
      category: data['food_category'] != null
        ? FoodCategory.fromMap(data['food_category'] as Map<String, dynamic>)
        : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_produk': name,
      'harga': price,
      'image': image,
      'food_category_id': category?.id,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
class FoodCategory {
  int? id;
  final String name;

  FoodCategory({
    this.id,
    required this.name,
  });

  factory FoodCategory.fromMap(Map<String, dynamic> data) {
    return FoodCategory(
      id: data['id'],
      name: data['nama_kategori'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kategori': name,
    };
  }
}