class LayananJasa {
  final String id;
  final String serviceId;
  final String categoryId;
  final String name;
  final double harga;
  final String image;

  LayananJasa({
    required this.id,
    required this.serviceId,
    required this.categoryId,
    required this.name,
    required this.harga,
    required this.image,
  });

  factory LayananJasa.fromJson(Map<String, dynamic> json) {
    return LayananJasa(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      harga: (json['harga'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'name': name,
      'harga': harga,
      'categoryId': categoryId,
      'image': image,
    };
  }
}

// Example LayananJasa for demo
List<LayananJasa> demoLayananJasa = [
  LayananJasa(
    id: '1',
    serviceId: '1',
    categoryId: '1',
    name: "Perbaikan Kompor",
    harga: 500000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '2',
    serviceId: '1',
    categoryId: '1',
    name: "Clanning service",
    harga: 120000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '3',
    serviceId: '2',
    categoryId: '1',
    name: "Instalasi Listrik",
    harga: 50000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '4',
    serviceId: '2',
    categoryId: '1',
    name: "Perbaikan Trafo Listrik",
    harga: 100000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '5',
    serviceId: '3',
    categoryId: '2',
    name: "Tukang bersih kebun",
    harga: 30000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '6',
    serviceId: '3',
    categoryId: '2',
    name: "Penebang Pohon",
    harga: 10000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '7',
    serviceId: '4',
    categoryId: '2',
    name: "Service Mobil",
    harga: 35000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '8',
    serviceId: '4',
    categoryId: '2',
    name: "Service Motor",
    harga: 60000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '9',
    serviceId: '5',
    categoryId: '3',
    name: "Tukang Bangunan",
    harga: 90000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '10',
    serviceId: '5',
    categoryId: '3',
    name: "Pemasangan Plafon",
    harga: 80000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '11',
    serviceId: '6',
    categoryId: '4',
    name: "Pemadam kebakaran",
    harga: 120000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '12',
    serviceId: '6',
    categoryId: '4',
    name: "supir ambulance",
    harga: 800000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '13',
    serviceId: '1',
    categoryId: '1',
    name: "Perbaikan Kompor",
    harga: 500000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '14',
    serviceId: '1',
    categoryId: '1',
    name: "Clanning Hp",
    harga: 120000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '15',
    serviceId: '1',
    categoryId: '1',
    name: "Perbaikan TV",
    harga: 500000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '16',
    serviceId: '1',
    categoryId: '1',
    name: "Clanning Room",
    harga: 120000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '17',
    serviceId: '1',
    categoryId: '1',
    name: "Perbaikan Laptop",
    harga: 500000,
    image: 'images/c.png',
  ),
  LayananJasa(
    id: '18',
    serviceId: '1',
    categoryId: '1',
    name: "Clanning",
    harga: 120000,
    image: 'images/c.png',
  ),
];
