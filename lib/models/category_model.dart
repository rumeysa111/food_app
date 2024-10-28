class Category {
  final String strCategory;
  final String strCategoryThumb;
  final String name;

  Category({required this.strCategory, required this.strCategoryThumb, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      strCategory: json['strCategory'],
      strCategoryThumb: json['strCategoryThumb'],
      name: json['name'] ?? '', // JSON içinde `name` yoksa varsayılan boş string kullan
    );
  }
}
