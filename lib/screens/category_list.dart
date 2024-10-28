import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../meal_list.dart';
import '../models/category_model.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categories = []; // Kategori listesi

  @override
  void initState() {
    super.initState();
    fetchCategories(); // API'den verileri çek
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php')); // API URL'sini buraya yazın

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .where((category) => category.strCategory != 'Pork') // "Pork" kategorisini hariç tut
            .toList();
      });
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }

  // Kategori isimlerini Türkçe'ye çeviren fonksiyon
  String translateCategoryName(String categoryName) {
    final Map<String, String> translations = {
      'Beef': 'Dana',
      'Chicken': 'Tavuk',
      'Dessert': 'Tatlı',
      'Goat': 'Keçi',
      'Lamb': 'Kuzu',
      'Miscellaneous': 'Diğer',
      'Seafood': 'Deniz Ürünleri',
      'Side': 'Yan Yemek',
      'Vegan': 'Vegan',
      'Vegetarian': 'Vejetaryen',
      'Pasta': 'Makarna',
      'Starter': 'Başlangıç',
      'Breakfast': 'Kahvaltı',
      // Diğer kategori isimleri için çevirileri buraya ekleyebilirsiniz.
    };
    return translations[categoryName] ?? categoryName; // Eğer çeviri yoksa orijinal ismi döner
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          child: Card(
            color: Colors.orange[100], // Renk burada sabitlendi
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Kartlara kenar yuvarlama
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0), // İçeriğin üst ve alt boşluğunu ayarladık
              title: Text(
                translateCategoryName(categories[index].strCategory), // Kategori ismini Türkçe'ye çevir
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              leading: CircleAvatar(
                radius: 45, // Görselin boyutunu burada ayarlayabilirsiniz
                backgroundImage: NetworkImage(categories[index].strCategoryThumb), // Kategori resmi
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealList(categoryName: categories[index].strCategory), // Tıklanınca yemek listesini göster
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
