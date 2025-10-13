import 'package:cubicador_pro/src/cubication/cubication_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:cubicador_pro/src/models/project_model.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final List<Project> _projects = [
    Project(
      id: '1',
      name: 'Casa Unifamiliar',
      location: 'Ciudad de México',
      technicalManager: 'Juan Pérez',
    ),
    Project(
      id: '2',
      name: 'Edificio de Oficinas',
      location: 'Monterrey',
      technicalManager: 'María García',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
      ),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return ListTile(
            title: Text(project.name),
            subtitle: Text(project.location),
            onTap: () {
              // Navegar a los detalles del proyecto
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CubicationFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
