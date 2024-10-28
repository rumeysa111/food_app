import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart';

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((category) => Category(
        strCategory: category['strCategory'],
        strCategoryThumb: category['strCategoryThumb'],
        name: category['strCategory'], // `name` alanı `strCategory` ile aynı olabilir
      ))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
