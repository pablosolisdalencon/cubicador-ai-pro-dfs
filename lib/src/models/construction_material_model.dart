enum MaterialType { volume, area, unit }

class ConstructionMaterial {
  final String id;
  final String name;
  final String unit; // Por ejemplo: m³, m², kg, pza
  final double price; // Precio por unidad
  final double performance; // Rendimiento (ej: pzas/m²)
  final MaterialType type;

  ConstructionMaterial({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    this.performance = 0.0,
    this.type = MaterialType.volume,
  });

  factory ConstructionMaterial.fromFirestore(Map<String, dynamic> data, String id) {
    return ConstructionMaterial(
      id: id,
      name: data['name'] ?? '',
      unit: data['unit'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      performance: (data['performance'] ?? 0.0).toDouble(),
      type: MaterialType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => MaterialType.volume,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
      'performance': performance,
      'type': type.toString(),
    };
  }
}
