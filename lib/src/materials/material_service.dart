import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubicador_pro/src/models/material_model.dart';

class MaterialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener la colección de materiales para el usuario actual
  CollectionReference<Material> _getMaterialsCollection() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('materials')
        .withConverter<Material>(
          fromFirestore: (snapshots, _) => Material.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (material, _) => material.toFirestore(),
        );
  }

  // Stream para obtener los materiales en tiempo real
  Stream<QuerySnapshot<Material>> getMaterials() {
    return _getMaterialsCollection().snapshots();
  }

  // Añadir un nuevo material
  Future<void> addMaterial(Material material) {
    return _getMaterialsCollection().add(material);
  }

  // Eliminar un material
  Future<void> deleteMaterial(String materialId) {
    return _getMaterialsCollection().doc(materialId).delete();
  }
}
