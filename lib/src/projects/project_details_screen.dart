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
              // Lógica para obtener el proyecto y navegar a la pantalla de edición
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

          final itemDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: itemDocs.length,
            itemBuilder: (context, index) {
              final item = itemDocs[index].data();
              final itemId = itemDocs[index].id;

              return Dismissible(
                key: Key(itemId),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  projectService.deleteCubicationItem(projectId, itemId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ítem eliminado')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('${item.workType} - ${item.materialName}'),
                    subtitle: Text(
                        'Volumen: ${item.totalVolume.toStringAsFixed(2)} ${item.materialUnit} | Costo: \$${item.totalCost.toStringAsFixed(2)}'),
                    trailing: Text(
                      '${item.createdAt.toDate().day}/${item.createdAt.toDate().month}/${item.createdAt.toDate().year}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      // Navegar a la pantalla de edición del ítem (futuro)
                    },
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
