// profile_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List recipes = [];
  bool isLoading = true;
  final String apiKey = '0725eb2bb23b48409fc367e5521514af'; // Senin API anahtarın
  List<TextEditingController> _commentControllers = [];
  List<int> selectedStars = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=$apiKey&number=2',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        recipes = data['recipes'].map((recipe) {
          return {
            'title': recipe['title'],
            'image': recipe['image'],
            'comment': '',
          };
        }).toList();
        _commentControllers =
            List.generate(recipes.length, (_) => TextEditingController());
        selectedStars = List.generate(recipes.length, (_) => 0);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.bell, size: 28),
            SizedBox(width: 30),
            FaIcon(FontAwesomeIcons.user, size: 28),
            SizedBox(width: 30),
            FaIcon(FontAwesomeIcons.envelope, size: 28),
          ],
        ),
        actions: [Container()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Denediğim Tarifler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Column(
                      children: [
                        Image.network(
                          recipes[index]['image'],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          recipes[index]['title'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        buildStarRow(index),
                        SizedBox(height: 5),
                        if (recipes[index]['comment'].isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              recipes[index]['comment'],
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                  _commentControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Yorumunuzu yazın...',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    recipes[index]['comment'] =
                                        _commentControllers[index]
                                            .text;
                                    _commentControllers[index].clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                                child: Text('Gönder'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: fetchRecipes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Tarif Ekle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Row buildStarRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedStars[index] = i + 1;
            });
          },
          child: Icon(
            Icons.star,
            color: i < selectedStars[index] ? Colors.orangeAccent : Colors.grey,
            size: 24.0,
          ),
        );
      }),
    );
  }
}
