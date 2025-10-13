import 'package:cubicador_pro/src/models/cubication_item_model.dart';
import 'package:cubicador_pro/src/reports/report_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReportScreen extends StatelessWidget {
  final String projectName;
  final List<CubicationItem> items;

  const ReportScreen({
    super.key,
    required this.projectName,
    required this.items,
  });

  // Método para calcular el costo total del proyecto
  double get _totalCost {
    return items.fold(0.0, (sum, item) => sum + item.totalCost);
  }

  // Método para agrupar y sumar las cantidades por material
  Map<String, double> get _materialTotals {
    final Map<String, double> totals = {};
    for (var item in items) {
      totals.update(
        '${item.materialName} (${item.materialUnit})',
        (value) => value + item.totalVolume,
        ifAbsent: () => item.totalVolume,
      );
    }
    return totals;
  }

  Future<void> _exportAndShareReport(BuildContext context) async {
    final reportService = ReportService();
    final pdfBytes = await reportService.generatePdfReport(projectName, items);

    // Guardar el archivo temporalmente para poder compartirlo
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/reporte_$projectName.pdf').writeAsBytes(pdfBytes);

    if (context.mounted) {
       await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Reporte de Cubicación para el proyecto: $projectName',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialTotals = _materialTotals;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte: $projectName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Exportar Reporte',
            onPressed: () => _exportAndShareReport(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sección de Resumen General
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen General',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Costo Total Estimado:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '\$${_totalCost.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sección de Totales por Material
          Text(
            'Desglose por Material',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: materialTotals.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final materialName = materialTotals.keys.elementAt(index);
                final totalAmount = materialTotals.values.elementAt(index);
                return ListTile(
                  title: Text(materialName),
                  trailing: Text(
                    totalAmount.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
