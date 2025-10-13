import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;

  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _managerController;
  final ProjectService _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _locationController = TextEditingController(text: widget.project.location);
    _managerController = TextEditingController(text: widget.project.technicalManager);
  }

  Future<void> _updateProject() async {
    if (_formKey.currentState!.validate()) {
      final updatedProject = Project(
        id: widget.project.id,
        name: _nameController.text,
        location: _locationController.text,
        technicalManager: _managerController.text,
      );
      await _projectService.updateProject(widget.project.id, updatedProject);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Proyecto'),
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
                onPressed: _updateProject,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
