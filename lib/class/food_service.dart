import 'package:supabase_flutter/supabase_flutter.dart';
import 'food.dart';

class FoodService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<FoodCategory>> fetchCategories() async {
    final response = await supabase.from('food_category').select();
    if (response.isEmpty) {
      throw Exception("No categories found");
    }
    return (response as List).map((item) => FoodCategory.fromMap(item as Map<String, dynamic>)).toList();
  }

  Future<List<Food>> fetchFoods() async {
    final response = await supabase
        .from('food')
        .select('*, food_category(id, nama_kategori)');
    if (response.isEmpty) {
      throw Exception("No foods found");
    }
    return (response as List).map((item) => Food.fromMap(item as Map<String, dynamic>)).toList();
  }

  // Insert food data
  Future<void> insertFood(Food food) async {
    await supabase.from('food').insert([food.toMap()]);
    // if (response.error != null) { // Updated error check
    //   print('Error inserting food: ${response.error!.message}');
    //   throw Exception("Failed to insert food: ${response.error!.message}");
    // } else {
    //   print('Food inserted successfully');
    // }
  }

  Future<void> deleteFoodByName(String name) async {
    final response = await supabase.from('food').delete().eq('nama_produk', name);
    
    if (response == null || (response is List && response.isEmpty)) {
      throw Exception("No rows were deleted. Food with name '$name' might not exist.");
    }

    print('Delete food with name: $name');
  }
}