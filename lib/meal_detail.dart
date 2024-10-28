import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetail extends StatefulWidget {
  final String mealId;

  MealDetail({required this.mealId});

  @override
  _MealDetailState createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  Map<String, dynamic>? meal;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  Future<void> fetchMealDetail() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        meal = data['meals'][0];
      });
    } else {
      throw Exception('Yemek detayları yüklenemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal!['strMeal']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ok simgesi
          onPressed: () {
            Navigator.pop(context); // Geri git
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal!['strMealThumb']),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent, // Arka plan rengi
                borderRadius: BorderRadius.circular(15.0), // Kenar yuvarlama
                border: Border.all(color: Colors.deepOrange, width: 2), // Çerçeve rengi ve kalınlığı
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Malzemeler:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            ...List.generate(20, (index) {
              final ingredient = meal!['strIngredient${index + 1}'];
              final measure = meal!['strMeasure${index + 1}'];
              if (ingredient != '' && ingredient != null) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.orange[100], // Arka plan rengi
                    borderRadius: BorderRadius.circular(10.0), // Kenar yuvarlama
                    border: Border.all(color: Colors.deepOrange, width: 1), // Çerçeve rengi ve kalınlığı
                  ),
                  margin: EdgeInsets.only(bottom: 8.0), // Alt boşluk
                  padding: EdgeInsets.all(8.0), // İç boşluk
                  child: Text('$ingredient - $measure'),
                );
              }
              return SizedBox.shrink();
            }),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent, // Arka plan rengi
                borderRadius: BorderRadius.circular(15.0), // Kenar yuvarlama
                border: Border.all(color: Colors.deepOrange, width: 2), // Çerçeve rengi ve kalınlığı
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tarif:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[55], // Arka plan rengi
                borderRadius: BorderRadius.circular(10.0), // Kenar yuvarlama
                border: Border.all(color: Colors.deepOrange, width: 5), // Çerçeve rengi ve kalınlığı
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(meal!['strInstructions']),
            ),
          ],
        ),
      ),
    );
  }
}
