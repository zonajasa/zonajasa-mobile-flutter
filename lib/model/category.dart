class Category {
  final String id;
  final String name;
  final String icon;
  final String image;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image': image,
      'description': description,
    };
  }
}

// Example categories for demo
List<Category> demoCategories = [
  Category(
    id: '1',
    name: 'Tukang',
    icon: 'images/BlueWrench.png',
    image: 'images/BlueWrench.png',
    description: 'Professional cleaning services for your home',
  ),
  Category(
    id: '2',
    name: 'Listrik',
    icon: 'images/YellowLightning.png',
    image: 'images/YellowLightning.png',
    description: 'Expert plumbers for all your plumbing needs',
  ),
  Category(
    id: '3',
    name: 'Kebersihan',
    icon: 'images/BlueCircle.png',
    image: 'images/BlueCircle.png',
    description: 'Certified electricians for installation and repairs',
  ),
  Category(
    id: '4',
    name: 'Service',
    icon: 'images/BlueCar.png',
    image: 'images/BlueCar.png',
    description: 'Transform your space with professional painting services',
  ),
  Category(
    id: '5',
    name: 'Bangunan',
    icon: 'images/YellowLightning.png',
    image: 'images/YellowLightning.png',
    description: 'Fixing all types of home appliances',
  ),
  Category(
    id: '6',
    name: 'Darurat',
    icon: 'images/BlueCircle.png',
    image: 'images/BlueCircle.png',
    description: 'Professional garden maintenance and landscaping',
  ),
];
