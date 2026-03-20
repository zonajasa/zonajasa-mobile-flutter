class LayananJasa {
  final String id;
  final String serviceId;
  final String name;
  final double harga;

  LayananJasa({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.harga,
  });

  factory LayananJasa.fromJson(Map<String, dynamic> json) {
    return LayananJasa(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      name: json['name'] as String,
      harga: (json['harga'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'serviceId': serviceId, 'name': name, 'harga': harga};
  }
}

// Example LayananJasa for demo
List<LayananJasa> demoLayananJasa = [
  LayananJasa(
    id: '1',
    serviceId: '1',
    name: "Perbaikan Kompor",
    harga: 500.000,
  ),
  LayananJasa(
    id: '2',
    serviceId: '1',
    name: "Clanning service",
    harga: 120.000,
  ),
  LayananJasa(
    id: '3',
    serviceId: '2',
    name: "Instalasi Listrik",
    harga: 50.000,
  ),
  LayananJasa(
    id: '4',
    serviceId: '2',
    name: "Perbaikan Trafo Listrik",
    harga: 100.000,
  ),
  LayananJasa(
    id: '5',
    serviceId: '3',
    name: "Tukang bersih kebun",
    harga: 30.000,
  ),
  LayananJasa(id: '6', serviceId: '3', name: "Penebang Pohon", harga: 10.000),
  LayananJasa(id: '7', serviceId: '4', name: "Service Mobil", harga: 35.000),
  LayananJasa(id: '8', serviceId: '4', name: "Service Motor", harga: 60.000),
  LayananJasa(id: '9', serviceId: '5', name: "Tukang Bangunan", harga: 90.000),
  LayananJasa(
    id: '10',
    serviceId: '5',
    name: "Pemasangan Plafon",
    harga: 80.000,
  ),
  LayananJasa(
    id: '11',
    serviceId: '6',
    name: "Pemadam kebakaran",
    harga: 120.000,
  ),
  LayananJasa(
    id: '12',
    serviceId: '6',
    name: "supir ambulance",
    harga: 800.000,
  ),
  LayananJasa(
    id: '13',
    serviceId: '1',
    name: "Perbaikan Kompor",
    harga: 500.000,
  ),
  LayananJasa(id: '14', serviceId: '1', name: "Clanning Hp", harga: 120.000),
  LayananJasa(id: '15', serviceId: '1', name: "Perbaikan TV", harga: 500.000),
  LayananJasa(id: '16', serviceId: '1', name: "Clanning Room", harga: 120.000),
  LayananJasa(
    id: '17',
    serviceId: '1',
    name: "Perbaikan Laptop",
    harga: 500.000,
  ),
  LayananJasa(id: '18', serviceId: '1', name: "Clanning", harga: 120.000),
];
