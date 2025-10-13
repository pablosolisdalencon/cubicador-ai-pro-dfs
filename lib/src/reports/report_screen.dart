import 'package:cubicador_pro/src/models/cubication_item_model.dart';
import 'package:cubicador_pro/src/reports/report_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class ReportScreen extends StatefulWidget {
  final String projectName;
  final List<CubicationItem> items;

  const ReportScreen({super.key, required this.projectName, required this.items});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  Uint8List? _signatureImage;

  double get _totalCost => widget.items.fold(0.0, (sum, item) => sum + item.totalCost);

  Map<String, double> get _materialTotals {
    final Map<String, double> totals = {};
    for (var item in widget.items) {
      totals.update('${item.materialName} (${item.materialUnit})', (value) => value + item.totalVolume, ifAbsent: () => item.totalVolume);
    }
    return totals;
  }

  Future<void> _exportAndShareReport({required String format}) async {
    final reportService = ReportService();
    String fileName;
    List<int>? fileBytes;

    if (format == 'pdf') {
      fileName = 'reporte_${widget.projectName}.pdf';
      fileBytes = await reportService.generatePdfReport(widget.projectName, widget.items, signatureImage: _signatureImage);
    } else if (format == 'excel') {
      fileName = 'reporte_${widget.projectName}.xlsx';
      fileBytes = await reportService.generateExcelReport(widget.projectName, widget.items);
    } else {
      return;
    }

    if (fileBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$fileName').writeAsBytes(fileBytes);

    if (mounted) {
      await Share.shareXFiles([XFile(file.path)], text: 'Reporte de Cubicación para: ${widget.projectName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte: ${widget.projectName}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _exportAndShareReport(format: value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'pdf',
                child: Text('Exportar a PDF'),
              ),
              const PopupMenuItem<String>(
                value: 'excel',
                child: Text('Exportar a Excel'),
              ),
            ],
            icon: const Icon(Icons.share),
            tooltip: 'Exportar Reporte',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ... (el resto de la UI se mantiene igual)
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumen General', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text('Costo Total Estimado:', style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '\$${_totalCost.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Desglose por Material', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _materialTotals.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final materialName = _materialTotals.keys.elementAt(index);
                final totalAmount = _materialTotals.values.elementAt(index);
                return ListTile(
                  title: Text(materialName),
                  trailing: Text(totalAmount.toStringAsFixed(2), style: Theme.of(context).textTheme.bodyLarge),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('Firma de Conformidad', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (_signatureImage != null)
            Column(
              children: [
                const Text('Firma guardada:'),
                Image.memory(_signatureImage!),
                TextButton(onPressed: () => setState(() => _signatureImage = null), child: const Text('Firmar de nuevo'))
              ],
            )
          else
            Card(
              elevation: 2,
              child: Column(
                children: [
                  Signature(controller: _controller, height: 200, backgroundColor: Colors.grey[200]!),
                  Container(
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(icon: const Icon(Icons.check), color: Colors.green, onPressed: () async {
                          if (_controller.isNotEmpty) {
                            final image = await _controller.toPngBytes();
                            setState(() => _signatureImage = image);
                          }
                        }, tooltip: 'Confirmar Firma'),
                        IconButton(icon: const Icon(Icons.clear), color: Colors.red, onPressed: () => _controller.clear(), tooltip: 'Limpiar'),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
