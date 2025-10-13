import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cubicador_pro/src/models/cubication_item_model.dart';
import 'package:excel/excel.dart';

class ReportService {
  // ... (generatePdfReport se mantiene igual)
  Future<Uint8List> generatePdfReport(
    String projectName,
    List<CubicationItem> items, {
    Uint8List? signatureImage,
  }) async {
    final pdf = pw.Document();
    final double totalCost = items.fold(0.0, (sum, item) => sum + item.totalCost);
    final Map<String, double> materialTotals = {};
    for (var item in items) {
      materialTotals.update('${item.materialName} (${item.materialUnit})', (value) => value + item.totalVolume, ifAbsent: () => item.totalVolume);
    }
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Reporte de Cubicación: $projectName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
            pw.Header(level: 1, text: 'Resumen General'),
            pw.Paragraph(text: 'Costo Total Estimado: \$${totalCost.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, color: PdfColors.green)),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, text: 'Desglose por Material'),
            pw.Table.fromTextArray(context: context, headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold), headers: ['Material', 'Cantidad Total'], data: materialTotals.entries.map((entry) => [entry.key, entry.value.toStringAsFixed(2)]).toList()),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, text: 'Detalle de Ítems'),
            ...items.map((item) => pw.Container(margin: const pw.EdgeInsets.only(bottom: 10), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text('${item.workType} - ${item.materialName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('Dimensiones: ${item.largo}x${item.ancho}x${item.alto} m, Unidades: ${item.unidades}'), pw.Text('Volumen Total: ${item.totalVolume.toStringAsFixed(2)} ${item.materialUnit}'), pw.Text('Costo: \$${item.totalCost.toStringAsFixed(2)}'), pw.Divider()]))).toList(),
            if (signatureImage != null) ...[pw.SizedBox(height: 40), pw.Header(level: 1, text: 'Firma de Conformidad'), pw.Image(pw.MemoryImage(signatureImage), width: 150, alignment: pw.Alignment.centerLeft)]
          ];
        },
      ),
    );
    return pdf.save();
  }

  // NUEVO: Método para generar un reporte en Excel
  Future<List<int>?> generateExcelReport(String projectName, List<CubicationItem> items) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];
    sheet.sheetName = 'Reporte Cubicador Pro';

    // Título
    sheet.cell(CellIndex.indexByString('A1')).value = 'Reporte de Cubicación: $projectName';

    // Cabeceras
    final headers = [
      'Tipo de Obra', 'Material', 'Largo (m)', 'Ancho (m)', 'Alto (m)',
      'Unidades', 'Cantidad Total', 'Unidad Material', 'Costo Total'
    ];
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2)).value = headers[i];
    }

    // Datos
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final row = i + 3;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = item.workType;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = item.materialName;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = item.largo;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = item.ancho;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = item.alto;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = item.unidades;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = item.totalVolume;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = item.materialUnit;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = item.totalCost;
    }

    // Guardar el archivo
    return excel.save();
  }
}
