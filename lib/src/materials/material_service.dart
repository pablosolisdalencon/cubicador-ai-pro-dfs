import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cubicador_pro/src/models/construction_material_model.dart';

class MaterialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<ConstructionMaterial> _getMaterialsCollection() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('materials')
        .withConverter<ConstructionMaterial>(
          fromFirestore: (snapshots, _) => ConstructionMaterial.fromFirestore(snapshots.data()!, snapshots.id),
          toFirestore: (material, _) => material.toFirestore(),
        );
  }

  Stream<QuerySnapshot<ConstructionMaterial>> getMaterials() {
    return _getMaterialsCollection().snapshots();
  }

  Future<void> addMaterial(ConstructionMaterial material) {
    return _getMaterialsCollection().add(material);
  }

  Future<void> updateMaterial(String materialId, ConstructionMaterial material) {
    return _getMaterialsCollection().doc(materialId).update(material.toFirestore());
  }

  Future<void> deleteMaterial(String materialId) {
    return _getMaterialsCollection().doc(materialId).delete();
  }
}
