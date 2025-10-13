import 'package:flutter/material.dart';

class CubicationResultsScreen extends StatelessWidget {
  final String workType;
  final double largo;
  final double ancho;
  final double alto;
  final int unidades;

  const CubicationResultsScreen({
    super.key,
    required this.workType,
    required this.largo,
    required this.ancho,
    required this.alto,
    required this.unidades,
  });

  @override
  Widget build(BuildContext context) {
    final double volumenUnitario = largo * ancho * alto;
    final double volumenTotal = volumenUnitario * unidades;

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
            const SizedBox(height: 10),
            Text('Tipo de Obra: $workType'),
            Text('Dimensiones: $largo\m x $ancho\m x $alto\m'),
            Text('Unidades: $unidades'),
            const SizedBox(height: 20),
            Text('Volumen por Unidad: ${volumenUnitario.toStringAsFixed(2)} m³'),
            Text('Volumen Total: ${volumenTotal.toStringAsFixed(2)} m³'),
          ],
        ),
      ),
    );
  }
}
