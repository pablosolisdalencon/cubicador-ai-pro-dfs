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

  factory Project.fromFirestore(Map<String, dynamic> data, String id) {
    return Project(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      technicalManager: data['technicalManager'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'technicalManager': technicalManager,
    };
  }
}
