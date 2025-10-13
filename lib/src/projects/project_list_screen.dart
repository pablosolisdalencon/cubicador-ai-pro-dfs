import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubicador_pro/src/materials/material_list_screen.dart';
import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/projects/add_project_screen.dart';
import 'package:cubicador_pro/src/projects/project_details_screen.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final ProjectService _projectService = ProjectService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myProjects),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory),
            tooltip: 'Catálogo de Materiales',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MaterialListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Project>>(
        stream: _projectService.getProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los proyectos.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tienes proyectos. ¡Añade uno!'));
          }

          final projectDocs = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Vista de Cuadrícula para pantallas anchas (web/tableta)
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: projectDocs.length,
                  itemBuilder: (context, index) {
                    final project = projectDocs[index].data();
                    final projectId = projectDocs[index].id;
                    return Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () => _navigateToDetails(context, projectId, project.name),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.foundation, size: 40),
                            const SizedBox(height: 8),
                            Text(project.name, style: Theme.of(context).textTheme.titleMedium),
                            Text(project.location, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Vista de Lista para pantallas estrechas (móvil)
                return ListView.builder(
                  itemCount: projectDocs.length,
                  itemBuilder: (context, index) {
                    final project = projectDocs[index].data();
                    final projectId = projectDocs[index].id;
                    return Dismissible(
                      key: Key(projectId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        _projectService.deleteProject(projectId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${project.name} eliminado')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(project.name),
                        subtitle: Text(project.location),
                        onTap: () => _navigateToDetails(context, projectId, project.name),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProjectScreen(),
            ),
          );
        },
        tooltip: l10n.addProject,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, String projectId, String projectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(
          projectId: projectId,
          projectName: projectName,
        ),
      ),
    );
  }
}
