import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _managerController = TextEditingController();
  final ProjectService _projectService = ProjectService();

  Future<void> _addProject() async {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: '', // Firestore generará el ID
        name: _nameController.text,
        location: _locationController.text,
        technicalManager: _managerController.text,
      );
      await _projectService.addProject(newProject);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Proyecto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Proyecto'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _managerController,
                decoration: const InputDecoration(labelText: 'Responsable Técnico'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProject,
                child: const Text('Guardar Proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
