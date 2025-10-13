import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubicador_pro/src/cubication/cubication_form_screen.dart';
import 'package:cubicador_pro/src/models/cubication_item_model.dart';
import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/projects/edit_project_screen.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:cubicador_pro/src/reports/report_screen.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  final String projectName;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    final ProjectService projectService = ProjectService();

    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Proyecto',
            onPressed: () {
              // Necesitamos el objeto Project completo para editarlo
              // Lo ideal sería obtenerlo de Firestore o pasarlo desde la pantalla anterior
              // Por simplicidad, crearemos uno aquí (en una app real esto sería diferente)
              projectService.getProjects().first.then((snapshot) {
                final projectDoc = snapshot.docs.firstWhere((doc) => doc.id == projectId);
                final project = projectDoc.data();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectScreen(project: project),
                  ),
                );
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.assessment),
            tooltip: 'Generar Reporte',
            onPressed: () {
              projectService.getProjectItems(projectId).first.then((snapshot) {
                final items = snapshot.docs.map((doc) => doc.data()).toList();
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportScreen(
                        projectName: projectName,
                        items: items,
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<CubicationItem>>(
        stream: projectService.getProjectItems(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los ítems.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Este proyecto no tiene cubicaciones. ¡Añade una!'));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text('${item.workType} - ${item.materialName}'),
                  subtitle: Text(
                      'Volumen: ${item.totalVolume.toStringAsFixed(2)} ${item.materialUnit} | Costo: \$${item.totalCost.toStringAsFixed(2)}'),
                  trailing: Text(
                    '${item.createdAt.toDate().day}/${item.createdAt.toDate().month}/${item.createdAt.toDate().year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CubicationFormScreen(projectId: projectId),
            ),
          );
        },
        child: const Icon(Icons.add_chart),
        tooltip: 'Nueva Cubicación',
      ),
    );
  }
}
