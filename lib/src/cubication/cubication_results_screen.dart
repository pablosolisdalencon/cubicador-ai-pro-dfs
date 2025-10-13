import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubicador_pro/src/models/cubication_item_model.dart';
import 'package:cubicador_pro/src/models/construction_material_model.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:flutter/material.dart';

class CubicationResultsScreen extends StatelessWidget {
  final String projectId;
  final String workType;
  final ConstructionMaterial material;
  final double largo;
  final double ancho;
  final double alto;
  final int unidades;

  const CubicationResultsScreen({
    super.key,
    required this.projectId,
    required this.workType,
    required this.material,
    required this.largo,
    required this.ancho,
    required this.alto,
    required this.unidades,
  });

  @override
  Widget build(BuildContext context) {
    final ProjectService projectService = ProjectService();

    // --- Lógica de Cálculo Avanzado ---
    double primaryMeasure = 0;
    double totalQuantity = 0;
    String measureLabel = '';

    if (material.type == MaterialType.volume) {
      primaryMeasure = largo * ancho * alto;
      totalQuantity = primaryMeasure * unidades;
      measureLabel = 'Volumen Total';
    } else if (material.type == MaterialType.area) {
      primaryMeasure = largo * alto; // Asumimos que para área, lo importante es largo x alto (ej. un muro)
      totalQuantity = primaryMeasure * unidades;
      measureLabel = 'Área Total';
      if (material.performance > 0) {
        totalQuantity = totalQuantity * material.performance;
        measureLabel = 'Cantidad Total Estimada';
      }
    } else { // MaterialType.unit
      totalQuantity = unidades.toDouble();
      measureLabel = 'Cantidad Total';
    }

    final double costoTotal = totalQuantity * material.price;

    Future<void> _saveCubication() async {
      final newItem = CubicationItem(
        id: '',
        workType: workType,
        materialName: material.name,
        materialUnit: material.unit,
        materialPrice: material.price,
        largo: largo,
        ancho: ancho,
        alto: alto,
        unidades: unidades,
        totalVolume: totalQuantity, // Guardamos la cantidad calculada, no necesariamente el volumen
        totalCost: costoTotal,
        createdAt: Timestamp.now(),
      );
      await projectService.addCubicationItem(projectId, newItem);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cubicación guardada en el proyecto.')),
        );
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Cubicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumen de la Cubicación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Tipo de Obra: $workType'),
            Text('Material Seleccionado: ${material.name}'),
            const SizedBox(height: 10),
            Text('Dimensiones por Unidad: $largo\m x $ancho\m x $alto\m'),
            Text('Número de Unidades: $unidades'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              '$measureLabel: ${totalQuantity.toStringAsFixed(2)} ${material.unit}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Costo Total Estimado: \$${costoTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar en el Proyecto'),
                onPressed: _saveCubication,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
