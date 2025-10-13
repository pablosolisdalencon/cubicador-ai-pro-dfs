import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/models/cubication_item_model.dart';

// NOTA DE ARQUITECTURA:
// Este servicio, y la aplicación en general, se benefician del soporte offline
// por defecto que ofrece el SDK de Firestore para plataformas móviles.
// Firestore mantiene un caché local de los datos. Las lecturas primero intentan
// usar el caché, proporcionando acceso a los datos sin conexión. Las escrituras
// se encolan y se ejecutan cuando se recupera la conexión.
// No se requiere código adicional para habilitar este comportamiento en Android/iOS.

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

  // Obtener la colección de items para un proyecto específico
  CollectionReference<CubicationItem> _getProjectItemsCollection(String projectId) {
    return _getProjectsCollection()
        .doc(projectId)
        .collection('items')
        .withConverter<CubicationItem>(
          fromFirestore: (snapshots, _) => CubicationItem.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (item, _) => item.toFirestore(),
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

  // Stream para obtener los items de un proyecto
  Stream<QuerySnapshot<CubicationItem>> getProjectItems(String projectId) {
    return _getProjectItemsCollection(projectId).orderBy('createdAt', descending: true).snapshots();
  }

  // Añadir un nuevo item de cubicación a un proyecto
  Future<void> addCubicationItem(String projectId, CubicationItem item) {
    return _getProjectItemsCollection(projectId).add(item);
  }
}
