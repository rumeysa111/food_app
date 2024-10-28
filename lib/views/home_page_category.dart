import 'package:flutter/material.dart';
import '../screens/category_list.dart';

class HomePageCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Tarifi Uygulaması',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ne Öğrenmek İstiyorsun?👨🏾‍🍳🍨'),
          backgroundColor: Colors.orange, // AppBar rengi turuncu tonu
        ),
        body: CategoryList(), // Kategori listesini burada çağırın
      ),
    );
  }
}
