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
    final double volumenUnitario = largo * ancho * alto;
    final double volumenTotal = volumenUnitario * unidades;
    final double costoTotal = volumenTotal * material.price;

    Future<void> _saveCubication() async {
      final newItem = CubicationItem(
        id: '', // Firestore will generate
        workType: workType,
        materialName: material.name,
        materialUnit: material.unit,
        materialPrice: material.price,
        largo: largo,
        ancho: ancho,
        alto: alto,
        unidades: unidades,
        totalVolume: volumenTotal,
        totalCost: costoTotal,
        createdAt: Timestamp.now(),
      );

      await projectService.addCubicationItem(projectId, newItem);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cubicación guardada en el proyecto.')),
        );
        // Regresar a la pantalla de detalles del proyecto
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
            Text('Volumen por Unidad: ${volumenUnitario.toStringAsFixed(2)} m³'),
            Text(
              'Cantidad Total de Material: ${volumenTotal.toStringAsFixed(2)} ${material.unit}',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
