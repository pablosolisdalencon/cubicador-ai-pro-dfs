class ConstructionMaterial {
  final String id;
  final String name;
  final String unit;
  final double price;
  final double performance;

  ConstructionMaterial({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    this.performance = 0.0,
  });

  factory ConstructionMaterial.fromFirestore(Map<String, dynamic> data, String id) {
    return ConstructionMaterial(
      id: id,
      name: data['name'] ?? '',
      unit: data['unit'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      performance: (data['performance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
      'performance': performance,
    };
  }
}
