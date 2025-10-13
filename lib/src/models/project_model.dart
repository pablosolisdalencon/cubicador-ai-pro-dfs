class Project {
  final String id;
  final String name;
  final String location;
  final String technicalManager;

  Project({
    required this.id,
    required this.name,
    required this.location,
    required this.technicalManager,
  });

  // Factory constructor para crear una instancia desde un documento de Firestore
  factory Project.fromFirestore(Map<String, dynamic> data, String id) {
    return Project(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      technicalManager: data['technicalManager'] ?? '',
    );
  }

  // Método para convertir una instancia a un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'technicalManager': technicalManager,
    };
  }
}
