class Service {
  final String id;
  final String name;
  final String layanan;
  final String company;
  final String description;
  final double price;
  final String categoryId;
  final String image;
  final double rating;
  final String jarak;
  final int reviewCount;
  final int bookingCount;
  final List<String> images;
  final List<String> features;
  final bool isFeatured;
  final bool isPopular;

  Service({
    required this.id,
    required this.name,
    required this.layanan,
    required this.company,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.rating,
    required this.jarak,
    required this.reviewCount,
    required this.bookingCount,
    required this.images,
    required this.features,
    this.isFeatured = false,
    this.isPopular = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String,
      layanan: json['layanan'] as String,
      jarak: json['jarak'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      bookingCount: json['bookingCount'] as int,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isFeatured: json['isFeatured'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'layanan': layanan,
      'company': company,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'bookingCount': bookingCount,
      'images': images,
      'features': features,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
    };
  }
}

// Example services for demo
List<Service> demoServices = [
  Service(
    id: '1',
    name: 'Standard Home Cleaning',
    layanan: 'Tukang - Service AC',
    company: 'CV. Budi Mandiri',
    description:
        'Professional cleaning service to make your home spotless and fresh. Our team uses eco-friendly products and advanced cleaning techniques.',
    price: 120,
    categoryId: '1',
    jarak: '10 km',
    image: 'images/orang.png',
    rating: 4.8,
    reviewCount: 245,
    bookingCount: 1250,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'Dusting all accessible surfaces',
      'Vacuuming carpets and floors',
      'Mopping all floors',
      'Cleaning kitchen surfaces',
      'Cleaning bathrooms',
      'Waste removal',
    ],
    isFeatured: true,
    isPopular: true,
  ),
  Service(
    id: '2',
    name: 'Deep Cleaning Service',
    layanan: 'Listrik - Instalasi',
    company: 'CV. Sari Jaya',
    description:
        'A thorough cleaning service for homes that need extra attention. Includes cleaning inside appliances, behind furniture, and detailed scrubbing.',
    price: 220,
    categoryId: '1',
    jarak: '5 km',
    image: 'images/orang.png',
    rating: 4.9,
    reviewCount: 189,
    bookingCount: 876,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'All standard cleaning tasks',
      'Inside oven and refrigerator cleaning',
      'Cabinet interiors',
      'Window cleaning',
      'Baseboards and door frames',
      'Light fixtures and ceiling fans',
    ],
    isFeatured: true,
  ),
  Service(
    id: '3',
    name: 'Pipe Leak Repair',
    layanan: 'Pipe Leak Repair',
    company: 'CV. Anton Sejahtera',
    description:
        'Fast and reliable repair for any pipe leaks in your home. Our certified plumbers fix all types of pipe leaks to prevent water damage.',
    price: 90,
    categoryId: '2',
    jarak: '10 km',
    image: 'images/orang.png',
    rating: 4.7,
    reviewCount: 156,
    bookingCount: 735,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'Leak detection',
      'Pipe repair or replacement',
      'Water pressure testing',
      'Fixture inspection',
      'Joint sealing',
      '30-day guarantee',
    ],
    isPopular: true,
  ),
  Service(
    id: '4',
    name: 'Bathroom Installation',
    layanan: 'Bathroom Installation',
    company: 'CV. Anton Sejahtera',
    description:
        'Complete bathroom installation service including fixtures, plumbing, and finishing. Transform your bathroom with our expert plumbers.',
    price: 580,
    categoryId: '2',
    jarak: '10 km',
    image: 'images/orang.png',
    rating: 4.9,
    reviewCount: 122,
    bookingCount: 450,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'Fixture installation',
      'Plumbing connection',
      'Tile installation',
      'Waterproofing',
      'Vanity installation',
      'Final inspection and testing',
    ],
    isFeatured: true,
  ),
  Service(
    id: '5',
    name: 'Electrical Wiring',
    layanan: 'Electrical Wiring',
    company: 'CV. Anton Sejahtera',
    description:
        'Professional electrical wiring service for new installations or rewiring existing systems. All work meets safety codes and regulations.',
    price: 150,
    categoryId: '3',
    jarak: '30 km',
    image: 'images/orang.png',
    rating: 4.8,
    reviewCount: 178,
    bookingCount: 689,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'Circuit installation',
      'Panel upgrades',
      'Outlet installation',
      'Safety inspection',
      'Compliance with electrical codes',
      '1-year warranty on work',
    ],
    isPopular: true,
  ),
  Service(
    id: '6',
    name: 'Room Painting',
    layanan: 'Room Painting',
    company: 'CV. Anton Sejahtera',
    description:
        'Transform your space with our professional painting services. We use high-quality paints and techniques for a perfect finish.',
    price: 320,
    categoryId: '4',
    jarak: '14 km',
    image: 'images/orang.png',
    rating: 4.7,
    reviewCount: 205,
    bookingCount: 920,
    images: ['images/a.png', 'images/b.png', 'images/b.png'],
    features: [
      'Surface preparation',
      'Premium quality paint',
      'Edge protection',
      'Furniture protection',
      'Two coats of paint',
      'Clean-up after completion',
    ],
    isFeatured: true,
    isPopular: true,
  ),
];
