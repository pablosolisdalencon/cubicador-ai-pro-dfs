import 'package:cloud_firestore/cloud_firestore.dart';

class CubicationItem {
  final String id;
  final String workType;
  final String materialName;
  final String materialUnit;
  final double materialPrice;
  final double largo;
  final double ancho;
  final double alto;
  final int unidades;
  final double totalVolume;
  final double totalCost;
  final Timestamp createdAt;

  CubicationItem({
    required this.id,
    required this.workType,
    required this.materialName,
    required this.materialUnit,
    required this.materialPrice,
    required this.largo,
    required this.ancho,
    required this.alto,
    required this.unidades,
    required this.totalVolume,
    required this.totalCost,
    required this.createdAt,
  });

  factory CubicationItem.fromFirestore(Map<String, dynamic> data, String id) {
    return CubicationItem(
      id: id,
      workType: data['workType'] ?? '',
      materialName: data['materialName'] ?? '',
      materialUnit: data['materialUnit'] ?? '',
      materialPrice: (data['materialPrice'] ?? 0.0).toDouble(),
      largo: (data['largo'] ?? 0.0).toDouble(),
      ancho: (data['ancho'] ?? 0.0).toDouble(),
      alto: (data['alto'] ?? 0.0).toDouble(),
      unidades: data['unidades'] ?? 0,
      totalVolume: (data['totalVolume'] ?? 0.0).toDouble(),
      totalCost: (data['totalCost'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'workType': workType,
      'materialName': materialName,
      'materialUnit': materialUnit,
      'materialPrice': materialPrice,
      'largo': largo,
      'ancho': ancho,
      'alto': alto,
      'unidades': unidades,
      'totalVolume': totalVolume,
      'totalCost': totalCost,
      'createdAt': createdAt,
    };
  }
}
