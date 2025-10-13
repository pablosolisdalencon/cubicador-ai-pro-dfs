class ConstructionMaterial {
  final String id;
  final String name;
  final String unit; // Por ejemplo: m³, m², kg, pza
  final double price; // Precio por unidad
  final double performance; // Rendimiento (opcional, para cálculos futuros)

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
