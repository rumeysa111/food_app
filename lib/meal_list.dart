import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/meal_model.dart';
import 'meal_detail.dart';

class MealList extends StatefulWidget {
  final String categoryName;

  MealList({required this.categoryName});

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        meals = (data['meals'] as List).map((meal) => Meal.fromJson(meal)).toList();
      });
    } else {
      throw Exception('Yemekler yüklenemedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Yemekleri'),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MealDetail(mealId: meals[index].idMeal),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                shadowColor: Colors.orangeAccent.withOpacity(0.4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          meals[index].strMealThumb,
                          fit: BoxFit.cover,
                          height: 130, // Görüntü yüksekliğini ayarlayın
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              meals[index].strMeal,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
