import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubicador_pro/src/models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener la colección de proyectos para el usuario actual
  CollectionReference<Project> _getProjectsCollection() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('projects')
        .withConverter<Project>(
          fromFirestore: (snapshots, _) => Project.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (project, _) => project.toFirestore(),
        );
  }

  // Stream para obtener los proyectos en tiempo real
  Stream<QuerySnapshot<Project>> getProjects() {
    return _getProjectsCollection().snapshots();
  }

  // Añadir un nuevo proyecto
  Future<void> addProject(Project project) {
    return _getProjectsCollection().add(project);
  }

  // Eliminar un proyecto
  Future<void> deleteProject(String projectId) {
    return _getProjectsCollection().doc(projectId).delete();
  }
}
