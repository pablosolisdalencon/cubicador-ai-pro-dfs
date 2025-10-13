import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cubicador_pro/src/models/cubication_item_model.dart';

class ReportService {
  Future<Uint8List> generatePdfReport(String projectName, List<CubicationItem> items) async {
    final pdf = pw.Document();

    // Método para calcular el costo total del proyecto
    final double totalCost = items.fold(0.0, (sum, item) => sum + item.totalCost);

    // Método para agrupar y sumar las cantidades por material
    final Map<String, double> materialTotals = {};
    for (var item in items) {
      materialTotals.update(
        '${item.materialName} (${item.materialUnit})',
        (value) => value + item.totalVolume,
        ifAbsent: () => item.totalVolume,
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Título
            pw.Header(
              level: 0,
              child: pw.Text('Reporte de Cubicación: $projectName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),

            // Resumen General
            pw.Header(level: 1, text: 'Resumen General'),
            pw.Paragraph(
              text: 'Costo Total Estimado: \$${totalCost.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 18, color: PdfColors.green),
            ),
            pw.SizedBox(height: 20),

            // Desglose por Material
            pw.Header(level: 1, text: 'Desglose por Material'),
            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ['Material', 'Cantidad Total'],
              data: materialTotals.entries.map((entry) {
                return [entry.key, entry.value.toStringAsFixed(2)];
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            // Lista detallada de ítems
            pw.Header(level: 1, text: 'Detalle de Ítems'),
            ...items.map((item) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${item.workType} - ${item.materialName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Dimensiones: ${item.largo}x${item.ancho}x${item.alto} m, Unidades: ${item.unidades}'),
                    pw.Text('Volumen Total: ${item.totalVolume.toStringAsFixed(2)} ${item.materialUnit}'),
                    pw.Text('Costo: \$${item.totalCost.toStringAsFixed(2)}'),
                    pw.Divider(),
                  ]
                )
              );
            }).toList(),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
