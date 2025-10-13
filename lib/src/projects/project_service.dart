import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/models/cubication_item_model.dart';

// NOTA DE ARQUITECTURA: ... (comentario de offline se mantiene)

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ... (métodos de Proyectos se mantienen igual)
  CollectionReference<Project> _getProjectsCollection() {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado.');
    return _firestore
        .collection('users').doc(user.uid).collection('projects')
        .withConverter<Project>(
          fromFirestore: (snapshots, _) => Project.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (project, _) => project.toFirestore(),
        );
  }
  Stream<QuerySnapshot<Project>> getProjects() => _getProjectsCollection().snapshots();
  Future<void> addProject(Project project) => _getProjectsCollection().add(project);
  Future<void> updateProject(String projectId, Project project) => _getProjectsCollection().doc(projectId).update(project.toFirestore());
  Future<void> deleteProject(String projectId) => _getProjectsCollection().doc(projectId).delete();

  // --- Métodos para Items de Cubicación ---

  CollectionReference<CubicationItem> _getProjectItemsCollection(String projectId) {
    return _getProjectsCollection().doc(projectId).collection('items')
        .withConverter<CubicationItem>(
          fromFirestore: (snapshots, _) => CubicationItem.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (item, _) => item.toFirestore(),
        );
  }

  Stream<QuerySnapshot<CubicationItem>> getProjectItems(String projectId) {
    return _getProjectItemsCollection(projectId).orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> addCubicationItem(String projectId, CubicationItem item) {
    return _getProjectItemsCollection(projectId).add(item);
  }

  // NUEVO: Actualizar un item de cubicación
  Future<void> updateCubicationItem(String projectId, String itemId, CubicationItem item) {
    return _getProjectItemsCollection(projectId).doc(itemId).update(item.toFirestore());
  }

  // NUEVO: Eliminar un item de cubicación
  Future<void> deleteCubicationItem(String projectId, String itemId) {
    return _getProjectItemsCollection(projectId).doc(itemId).delete();
  }
}
