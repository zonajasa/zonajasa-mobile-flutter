class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}

// Example categories for demo
List<Category> demoCategories = [
  Category(id: '1', name: 'Tukang', image: 'images/BlueWrench.png'),
  Category(id: '2', name: 'Listrik', image: 'images/YellowLightning.png'),
  Category(id: '3', name: 'Kebersihan', image: 'images/BlueCircle.png'),
  Category(id: '4', name: 'Service', image: 'images/BlueCar.png'),
  Category(id: '5', name: 'Bangunan', image: 'images/YellowLightning.png'),
  Category(id: '6', name: 'Darurat', image: 'images/BlueCircle.png'),
  Category(id: '7', name: 'Otomotif', image: 'images/BlueCircle.png'),
];
